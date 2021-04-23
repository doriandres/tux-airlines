const express = require('express');
const mysql = require('mysql');
const amqp = require('amqplib/callback_api');
const { v4: uuidv4 } = require('uuid');
const app = express();
app.use(express.json());

function createBrokerChannel(callback) {
    amqp.connect(process.env.RABBITMQ_URI, (err, connection) => {
        if (err) return callback(err);
        connection.createChannel((err, channel) => {
            if (err) return callback(err);
            callback(null, { connection, channel });
        });
    });
}

function callRPC(rpcName, args, callback) {
    createBrokerChannel((err, broker) => {
        if (err) {
            console.error(err.message);
            return callback({ message: "No se puede comunicar con el servicio en este momento" });
        }
        broker.channel.assertQueue('', { exclusive: true }, (err, { queue }) => {
            if (err) {
                console.error(err);
                return callback(err);
            }
            var correlationId = uuidv4();
            broker.channel.consume(queue, (msg) => {
                if (msg.properties.correlationId != correlationId) return;
                const { error, result } = JSON.parse(msg.content.toString());
                setTimeout(() => broker.connection.close(), 50);
                callback(error, result);
            }, { noAck: true });
            broker.channel.sendToQueue(rpcName, Buffer.from(JSON.stringify(args)), { correlationId: correlationId, replyTo: queue });
        })
    });
}

function obtenerPrecioOferta(oferta_id, callback) {
    callRPC('obtener_precio_oferta', { oferta_id }, callback);
}

function disminuirOferta(oferta_id, cantidad, callback) {
    callRPC('disminuir_oferta', { oferta_id, cantidad }, callback);
}

function procesarDetalleDePago(tipo_de_pago_id, detalle_de_pago, total, callback) {
    callRPC('procesar_detalle_de_pago', { tipo_de_pago_id, detalle_de_pago, total }, callback);
}
function generarTiquetes({ oferta_id, cantidad, titular, identificacion }, callback) {
    callRPC('generar_tiquetes', { oferta_id, cantidad, titular, identificacion }, callback);
}

function registrarCompra({ oferta_id, cantidad, tipo_de_pago_id, detalle_de_pago_id, titular, identificacion, total }, callback) {
    const ordenesDbConn = mysql.createConnection(process.env.MYSQL_URI);
    ordenesDbConn.query(
        'call RegistrarCompra(?, ?, ?, ?, ?, ?, ?)',
        [oferta_id, cantidad, tipo_de_pago_id, detalle_de_pago_id, String(titular || '').substring(0, 20), String(identificacion || '').substring(0, 15), total],
        (err, res) => {
            if (err) return callback(err);
            const [[resultado]] = res;
            if (resultado.error) return callback(resultado.error);
            callback(null, resultado);
        });
}

app.post('/comprar', (req, res) => {
    const { oferta_id, cantidad, tipo_de_pago_id, detalle_de_pago, titular, identificacion } = req.body;
    obtenerPrecioOferta(oferta_id, (err, precio) => {
        if (err) {
            console.error(err.message);
            return res.json({ error: "No se puede verificar la oferta del vuelo en este momento", detalle: err.message });
        }
        const total = precio * cantidad;
        procesarDetalleDePago(tipo_de_pago_id, detalle_de_pago, total, (err, { _id: detalle_de_pago_id }) => {
            if (err) {
                console.error(err.message);
                return res.json({ error: "No se pudo procesar su pago", detalle: err.message });
            }
            registrarCompra({ oferta_id, cantidad, tipo_de_pago_id, detalle_de_pago_id, titular, identificacion, total }, (err, factura) => {
                if (err) {
                    console.error(err.message);
                    return res.json({ error: "No se pudo registrar su compra en este momento", detalle: err.message });
                }
                generarTiquetes({ oferta_id, cantidad, titular, identificacion }, (err, tiquetes) => {
                    if (err) {
                        console.error(err.message);
                        return res.json({ 
                            error: "No se pudieron generar sus tiquetes por favor contacte soporte", 
                            detalle: err.message,
                            resultado: { factura, tiquetes: [] }
                        });
                    }
                    disminuirOferta(oferta_id, cantidad, (err) => {
                        if (err) {
                            console.error(err.message);
                        } else {
                            console.log('Oferta disminuida');
                        }
                    });
                    res.json({
                        resultado: {
                            factura,
                            tiquetes
                        }
                    });
                });
            });
        });
    });
});

app.listen(process.env.PORT, () => console.log('App listening on port ' + process.env.PORT));