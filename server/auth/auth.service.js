'use strict';

var mongoose = require('mongoose');
var passport = require('passport');
var _ = require('lodash');
var config = require('../config/environment');
var jwt = require('jsonwebtoken');
var expressJwt = require('express-jwt');
var compose = require('composable-middleware');
var winston = require('winston');
var User = require('../api/user/user.model');
var Persona = require('../api/persona/persona.model');
var Sede = require('../api/admin/admin.model');
var validateJwt = expressJwt({ secret: config.secrets.session });
var validateJwtNoCreds = expressJwt({
  secret: config.secrets.session,
  credentialsRequired: false
});

/**
 * Attaches the user object to the request if authenticated
 * Otherwise returns 403
 */
function isAuthenticated() {
  return compose()
    // Validate jwt
    .use(function(req, res, next) {
      // allow access_token to be passed through query parameter as well
      if(req.query && req.query.hasOwnProperty('access_token')) {
        req.headers.authorization = 'Bearer ' + req.query.access_token;
      }
      validateJwt(req, res, next);
    })
    // Attach user to request
    .use(function(req, res, next) {
      User.findById(req.user._id, function (err, user) {
        if (err) {
          winston.error('Error localizando usuario %s', req.user._id);
          return next(err);
        }
        if (!user) return res.send(401);

        req.user = user;
        next();
      });
    });
}

/**
 * Attaches the user object to the request if authenticated
 * Si no, user queda undefined
 * Si pers === true => Obtenemos también la Persona (voluntaria)
 */
function getUser(pers) {
  return compose()
    // Validate jwt
    .use(function(req, res, next) {
      // allow access_token to be passed through query parameter as well
      if(req.query && req.query.access_token) {
        req.headers.authorization = 'Bearer ' + req.query.access_token;
      } else if (req.cookies && req.cookies.token) {
        req.headers.authorization = 'Bearer ' + req.cookies.token.slice(1, req.cookies.token.length - 1);
      }
      validateJwtNoCreds(req, res, next);
    })
    // Attach user to request, si lo hay
    .use(function(req, res, next) {
      if (!req.user) {
        winston.debug('Usuario sin identificación');
        return next();
      }
      User.findById(req.user._id).lean().exec(function (err, user) {
        if (err) {
          winston.error('Error obteniendo los datos del usuario %s', req.user._id);
          return next(err);
        }
        if (!user) {
          winston.error('No se ha encontrado el id de usuario: %j', req.user, {});
          return res.send(401);
        }

        req.user = user;
        if (pers === true && user.persona) {
          winston.debug('Obteniendo datos de voluntario…');
          Persona.findById(user.persona).lean().exec(function(err, persona) {
            if (err) {
              winston.error('Error obteniendo los datos del voluntario %s', user.persona);
              return next(err);
            }
            if (!persona) {
              winston.error('Voluntario no encontrado: %s', user.persona);
              return res.send(401);
            }

            winston.debug('Datos obtenidos: %j', persona, {});
            req.user.persona = persona._id.toString();
            req.user.coord = persona.coord;
            req.user.turno = _.last(persona.turnos).turno.toString();
            winston.debug('Usuario voluntario: %j', req.user, {});
            next();
          });
        } else {
          winston.debug('Usuario: %j', req.user, {});
          next();
        }
      });
    })
    .use(function(err, req, res, next) {
      winston.error('Se produjo un error verificando el usuario: %j', err, {});
      req.user = null;
      next();
    });
}

/**
 * Returns a jwt token signed by the app secret
 */
function signToken(id) {
  return jwt.sign({ _id: id }, config.secrets.session, { expiresInMinutes: 60*192 });
}

/**
 * Set token cookie directly for oAuth strategies
 */
function setTokenCookie(req, res) {
  if (!req.user) return res.status(404).json({ message: 'setTokenCookie: Something went wrong, please try again.'});
  var token = signToken(req.user._id, req.user.role);
  res.cookie('token', JSON.stringify(token));
  res.redirect('/');
}

/**
 * Middleware que almacena en sesión la identificación de usuario vid o sid
 * para que se pueda verificar en el callback oAuth (véase identificar())
 */
function guardarIdentificacion(req, res, next) {
  if (req.query.vid) {
    req.session.vid = req.query.vid;
    winston.info('Guardada en sesión identificación VID: %s', req.query.vid);
  } else if (req.query.sid) {
    req.session.sid = req.query.sid;
    winston.info('Guardada en sesión identificación SID: %s', req.query.sid);
  }
  next();
}

/**
 * Devuelve al callback done el voluntario o usuario de la sede que corresponde
 * al código de identificación vid/sid, y luego elimina la identificación
 */
function identificar(req, done) {
  var vid = req.session.vid || req.body.vid;
  var sid = req.session.sid || req.body.sid;
  var id, Modelo, campoId, user = {};
  if (vid) {
    id = vid;
    Modelo = Persona;
    campoId = 'persona';
  } else if (sid) {
    id = sid;
    Modelo = Sede;
    campoId = 'sede';
  } else {
    winston.error('Imposible localizar código de identificación.');
    return done(new Error('No hay código de identificación'));
  }

  Modelo.findOne({ identificacion: id }, function (err, data) {
    if (_.isObject(data)) {
      user[campoId] = data._id;
      done(err, user);
      // Borramos la identificación por seguridad
      req.session.destroy();
      data.identificacion = null;
      data.save();
    } else {
      if (err) {
        winston.error('Error localizando identificación %s', id);
      }
      done(err, data);
    }
  });
}

// Devuelve true si el usuario 'user' pertenece al turno 'id' o es de la sede
function turno(user, id) {
  if (user.sede) {
    return true;
  }
  return user.turno === id;
}

// Devuelve true si el usuario 'user' es coordinador del turno 'id' o es de la sede
function coord(user, id) {
  if (user.sede) {
    return true;
  }
  // Si no se pasa id de turno, cualquier coordinador vale
  id = id || user.turno;
  return (user.turno === id) && user.coord;
}

exports.isAuthenticated = isAuthenticated;
exports.getUser = getUser;
exports.signToken = signToken;
exports.setTokenCookie = setTokenCookie;
exports.guardarIdentificacion = guardarIdentificacion;
exports.identificar = identificar;
exports.turno = turno;
exports.coord = coord;
