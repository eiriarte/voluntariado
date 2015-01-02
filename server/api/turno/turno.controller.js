'use strict';

var _ = require('lodash');
var winston = require('winston');
var Turno = require('./turno.model');

// Devuelve la lista completa de turnos
var getTurnos = function(cb) {
  Turno.find(function (err, turnos) {
    cb(err, turnos);
  });
}

exports.getTurnos = getTurnos;

// Get list of turnos
exports.index = function(req, res) {
  Turno.find(function (err, turnos) {
    if(err) { return handleError(res, err); }
    return res.status(200).json(turnos);
  });
};

// Get a single turno
exports.show = function(req, res) {
  Turno.findById(req.params.id, function (err, turno) {
    if(err) { return handleError(res, err); }
    if(!turno) { return res.send(404); }
    return res.json(turno);
  });
};

// Creates a new turno in the DB.
exports.create = function(req, res) {
  Turno.create(req.body, function(err, turno) {
    if(err) { return handleError(res, err); }
    return res.status(201).json(turno);
  });
};

// Updates an existing turno in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Turno.findById(req.params.id, function (err, turno) {
    if (err) { return handleError(res, err); }
    if(!turno) { return res.send(404); }
    var updated = _.merge(turno, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.status(200).json(turno);
    });
  });
};

// Deletes a turno from the DB.
exports.destroy = function(req, res) {
  Turno.findById(req.params.id, function (err, turno) {
    if(err) { return handleError(res, err); }
    if(!turno) { return res.send(404); }
    turno.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  winston.error('Error en /api/turnos: %j', err, {});
  return res.send(500, err);
}
