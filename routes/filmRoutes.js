const express = require('express');
const filmController = require('../controllers/FilmController');

const router = express.Router();

router.get('/films', filmController.get_film_list);
router.get('/films/history', filmController.get_watched_history);
router.get('/film/create', filmController.create_film);
router.post('/film/create', filmController.store_film);
router.get('/film/:film_id', filmController.show_film);
// router.get('/film/:id/edit', filmController.edit_film);
// router.put('/film/:id', filmController.update_film);
// router.delete('/film/:id', filmController.destroy_film)

router.get('/film/:film_id/season', filmController.create_season);
router.post('/season', filmController.store_season);
router.get('/season/edit', filmController.edit_season);
router.post('/season/edit', filmController.edit_season);

router.get('season/:season_id/episode', filmController.create_episode);
router.post('/episode', filmController.store_episode);
router.get('/episode/edit', filmController.edit_episode);
router.post('/episode/edit', filmController.update_episode);

module.exports = router;