'use strict';

var express = require('express');
var passport = require('passport');
var auth = require('../auth.service');

var router = express.Router();

router
  .get('/', auth.guardarIdentificacion, passport.authenticate('google', {
    failureRedirect: '/login?error=go',
    scope: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email'
    ],
    session: false
  }))

  .get('/callback', passport.authenticate('google', {
    failureRedirect: '/login?error=go',
    session: false
  }), auth.setTokenCookie);

module.exports = router;
