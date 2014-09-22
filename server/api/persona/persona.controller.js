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
