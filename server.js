require('dotenv').config()
const express = require('express');
const expressLayouts = require('express-ejs-layouts')

// express app
const app = express();

// connect database
const connect = "postgres://"

// Set Templating enging
app.use(expressLayouts)
app.set('view engine', 'ejs');

// listen for request
app.listen(process.env.APP_PORT);

app.use(express.static(__dirname + '/public'));

/*
 * ---------- Routes of the Web Server ----------
 */


const filmRoutes = require('./routes/filmRoutes');
app.use(filmRoutes);

const crewRoutes = require('./routes/crewRoutes');
app.use(crewRoutes);

const homeRoutes = require('./routes/homeRoutes');
app.use(homeRoutes);

/**
 * ---------- Routes of the Web Server ----------
 */



