const express = require('express');
const crewController = require('../controllers/CrewController');

const router = express.Router();

router.get('/crews', crewController.get_crew_list);
// router.get('/crew', crewController.create_crew);
// router.post('/crew', crewController.store_crew);
// router.post('/crew/:id', crewController.show_crew);
// router.get('/crew/:id/edit', crewController.edit_crew);
// router.put('/crew/:id', crewController.update_crew);
// router.delete('/crew/:id', crewController.destroy_crew)

module.exports = router;