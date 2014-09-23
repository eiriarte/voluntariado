'use strict';

var _ = require('lodash');
var Persona = require('./persona.model');

// Devuelve todas las personas de la colección 'personas'
var getPersonas = function(cb) {
  Persona.find(function(err, personas) {
    cb(err, personas);
  });
}

exports.getPersonas = getPersonas;

// Get list of personas
exports.index = function(req, res) {
  getPersonas(function (err, personas) {
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
  Persona.create(req.body, function(err, persona) {
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

// Updates an existing persona in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Persona.findById(req.params.id, function (err, persona) {
    if (err) { return handleError(res, err); }
    if(!persona) { return res.send(404); }
    var updated = _.merge(persona, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, persona);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
