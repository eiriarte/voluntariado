/**
 * Main application routes
 */

'use strict';

var async = require('async');
var errors = require('./components/errors');
var personas = require('./api/persona/persona.controller');
var turnos = require('./api/turno/turno.controller');
var admins = require('./api/admin/admin.controller');
var auth = require('./auth/auth.service');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/admins', require('./api/admin'));
  app.use('/api/turnos', require('./api/turno'));
  app.use('/api/personas', require('./api/persona'));
  app.use('/api/asistencias', require('./api/asistencia'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // Obtiene los datos de la persona que se está identificando (registro)
  app.route('/id/:codigo').get(function(req, res, next) {
    personas.getIdentificacion(req.params.codigo, function(err, data) {
      if (err) {
        if (212 === err.codigo) {
          app.locals.identificacion = 404;
        } else {
          return res.send(500, err);
        }
      } else {
        app.locals.identificacion = data;
        app.locals.identificacion.vid = req.params.codigo;
      }
      next('route');
    });
  });

  // Obtiene los datos de la persona que se está identificando (registro)
  app.route('/sede/id/:codigo').get(function(req, res, next) {
    admins.getIdentificacion(req.params.codigo, function(err, data) {
      if (err) {
        if (312 === err.codigo) {
          app.locals.identificacion = 404;
        } else {
          return res.send(500, err);
        }
      } else {
        app.locals.identificacion = data;
        app.locals.identificacion.sid = req.params.codigo;
      }
      next('route');
    });
  });

  // All other routes should redirect to the index.html
  app.route('/*').get(auth.getUser(true), function(req, res) {
    console.log('USER: ', req.user);
    var getPersonas = function(done) {
      personas.getPersonas(req.user, function (err, personas) {
        if(err) { return done(err); }
        app.locals.personas = personas;
        done(null);
      });
    };

    var getTurnos = function(done) {
      turnos.getTurnos(function (err, turnos) {
        if(err) { return done(err); }
        app.locals.turnos = turnos;
        done(null);
      });
    };

    var getAdmins = function(done) {
      admins.getAdmins(req.user, function (err, admins) {
        if(err) { return done(err); }
        app.locals.admins = admins;
        done(null);
      });
    };

    if (!app.locals.identificacion) {
      app.locals.identificacion = '';
    }

    async.series([ getPersonas, getTurnos, getAdmins ], function(err) {
      if(err) { return res.send(500, err); }
      res.render('index');
    });
  });
};
