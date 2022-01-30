const pool = require('../db');

const getFilmList = async () => {
  queryResult = await pool.query('SELECT * FROM get_films()');

  return queryResult.rows;
};

const storeFilm = async () => {};

const getFilm = async (id) => {
  queryResult = await pool.query('SELECT * FROM get_film($1)', [id]);
  return queryResult.rows[0];
};

const updateFilm = async () => {};

const deleteFilm = async () => {};

const storeFilmWatchedByUser = async () => {}; 

const getFilmWatchedHistory = async () => {};

const storeFilmRating = async () => {};

module.exports = {
  getFilmList,
  storeFilm,
  getFilm,
  updateFilm,
  deleteFilm,
  storeFilmWatchedByUser,
  getFilmWatchedHistory, 
  storeFilmRating
};
