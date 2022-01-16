require('dotenv').config()
const express = require('express');

// express app
const app = express();

// connect database
const connect = "postgres://"

// register view engine
app.set('view engine', 'ejs');

// listen for request
app.listen(8888);


/**
 * ---------- Routes of the Web Server ----------
 */

app.get('/', function(req, res) {
    res.render('home', { title: 'Home'});
});

app.get('/films', function(req, res) {
    res.render('film/index.ejs', { title: 'Films'});
});

app.get('/crews', function(req, res) {
    res.render('crew/index.ejs', { title: 'Crews'});
});


app.use((req, res) => {
    res.status(404).render('404', { title: '404'});
})

/**
 * ---------- Routes of the Web Server ----------
 */



