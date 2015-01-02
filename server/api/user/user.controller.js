'use strict';

var winston = require('winston');
var passport = require('passport');
var jwt = require('jsonwebtoken');

var validationError = function(res, err) {
  return res.status(422).json(err);
};

/**
 * Creates a new user
 */
exports.create = function (req, res, next) {
  var newUser = new User(req.body);
  newUser.provider = 'local';
  newUser.save(function(err, user) {
    if (err) return validationError(res, err);
    var token = jwt.sign({_id: user._id }, config.secrets.session, { expiresInMinutes: 60*5 });
    res.json({ token: token });
  });
};
var User = require('./user.model');
var config = require('../../config/environment');

/**
 * Get a single user
 */
exports.show = function (req, res, next) {
  var userId = req.params.id;

  User.findById(userId, function (err, user) {
    if (err) {
      winston.error('Error localizando a un usuario: %s', userId);
      return next(err);
    }
    if (!user) {
      winston.warn('Usuario no encontrado: %s', userId);
      return res.send(401);
    }
    res.json(user.profile);
  });
};

/**
 * Get my info
 */
exports.me = function(req, res, next) {
  var userId = req.user._id;
  User.findOne({
    _id: userId
  }, '-salt -hashedPassword', function(err, user) { // don't ever give out the password or salt
    if (err) {
      winston.error('Error localizando al propio usuario: %s', userId);
      return next(err);
    }
    if (!user) {
      winston.error('Usuario no encontrado: %s', userId);
      return res.json(401);
    }
    res.json(user);
  });
};

/**
 * Authentication callback
 */
exports.authCallback = function(req, res, next) {
  res.redirect('/');
};
