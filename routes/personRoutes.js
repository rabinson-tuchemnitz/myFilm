const express = require('express');
const personController = require('../controllers/PersonController');

const router = express.Router();

router.get('/persons', personController.get_person_list);
router.get('/person', personController.create_person);
router.post('/person', personController.store_person);
router.get('/person/:person_id', personController.show_person);
router.get('/person/:person_id/edit', personController.edit_person);
router.post('/person/:person_id/edit', personController.update_person);
router.get('/person/:person_id/delete', personController.destroy_person)

module.exports = router;