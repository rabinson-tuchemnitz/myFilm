const get_crew_list = (req, res) => {
    res.render('crew/index.ejs', {title: 'Crews'});
}

const create_crew = (req, res) => {
    res.render('crew/create.ejs');
}

const store_crew = (req, res) => {
    console.log(req.body);
    return 'store crew';
}
//
// const show_crew = (req, res) => {
//     return 'show crew';
// }
//
// const edit_crew = (req, res) => {
//     return 'edit crew';
// }
//
// const update_crew = (req, res) => {
//     return 'update crew';
// }
//
// const delete_crew = (req, res) => {
//     return 'delete crew';
// }
//
// const destroy_crew = (req, res) => {
//     return 'delete crew';
// }

module.exports = {
    get_crew_list,
    create_crew,
    store_crew,
    // edit_crew,
    // update_crew,
    // delete_crew,
    // destroy_crew,
}