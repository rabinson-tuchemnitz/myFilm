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

    req.session.success = true;
    req.session.message = 'Person created successfully';

    res.redirect('/persons');
  } catch (err) {
    console.log(err.message)
    req.session.success = false;
    req.session.message = 'Failed to delete person. Error [' + err.message + ']';
    res.redirect('/persons');
  }
};

const show_person = async (req, res) => {
    userId = req.params.person_id;
    person = await personModel.getPersonById(userId);

    console.log(person)

    res.render('person/show.ejs', {person})
};

const edit_person = async (req, res) => {
    userId = req.params.person_id;
    person = await personModel.getPersonById(userId);
    res.render('person/edit.ejs', {person});
};

const update_person = async (req, res) => {
    try {
        userId = req.params.person_id;
        const {name, dob, country, role, gender, description} = req.body;
        await personModel.updatePerson(userId, name, dob, country, role, description, gender)

        req.session.success = true;
        req.session.message = 'Person updated successfully';

        res.redirect('/persons');

    } catch (err) {
        console.log(err.message)
        req.session.success = false;
        req.session.message = 'Failed to delete person. Error [' + err.message + ']';
        res.redirect('/persons');
    }
};

const destroy_person = async (req, res) => {
  try {
    await personModel.deletePerson(req.params.person_id);

    req.session.success = true;
    req.session.message = 'Person deleted successfully';
    res.redirect('/persons');
  } catch (err) {
    console.log(err.message);
    req.session.success = false;
    req.session.message =
      'Failed to delete person. Error [' + err.message + ']';
      res.redirect('/persons');
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
