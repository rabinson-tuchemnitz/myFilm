const session = require('express-session');
const pool = require('../db');


const get_home = (req, res) => {
    res.render('home.ejs', {
        title: 'Home', 
    });
}

const register_user = async (req, res) => {
    try {
        const { name, email, password, user_role } = req.body;

        await pool.query(
            "SELECT add_user($1, $2, $3, $4)", [name, email, password, user_role]
        );

        req.session.success = true;
        req.session.message = "User registered successfully"
        
        res.redirect('/');

    } catch (err) {
        req.session.success = false;
        req.session.message = "Failed to register user. \n [" + err.message + "]"

        res.redirect('/');
    }
}

const login_user = async (req, res) => {

   try {
        queryResult = await pool.query(
            "SELECT * FROM get_user_from_credentials($1, $2)", [req.body.email, req.body.password]
        );
        
        tableResults = queryResult.rows;
        
        if (tableResults.length == 0) {
            req.session.success = false;
            req.session.message = "Invalid credentials."
            res.redirect('/');

        } else  {
            req.session.loggedIn = true;
            req.session.userType = tableResults[0].user_role;
            req.session.userName = tableResults[0].name;

            req.session.success = true;
            req.session.message = "User logged in successfully"
            res.redirect('/');

        }
   } catch (err) {
       req.session.success = false;
       req.session.message = "Failed to login.\n [" + err.message + "]"

       res.redirect('/');
   }
}

const logout = async (req, res) => {
    try {
        req.session.loggedIn = false;
        req.session.userType = null;
        req.session.userName = null;

        req.session.success = true;
        req.session.message = "Logged out successfully"

        res.redirect('/');
    } catch (err) {
        req.session.success = false;
        req.session.message = "Failed to logout.\n [" + err.message + "]"

        res.redirect('/');  
    }

}

module.exports = {
    get_home,
    register_user,
    login_user,
    logout
}
