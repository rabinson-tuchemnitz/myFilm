const express = require('express');
const filmController = require('../controllers/FilmController');

const router = express.Router();

router.get('/films', filmController.get_film_list);
router.get('/film', filmController.create_film);
router.post('/film', filmController.store_film);
// router.post('/film/:id', filmController.show_film);
// router.get('/film/:id/edit', filmController.edit_film);
// router.put('/film/:id', filmController.update_film);
// router.delete('/film/:id', filmController.destroy_film)

module.exports = router;