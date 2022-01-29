const get_film_list = (req, res) => {
    res.render('film/index.ejs', {title: 'Films'});
}

const get_watched_history = (req, res) => {
    res.render('film/history.ejs');
}

const create_film = (req, res) => {
    res.render('film/create.ejs', {title: 'Create Film'});
}

const store_film = (req, res) => {
    console.log(req.body)
    return 'store film';
}

const show_film = (req, res) => {
    const data = {
        name: 'Movie 1',
        release_year: '2021',
        rating: 8,
        description: "This is the description of the movie which is a paragraph long but just trying out for dev purpose",
        persons: ['Joss Wheldon (Director)', 'Rober Downey Jr. (Actor)', 'Scarlett Johansson (Actress)' ],
        thumbnail: '/img/movies/mv1.jpg',
    }
    res.render('film/show.ejs', data)
}
// const edit_film = (req, res) => {
//     return 'edit film';
// }
//
// const update_film = (req, res) => {
//     return 'update film';
// }
//
// const delete_film = (req, res) => {
//     return 'delete film';
// }
//
// const destroy_film = (req, res) => {
//     return 'delete film';
// }


module.exports = {
    get_film_list,
    get_watched_history,
    create_film,
    store_film,
    show_film,
//     edit_film,
//     update_film,
//     delete_film,
//     destroy_film
}
