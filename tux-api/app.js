const dotenv = require('dotenv');
const express = require('express');
const mysql = require('mysql');
dotenv.config();

const app = express();
const PORT = process.env.PORT;

function selectFlights(callback){    
    var catalogDbConn = mysql.createConnection(process.env.MYSQL_URI);    
    catalogDbConn.query('SELECT id, from_place as fromPlace, to_place as toPlace, seats, airline FROM flights;',  callback);
}

app.get('/', (req, res) => {
    selectFlights((error, flights) => {
        if(error){
            res.json({ error: error.message });
        }else{
            res.json(flights);
        }
        res.end();
    });    
});

app.listen(PORT, () => console.log(`tux-api listening on port ${PORT}`));