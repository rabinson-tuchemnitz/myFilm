const express = require('express');
const { route } = require('express/lib/application');
const homeController = require('../controllers/HomeController.js');

const router = express.Router();

router.get('/', homeController.get_home);
router.post('/register', homeController.register_user);
router.post('/login', homeController.login_user);
router.post('/logout', homeController.logout);
router.get('/profile', homeController.view_profile);
router.get('/profile/edit', homeController.edit_profile);
router.post('/profile/edit', homeController.update_profile)

module.exports = router;