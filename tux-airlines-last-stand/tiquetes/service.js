const express = require('express');
var { MongoClient, ObjectId } = require('mongodb');
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

function registerRPC(channel, name, procedure) {
    channel.assertQueue(name, { durable: false });
    channel.consume(name, (msg) => {
        procedure(JSON.parse(msg.content.toString()), (error, result) => {
            channel.sendToQueue(msg.properties.replyTo, Buffer.from(JSON.stringify({ error, result })), { correlationId: msg.properties.correlationId });
        });
        channel.ack(msg);
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

function listenForRPCs() {
    createBrokerChannel((err, broker) => {
        if (err) {
            console.error(err.message);
            return;
        }
        registerRPC(broker.channel, 'procesar_detalle_de_pago', procesarDetalleDePago);
        registerRPC(broker.channel, 'generar_tiquetes', generarTiquetes);
    })
}

function procesarDetalleDePago({ tipo_de_pago_id, detalle_de_pago, total }, callback) {
    MongoClient.connect(process.env.MONGO_URI, (err, conn) => {
        if (err) return callback(err);
        const data = { tipo_de_pago_id, detalle_de_pago, total };
        conn.db("pagos").collection("detalles_de_pago").insertOne(data, (err, res) => {
            conn.close();
            if (err) return callback(err);
            const [result] = res.ops;
            callback(null, result);
        });
    });
}

function obtenerDetalleDeOferta(oferta_id, callback) {
    callRPC('obtener_detalle_de_oferta', { oferta_id }, callback);
}

function generarTiquetes({ oferta_id, cantidad, titular, identificacion }, callback) {
    obtenerDetalleDeOferta(oferta_id, (err, oferta)=>{
        if(err) return callback(err);
        MongoClient.connect(process.env.MONGO_URI, (err, conn) => {
            if (err) return callback(err);
            const { 
                aerolinea_id, 
                aerolinea_nombre, 
                aerolinea_logo_url, 
                tipo_de_asiento,
                oferta_fecha_hora_salida,
                vuelo_id,
                origen_pais_codigo,
                origen_lugar_nombre,
                destino_pais_codigo,
                destino_lugar_nombre
            } = oferta;
            const tiquetes = Array(cantidad).fill().map(() => ({
                oferta_id,
                titular,
                identificacion,
                aerolinea_id, 
                aerolinea_nombre, 
                aerolinea_logo_url, 
                tipo_de_asiento,
                oferta_fecha_hora_salida,
                vuelo_id,
                origen_pais_codigo,
                origen_lugar_nombre,
                destino_pais_codigo,
                destino_lugar_nombre
            }));
            conn.db("tiquetes").collection("registro_de_tiquetes").insertMany(tiquetes, (err, res) => {
                conn.close();
                if (err) return callback(err);
                callback(null, res.ops);
            });
        });
    });
}

function validarTiquete({ tiquete_id, identificacion }, callback) {
    try {
        tiquete_id = new ObjectId(tiquete_id)
    } catch {
        return callback({ message: "Tiquete Id inválido" });
    }
    MongoClient.connect(process.env.MONGO_URI, (err, conn) => {
        if (err) return callback(err);
        conn.db("tiquetes").collection("registro_de_tiquetes").findOne({ _id: tiquete_id, identificacion }, (err, res) => {
            if (err) return callback(err);
            callback(null, res != null);
        });
    });
}

app.post("/validar", (req, res) => {
    const { tiquete_id, identificacion } = req.body;
    validarTiquete({ tiquete_id, identificacion }, (err, resultado) => {
        if (err) return res.json({ error: "No se puede validar el tiquete en este momento", detalle: err.message });
        res.json({ resultado });
    });
});

listenForRPCs();
app.listen(process.env.PORT, () => console.log('App listening on port ' + process.env.PORT));