const get_person_list = (req, res) => {
    res.render('person/index.ejs', {title: 'Persons'});
}

const create_person = (req, res) => {
    res.render('person/create.ejs');
}

const store_person = (req, res) => {
    console.log(req.body);
    return 'store person';
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
    get_person_list,
    create_person,
    store_person,
    // edit_crew,
    // update_crew,
    // delete_crew,
    // destroy_crew,
}