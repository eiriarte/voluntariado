'use strict';

var express = require('express');
var passport = require('passport');
var auth = require('../auth.service');

var router = express.Router();

router
  .get('/', auth.guardarIdentificacion, passport.authenticate('facebook', {
    scope: ['email', 'public_profile'],
    failureRedirect: '/login',
    session: false
  }))

  .get('/callback', passport.authenticate('facebook', {
    failureRedirect: '/login',
    session: false
  }), auth.setTokenCookie);

module.exports = router;
