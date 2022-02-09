const pool = require('../db');

const getFilmList = async () => {
  queryResult = await pool.query('SELECT * FROM get_film_list()');

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
 console.log( [
  name, release_date, film_type, production_country, minimum_age, persons,
  genres, subordinated_to, description, duration,
])
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

const getFilmById = async (id) => {
  queryResult = await pool.query('SELECT * FROM get_film_by_id($1)', [id]);
  return queryResult.rows[0];
};

const getBasicFilmById = async (id) => {
  queryResult = await pool.query('SELECT * FROM get_basic_film_by_id($1)', [id]);
  return queryResult.rows[0];
}

const updateFilm = async () => {};

const deleteFilm = async (filmId) => {
  queryResult = await pool.query('SELECT * FROM delete_film($1)',[filmId])
};

const getGenres = async () => {
  queryResult = await pool.query('SELECT * FROM get_genres()');

  return queryResult.rows;
};

const storeFilmWatchedByUser = async (filmId, userId) => {
  queryResult = await pool.query('SELECT * FROM insert_watch_histroy($1, $2)',[filmId, userId]);
  return queryResult.rows;
};

const getFilmWatchedHistory = async () => {
  
};

const storeFilmRating = async (filmId, userId, rating, review) => {
  queryResult = await pool.query(
    'SELECT * FROM insert_rating($1, $2, $3, $4)', [filmId, userId, rating, review]
  );
  return queryResult.rows;
};

module.exports = {
  getFilmList,
  getNonSubOrdinateMovies,
  getNonSubOrdinateSeries,
  storeFilm,
  getFilmById,
  getBasicFilmById,
  updateFilm,
  deleteFilm,
  getGenres,
  storeFilmWatchedByUser,
  getFilmWatchedHistory,
  storeFilmRating,
};
