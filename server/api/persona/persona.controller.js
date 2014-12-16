'use strict';

var _ = require('lodash');
var utils = require('../../components/utils');
var Persona = require('./persona.model');
var auth = require('../../auth/auth.service');

// Devuelve todas las personas de la colección 'personas'
var getPersonas = function(user, cb) {
  var campos = '';
  if (_.isFunction(user)) {
    cb = user;
    user = undefined;
  }
  if (!user) {
    campos += ' -nombre -apellidos';
  } else if (user.sede || auth.coord(user)) {
    campos += ' +identificacion';
  }
  Persona.find({}, campos, function(err, personas) {
    cb(err, personas);
  });
}

exports.getPersonas = getPersonas;

exports.getIdentificacion = function(codigo, done) {
  Persona.findOne({ identificacion: codigo }, function (err, persona) {
    if(err) { return done(err); }
    if(!persona) { return done({ codigo: 212, mensaje: 'Codigo no válido.' }); }
    var nombre = persona.nombre + ' ' + persona.apellidos;
    var turno = _.last(persona.turnos).turno
    done(null, { nombre: nombre, turno: turno });
  });
};

// Get list of personas
exports.index = function(req, res) {
  getPersonas(req.user, function (err, personas) {
    if(err) { return handleError(res, err); }
    return res.json(200, personas);
  });
};

// Get a single persona
exports.show = function(req, res) {
  Persona.findById(req.params.id, function (err, persona) {
    if(err) { return handleError(res, err); }
    if(!persona) { return res.send(404); }
    return res.json(persona);
  });
};

// Creates a new persona in the DB.
exports.create = function(req, res) {
  var defaults = { estados: [{ estado: 'A' }] };
  var datos = _.pick(req.body, ['nombre', 'apellidos', 'coord', 'estados', 'turnos']);

  if (_.isArray(datos.turnos) && auth.coord(req.user, _.last(datos.turnos).turno)) {
    datos = _.extend(defaults, datos);
    datos.identificacion = utils.nuevaIdentificacion();
  } else {
    return res.json(401, { codigo: 213, mensaje: 'No tienes permiso para dar altas en este grupo.' });
  }

  Persona.create(datos, function(err, persona) {
    if(err) { return handleError(res, err); }
    return res.json(201, persona);
  });
};

// Guarda un nuevo estado de la persona
exports.nuevoEstado = function(req, res) {
  var estado = req.body.estado;
  var datos = { estado: estado };
  if (estado !== 'A' && estado !== 'B' && estado !== 'I') {
    return res.json(400, { codigo: 210, mensaje: 'Estado no válido.' });
  }
  // TODO: probar que se devuelve este error si procede (o al menos que no se devuelve si no procede)
  if (req.user.persona !== req.params.id) {
    return res.json(401, { codigo: 213, mensaje: 'No tienes permiso para modificar este estado.' });
  }
  if (req.body.fecha) {
    datos.fecha = new Date(req.body.fecha);
  }
  Persona.findByIdAndUpdate(req.params.id, { $push: { estados: datos }}, function(err, data) {
    if(err) { return handleError(res, err); }
    if (data && _.isArray(data.estados) && _.last(data.estados).estado === estado) {
      res.json(201, _.last(data.estados));
    } else {
      if(!data) { return res.send(404); }
      return res.json(500, { codigo: 211, mensaje: 'Imposible almacenar el estado.' });
    }
  });
};

// Registra un alta en otro turno (OBSOLETO, usar .update())
exports.nuevoTurno = function(req, res) {
  var turno = req.body.turno;
  var datos = { turno: turno };
  if (req.body.alta) {
    datos.alta = new Date(req.body.alta);
  }
  Persona.findByIdAndUpdate(req.params.id, { $push: { turnos: datos }}, function(err, data) {
    if(err) { return handleError(res, err); }
    if(!data) { return res.send(404); }
    if (data && _.isArray(data.turnos) && _.last(data.turnos).turno.toString() === turno) {
      res.json(201, _.last(data.turnos));
    } else {
      if(!data) { return res.send(404); }
      return res.json(500, { codigo: 211, mensaje: 'Imposible almacenar el turno.' });
    }
  });
};

// Updates an existing persona in the DB.
exports.update = function(req, res) {
  var turno, turnoAnterior, estado, estadoAnterior;
  if(req.body._id) { delete req.body._id; }
  Persona.findById(req.params.id, function (err, persona) {
    if (err) { return handleError(res, err); }
    if(!persona) { return res.send(404); }

    turnoAnterior = _.last(persona.turnos).turno.toString();

    if (req.user.persona !== persona._id.toString() &&
        !auth.coord(req.user, turnoAnterior)) {
      return res.json(401, { codigo: 213, mensaje: 'No tienes permiso para modificar esta ficha.'});
    }
    // Nombre:
    if (req.body.nombre) {
      persona.nombre = '' + req.body.nombre;
    }
    // Apellidos:
    if (req.body.apellidos) {
      persona.apellidos = '' + req.body.apellidos;
    }
    // ¿Coordinador/a?: sólo el coordinador puede cambiar el campo 'coordinador' de otro usuario
    if (req.body.coord !== undefined && auth.coord(req.user, turnoAnterior)) {
      persona.coord = !!req.body.coord;
    }
    // Turno:
    if (req.body.turnos && _.isArray(req.body.turnos)) {
      turno = _.last(req.body.turnos);
      // Sólo insertamos el nuevo turno si no coincide con el anterior en BD

      if (turno.turno !== turnoAnterior) {
        persona.turnos.push(turno);
      }
    }
    // Estado:
    if (req.body.estados && _.isArray(req.body.estados)) {
      estado = _.last(req.body.estados);
      estadoAnterior = _.last(persona.estados);
      // Sólo insertamos el nuevo estado si no coincide con el anterior en BD
      if (estado.estado !== estadoAnterior.estado) {
        persona.estados.push(estado);
      }
    }
    persona.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, persona);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
