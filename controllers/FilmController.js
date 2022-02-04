const filmModel = require('../models/film');
const personModel = require('../models/person');

const get_film_list = async (req, res) => {
  try {
    // films = await filmModel.getFilmList();
    res.render('film/index.ejs');
  } catch (err) {}
};

const get_watched_history = async (req, res) => {
  try {
      films = await filmModel.getFilmWatchedHistory(req.session.userId)

      res.render('film/history.ejs', films);
  } catch (err) {

  }
  res.render('film/history.ejs');
};

const create_film = async (req, res) => {
  genres = await filmModel.getGenres();
  films = await filmModel.getNonSubOrdinateFilms();
  persons = await personModel.getBasicPersonList();

  console.log(genres, films, persons)
  res.render('film/create.ejs', { genres, films, persons });
};

const store_film = (req, res) => {
  console.log(req.body);
  return 'store film';
};

const show_film = (req, res) => {
  const data = {
    name: 'Movie 1',
    release_year: '2021',
    rating: 8.3,
    description:
      'This is the description of the movie which is a paragraph long but just trying out for dev purpose',
    persons: [
      'Joss Wheldon (Director)',
      'Rober Downey Jr. (Actor)',
      'Scarlett Johansson (Actress)',
    ],
    genre: [
        'roman', 'action'
    ],
    thumbnail: '/img/movies/mv1.jpg',
  };
  res.render('film/show.ejs', data);
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

const create_season = (req, res) => {
    res.render('film/create-season.ejs')
}

const store_season = (req, res) => {
    res.redirect('/seasons/1')
}

const edit_season = (req, res) => {
    res.render('film/edit-season.ejs')
}

const update_season = (req, res) => {
    res.redirect('/seasons/1')
}

const create_episode = (req, res) => {
    res.render('film/create-season.ejs')
}

const store_episode = (req, res) => {
    res.redirect('/seasons/1');
}

const edit_episode = (req, res) => {
    res.render('film/edit-episode.ejs')
}

const update_episode = (req, res) => {
    res.redirect('/seasons/1')
}

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
  update_episode
};
