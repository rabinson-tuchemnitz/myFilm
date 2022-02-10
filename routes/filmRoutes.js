const express = require('express');
const filmController = require('../controllers/FilmController');

const router = express.Router();

router.get('/films', filmController.get_film_list);
router.get('/films/history', filmController.get_watched_history);
router.get('/film/create', filmController.create_film);
router.post('/film/create', filmController.store_film);
router.get('/film/:film_id', filmController.show_film);
router.get('/film/:film_id/edit', filmController.edit_film);
router.post('/film/:film_id/edit', filmController.update_film);
router.get('/film/:film_id/delete', filmController.destroy_film)

router.get('/film/:film_id/season', filmController.create_season);
router.post('/season/create', filmController.store_season);

router.get('/film/:season_id/episode', filmController.create_episode);
router.post('/episode/create', filmController.store_episode);

router.post('/watch-film', filmController.store_watch_film);
router.post('/film-rating', filmController.store_film_rating);

module.exports = router;