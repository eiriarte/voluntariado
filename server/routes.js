/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');
var personas = require('./api/persona/persona.controller');
var turnos = require('./api/turno/turno.controller');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/turnos', require('./api/turno'));
  app.use('/api/personas', require('./api/persona'));
  app.use('/api/asistencias', require('./api/asistencia'));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      personas.getPersonas(function (err, personas) {
        if(err) { return res.send(500, err); }
        app.locals.personas = personas;
        turnos.getTurnos(function (err, turnos) {
          if(err) { return res.send(500, err); }
          app.locals.turnos = turnos;
          res.render('index');
        });
      });
    });
};
