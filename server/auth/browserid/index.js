'use strict';

var express = require('express');
var passport = require('passport');
var auth = require('../auth.service');

var router = express.Router();

router.post('/',
  passport.authenticate('browserid', { session: false }),
  function(req, res) {
    auth.setTokenCookie(req, res);
    res.json({ auth: true });
  });

module.exports = router;
