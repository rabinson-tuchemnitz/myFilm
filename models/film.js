const pool = require('../db');


const getFilmList = async () => {
  queryResult = await pool.query('SELECT * FROM get_films()');

  return queryResult.rows;
};

const getNonSubOrdinateFilms = async () => {
  queryResult = await pool.query('SELECT * FROM get_non_subordinated_films()')

  return queryResult.rows;
}

const storeFilm = async () => {};

const getFilm = async (id) => {
  queryResult = await pool.query('SELECT * FROM get_film($1)', [id]);
  return queryResult.rows[0];
};

const updateFilm = async () => {};

const deleteFilm = async () => {};

const getGenres = async () => {
  queryResult = await pool.query('SELECT * FROM get_genres()');

  return queryResult.rows;
}

const storeFilmWatchedByUser = async () => {}; 

const getFilmWatchedHistory = async () => {};

const storeFilmRating = async () => {};


module.exports = {
  getFilmList,
  getNonSubOrdinateFilms,
  storeFilm,
  getFilm,
  updateFilm,
  deleteFilm,
  getGenres,
  storeFilmWatchedByUser,
  getFilmWatchedHistory, 
  storeFilmRating
};
