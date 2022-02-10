const personModel = require('../models/person');

const get_person_list = async (req, res) => {
  persons = await personModel.getPersonList();
  res.render('person/index.ejs', { persons });
};

const create_person = (req, res) => {
  res.render('person/create.ejs');
};

const store_person = async (req, res) => {
  try {
    const {name, dob, country, role, description, gender } = req.body;
    await personModel.storePerson(name, dob, country, role, description, gender);

    persons = await personModel.getPersonList();

    req.session.success = true;
    req.session.message = 'Person created successfully';

    res.redirect('/persons', {persons});
  } catch (err) {
    console.log(err.message)
    req.session.success = false;
    req.session.message = 'Failed to delete person. Error [' + err.message + ']';
    res.redirect('back');
  }
};

const show_person = (req, res) => {
  return 'show person';
};

const edit_person = (req, res) => {
  return 'edit person';
};

const update_person = (req, res) => {
  return 'update person';
};

const destroy_person = async (req, res) => {
  try {
    await personModel.deletePerson(req.params.person_id);

    persons = await personModel.getPersonList();

    req.session.success = true;
    req.session.message = 'Person deleted successfully';
    res.redirect('/persons', {persons});
  } catch (err) {
    console.log(err.message);
    req.session.success = false;
    req.session.message =
      'Failed to delete person. Error [' + err.message + ']';
    res.redirect('back');
  }
};

module.exports = {
  get_person_list,
  create_person,
  show_person,
  store_person,
  edit_person,
  update_person,
  destroy_person,
};
