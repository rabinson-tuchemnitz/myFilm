require('dotenv').config();
const express = require('express');
const expressLayouts = require('express-ejs-layouts');
const bodyParser = require('body-parser');
const session = require('express-session');


// express app
const app = express();

// Set Templating enging
app.use(expressLayouts)
app.set('view engine', 'ejs');

// listen for request
app.listen(process.env.APP_PORT);

app.use(express.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.static(__dirname + '/public'));
app.use(session({secret:"myfilmsecretkey@123", saveUninitialized : true, resave : true}));

app.use(function (req, res, next) {
    res.locals = {
      loggedIn: req.session.loggedIn,
      userType: req.session.userType,
      userName: req.session.userName,
      success: req.session.success,
      message: req.session.message
    };

    next();
 });

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



