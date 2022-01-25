const get_film_list = (req, res) => {
    res.render('film/index.ejs', {title: 'Films'});
}

const create_film = (req, res) => {
    res.render('film/create.ejs', {title: 'Create Film'});
}
//
// const store_film = (req, res) => {
//     return 'store film';
// }
//
// const show_film = (req, res) => {
//     return 'show film';
// }
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
    create_film,
//     store_film,
//     show_film,
//     edit_film,
//     update_film,
//     delete_film,
//     destroy_film
}
