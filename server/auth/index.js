'use strict';

var express = require('express');
var passport = require('passport');
var config = require('../config/environment');
var User = require('../api/user/user.model');

// Passport Configuration
require('./browserid/passport').setup(User, config);
require('./facebook/passport').setup(User, config);
require('./google/passport').setup(User, config);

var router = express.Router();

router.use('/browserid', require('./browserid'));
router.use('/facebook', require('./facebook'));
router.use('/google', require('./google'));

module.exports = router;
