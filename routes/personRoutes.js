const express = require('express');
const personController = require('../controllers/PersonController');

const router = express.Router();

router.get('/persons', personController.get_person_list);
router.get('/person', personController.create_person);
router.post('/person', personController.store_person);
// router.get('/person/:id', personController.show_crew);
// router.get('/person/:id/edit', personController.edit_crew);
// router.put('/person/:id', personController.update_crew);
// router.delete('/person/:id', personController.destroy_crew)

module.exports = router;