const express = require('express');
const filmController = require('../controllers/HomeController.js');

const router = express.Router();

router.get('/', filmController.get_home);

module.exports = router;