const filmModel = require('../models/film');
const personModel = require('../models/person');

const get_film_list = async (req, res) => {
  try {
    films = await filmModel.getFilmList();
    res.render('film/index.ejs', films);
  } catch (err) {
    
  }
};

const get_watched_history = async (req, res) => {
  try {
    films = await filmModel.getFilmWatchedHistory(req.session.userId);

    res.render('film/history.ejs', films);
  } catch (err) {}
  res.render('film/history.ejs');
};

const create_film = async (req, res) => {
  genres = await filmModel.getGenres();
  films = await filmModel.getNonSubOrdinateMovies();
  persons = await personModel.getBasicPersonList();

  res.render('film/create.ejs', { genres, films, persons });
};

const store_film = async (req, res) => {
  try {
    const {
      film_type, name, subordinated_to, release_date, country, min_age, duration,
      persons, genres,  description,
    } = req.body;
  
  
    if(film_type === "movie") {
      createdFilmId = await filmModel.storeFilm(
        name, "movie", release_date, country, min_age,
        persons, genres, subordinated_to, description, duration
      )
    
    } else if (film_type === "series") {
      const {season_name, season_description, episode_name, episode_description} = req.body;
      
      //First insert series
      createdFilmId = await filmModel.storeFilm(
        name, "series", release_date, country, min_age,
        persons, genres, subordinated_to, description, duration
      )
  
      // Then insert season
      createdSeasonId = await filmModel.storeFilm(
        season_name, "season", release_date, country, min_age,
        persons, genres, createdFilmId, season_description, duration
      )
      //Finally insert episode
      createdEpisodeId = await filmModel.storeFilm(
        episode_name, "episode", release_date, country, min_age,
        persons, genres, createdSeasonId, episode_description, duration
      )
    }
    req.session.success = true;
    req.session.message = 'Film created successfully';
    res.redirect('/films');

  } catch (err) {
    req.session.success = false;
    req.session.message = 'Failed to create film. Error [' + err.message + ']';
    res.redirect('/films');
  }
};

const show_film = async (req, res) => {
  film = await filmModel.getFilmById(req.params.film_id)
  console.log(film)
  res.render('film/show.ejs', film);
};
// const edit_film = (req, res) => {
//     return 'edit film';
// }
//
// const update_film = (req, res) => {
//     return 'update film';
// }
//
// const delete_film = (req, res) => {
//     return 'delete film';
// }
//
// const destroy_film = (req, res) => {
//     return 'delete film';
// }

const create_season = async (req, res) => {
  series_id = req.params.film_id;
  genres = await filmModel.getGenres();
  persons = await personModel.getBasicPersonList();

  res.render('film/create-season.ejs', {series_id, genres, persons});
};

const store_season = (req, res) => {
  res.redirect('/seasons/1');
};

const edit_season = (req, res) => {
  res.render('film/edit-season.ejs');
};

const update_season = (req, res) => {
  res.redirect('/seasons/1');
};

const create_episode = (req, res) => {
  season_id = req.params.season_id;

  res.render('film/create-season.ejs',{season_id});
};

const store_episode = (req, res) => {
  res.redirect('/seasons/1');
};

const edit_episode = (req, res) => {
  res.render('film/edit-episode.ejs');
};

const update_episode = (req, res) => {
  res.redirect('/seasons/1');
};

module.exports = {
  get_film_list,
  get_watched_history,
  create_film,
  store_film,
  show_film,
  //     edit_film,
  //     update_film,
  //     delete_film,
  //     destroy_film,
  create_season,
  store_season,
  edit_season,
  update_season,
  create_episode,
  store_episode,
  edit_episode,
  update_episode,
};
