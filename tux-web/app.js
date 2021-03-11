const dotenv = require('dotenv');
const fetch = require('node-fetch');
const express = require('express');

dotenv.config();
const API_URL = process.env.API_URL;
const PORT = process.env.PORT;

const app = express();

app.get('/', async (req, res) => {
    const response  = await fetch(API_URL);
    const text = await response.text();

    res.send('The API said: '+text);
    res.end();
});

app.listen(PORT, () => console.log(`tux-web listening on port ${PORT}`));