const userModel = require('../models/user');

const get_home = (req, res) => {
  res.render('home.ejs', {
    title: 'Home',
  });
};

const register_user = async (req, res) => {
  try {
    const { name, email, password, user_role } = req.body;

    await userModel.storeUser(name, email, password, user_role);

    req.session.success = true;
    req.session.message = 'User registered successfully';

    res.redirect('/');
  } catch (err) {
    req.session.success = false;
    req.session.message = 'Failed to register user. \n [' + err.message + ']';

    res.redirect('/');
  }
};

const login_user = async (req, res) => {
  try {
    const { email, password } = req.body;

    user = await userModel.getUserFromCredentials(email, password);

    if (!user) {
      req.session.success = false;
      req.session.message = 'Invalid credentials.';
      res.redirect('/');
    } else {
      req.session.loggedIn = true;
      req.session.userType = user.user_role;
      req.session.userName = user.name;
      req.session.userId = user.user_id;

      req.session.success = true;
      req.session.message = 'User logged in successfully';
      res.redirect('back');
    }
  } catch (err) {
    req.session.success = false;
    req.session.message = 'Failed to login.\n [' + err.message + ']';

    res.redirect('back');
  }
};

const logout = async (req, res) => {
  try {
    req.session.loggedIn = false;
    req.session.userType = null;
    req.session.userName = null;
    req.session.userId = null;

    req.session.success = true;
    req.session.message = 'Logged out successfully';

    res.redirect('back');
  } catch (err) {
    req.session.success = false;
    req.session.message = 'Failed to logout.\n [' + err.message + ']';

    res.redirect('back');
  }
};

const view_profile = async (req, res) => {
  if (req.session.loggedIn) {
    user = await userModel.getUserData(req.session.userId);

    res.render('user/index.ejs', {
      name: user.name,
      email: user.email,
      role: user.role,
      description: user.description,
      joinedAt: user.created_at,
    });
  } else {
    res.redirect('back');
  }
};

const edit_profile = async (req, res) => {
  if (req.session.loggedIn) {
    user = await userModel.getUserData(req.session.userId);

    userData = queryResult.rows[0];

    res.render('user/edit.ejs', {
      name: user.name,
      email: user.email,
      role: user.role,
      description: user.description,
    });
  } else {
    res.redirect('back');
  }
};

const update_profile = async (req, res) => {
  try {
    const { name, summary } = req.body;

    await userModel.updateUser(req.session.userId, name, summary);

    req.session.success = true;
    req.session.message = 'Profile updated successfully';

    res.redirect('/profile');
  } catch (err) {
    req.session.success = false;
    req.session.message = 'Failed to update user.\n [' + err.message + ']';

    res.redirect('/profile');
  }
};

module.exports = {
  get_home,
  register_user,
  login_user,
  logout,
  view_profile,
  edit_profile,
  update_profile,
};
