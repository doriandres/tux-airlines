const express = require('express');
const mysql = require('mysql');
const amqp = require('amqplib/callback_api');
const app = express();

function createBrokerChannel(callback) {
    amqp.connect(process.env.RABBITMQ_URI, (err, connection) => {
        if (err) return callback(err);
        connection.createChannel((err, channel) => {
            if (err) return callback(err);
            callback(null, { connection, channel });
        });
    });
}

function registerRPC(channel, name, procedure) {
    channel.assertQueue(name, { durable: false });
    channel.consume(name, (msg) => {
        procedure(JSON.parse(msg.content.toString()), (error, result) => {
            channel.sendToQueue(msg.properties.replyTo, Buffer.from(JSON.stringify({ error, result })), { correlationId: msg.properties.correlationId });
        });
        channel.ack(msg);
    });
}

function listenForRPCs() {
    createBrokerChannel((err, broker) => {
        if (err) {
            console.error(err.message);
            return;
        }
        registerRPC(broker.channel, 'obtener_precio_oferta', obtenerPrecioOferta);
        registerRPC(broker.channel, 'disminuir_oferta', disminuirOferta);
        registerRPC(broker.channel, 'obtener_detalle_de_oferta', obtenerDetalleDeOferta);
    });
}

function obtenerPrecioOferta({ oferta_id }, callback) {
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call ObtenerPrecioOferta(?)', [oferta_id], (err, resultado) => {
        if (err) return callback(err);
        const [[{ error, precio }]] = resultado;
        if (error) return callback({ message: error });
        callback(null, precio);
    });
}

function disminuirOferta({ oferta_id, cantidad }, callback) {
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call DisminuirOferta(?, ?)', [oferta_id, cantidad], (err, resultado) => {
        if (err) return callback(err);
        const [[{ error }]] = resultado;
        if (error) return callback({ message: error });
        callback();
    });
}

function bloquearOferta({ oferta_id, cantidad }, callback) {
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call BloquearOferta(?, ?)', [oferta_id, cantidad], (err, resultado) => {
        if (err) return callback(err);
        const [[{ error }]] = resultado;
        if (error) return callback({ message: error });
        callback(null);
    });
}

function desbloquearOferta({ oferta_id, cantidad }, callback) {
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call DesbloquearOferta(?, ?)', [oferta_id, cantidad], (err, resultado) => {
        if (err) return callback(err);
        const [[{ error }]] = resultado;
        if (error) return callback({ message: error });
        callback(null);
    });
}

function obtenerDetalleDeOferta({ oferta_id }, callback) {
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call ObtenerDetalleOferta(?)', [oferta_id], (err, resultado) => {
        if (err) return callback(err);
        const [[detalle]] = resultado;
        callback(null, detalle);
    });
}

function filtrarOfertaDeVuelos({ pagina = 1, cantidad = 10, origen = '', destino = '', aerolinea = '' }, callback) {
    pagina = Number(pagina) || 1;
    cantidad = Number(cantidad) || 10;
    const catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);
    catalogDbConn.query('call PaginasFiltraOfertasDeVuelos(?, ?, ?, ?)', [cantidad, origen, destino, aerolinea], (err, contadores) => {
        if (err) return callback(err);
        const [[{ paginas_disponibles, cantidad_de_elementos }]] = contadores;
        catalogDbConn.query('call FiltraOfertasDeVuelos(?, ?, ?, ?, ?)', [pagina, cantidad, origen, destino, aerolinea], (err, resultado) => {
            if (err) return callback(err);
            const [ofertas] = resultado;
            callback(null, { paginas_disponibles, cantidad_de_elementos, resultados: ofertas });
        });
    });
}

app.get('/vuelos', (req, res) => {
    filtrarOfertaDeVuelos(req.query, (err, resultado) => {
        if (err) {
            console.log(err.message);
            res.json({ error: "No se pudo conseguir la oferta de vuelos" });
        } else {
            res.json(resultado);
        }
    });
});

app.get('/oferta/:oferta_id', (req, res) => {
    const { oferta_id } = req.params;
    if (!oferta_id){
        return res.status(400).end();
    }
    obtenerDetalleDeOferta({ oferta_id }, (err, detalle) => {
        if (err) {
            console.error(err.message);
            return res.json({ error: "No se puede encontrar la oferta en este momento", detalle: err.message });
        }
        if(detalle == null){
            res.status(404).end();
        }else{
            res.json({ resultado: detalle });
        }
    });
});

app.post('/bloquear', (req, res) => {
    const { oferta_id, cantidad } = req.body;
    bloquearOferta({ oferta_id, cantidad }, (err) => {
        if (err) {
            console.error(err.message);
            res.json({ error: "No se pudo bloquear la oferta solicitada", detalle: err.message });
        } else {
            res.json({ resultado: true });
        }
    });
});

app.post('/desbloquear', (req, res) => {
    const { oferta_id, cantidad } = req.body;
    desbloquearOferta({ oferta_id, cantidad }, (err) => {
        if (err) {
            console.error(err.message);
            res.json({ error: "No se pudo desbloquear la oferta solicitada", detalle: err.message });
        } else {
            res.json({ resultado: true });
        }
    });
});

listenForRPCs();
app.listen(process.env.PORT, () => console.log('App listening on port ' + process.env.PORT));