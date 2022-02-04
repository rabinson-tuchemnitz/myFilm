const pool = require('../db');

const getFilmList = async () => {
  queryResult = await pool.query('SELECT * FROM get_films()');

  return queryResult.rows;
};

const getNonSubOrdinateMovies = async () => {
  queryResult = await pool.query('SELECT * FROM get_non_subordinated_movies()');

  return queryResult.rows;
};

const getNonSubOrdinateSeries = async () => {
  queryResult = await pool.query('SELECT * FROM get_non_subordinated_series()');

  return queryResult.rows;
};

const storeFilm = async (
  name, film_type, release_date, production_country, minimum_age,
  persons, genres, subordinated_to, description, duration
) => {
  persons = persons.length == 1 ? '{' + persons + '}' : '{' + persons.join() + '}';
  genres = genres.length == 1 ? '{' + genres + '}' :'{' + genres.join() + '}';

  queryResult = await pool.query(
    `
    SELECT insert_film(
      title:=$1, 
      release_date:=$2,
      film_type:=$3,
      production_country:=$4, 
      minimum_age:=$5, 
      persons:=$6::int[],
      genres:=$7::int[], 
      subordinated_to:=$8, 
      description:=$9,
      duration:=$10
    )
  `,
    [
      name, release_date, film_type, production_country, minimum_age, persons,
      genres, subordinated_to, description, duration,
    ]
  );
  return queryResult.rows[0].insert_film;
};

const getFilm = async (id) => {
  queryResult = await pool.query('SELECT * FROM get_film($1)', [id]);
  return queryResult.rows[0];
};

const updateFilm = async () => {};

const deleteFilm = async () => {};

const getGenres = async () => {
  queryResult = await pool.query('SELECT * FROM get_genres()');

  return queryResult.rows;
};

const storeFilmWatchedByUser = async () => {};

const getFilmWatchedHistory = async () => {};

const storeFilmRating = async () => {};

module.exports = {
  getFilmList,
  getNonSubOrdinateMovies,
  getNonSubOrdinateSeries,
  storeFilm,
  getFilm,
  updateFilm,
  deleteFilm,
  getGenres,
  storeFilmWatchedByUser,
  getFilmWatchedHistory,
  storeFilmRating,
};
