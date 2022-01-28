const express = require('express');
const homeController = require('../controllers/HomeController.js');

const router = express.Router();

router.get('/', homeController.get_home);
router.post('/register', homeController.register_user);
router.post('/login', homeController.login_user);
router.post('/logout', homeController.logout);

module.exports = router;