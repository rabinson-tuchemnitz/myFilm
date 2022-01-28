const session = require('express-session');
const pool = require('../db');


const get_home = (req, res) => {
    res.render('home.ejs', {
        title: 'Home', 
    });
}

const register_user = async (req, res) => {
    try {
        const { name, email, password, type } = req.body;

        await pool.query(
            "SELECT add_user($1, $2, $3)", [name, email, password]
        );

        res.render('home.ejs', {
            title: 'Home',
            success: true,
            message: "User registered successfully"
        })
    } catch (err) {
        res.render('home.ejs', {
            title : 'Home',
            success: false,
            message: err.message
        });
    }
}

const login_user = async (req, res) => {

    queryResult = await pool.query(
        "SELECT * FROM get_user_from_credentials($1, $2)", [req.body.email, req.body.password]
    );
    
    tableResults = queryResult.rows;
    
    if (tableResults.length == 0) {
        res.render('home.ejs',  {
            title: 'Home',
            success: false,
            message: 'Invalid credentials'
        })
    } else  {
        req.session.loggedIn = true;
        req.session.userType = tableResults[0].user_role;
        req.session.userName = tableResults[0].name;

        res.render('home.ejs', {
            title : "Home"
        })
    }
}

const logout = async (req, res) => {
    session = req.session;
    console.log(session.userid);
    console.log('logout')
}

module.exports = {
    get_home,
    register_user,
    login_user,
    logout
}
