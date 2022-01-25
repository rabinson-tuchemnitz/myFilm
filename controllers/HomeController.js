const get_home = (req, res) => {
    res.render('home.ejs', {title: 'Home'});
}

module.exports = {
    get_home
}
