'use strict';

var _ = require('lodash');
var Asistencia = require('./asistencia.model');

var esBisiesto = function(yr) {
  return (yr % 400) ? ((yr % 100) ? ((yr % 4) ? false : true) : false) : true;
}

// Devuelve el último día del mes (28-31)
var maxMes = function(mes, anno) {
  var maxes = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (mes !== 2) {
    return maxes[mes - 1]
  } else {
    return esBisiesto(anno) ? 29 : 28;
  }
}

// Get list of asistencias
exports.index = function(req, res) {
  var anno = +req.query.anno;
  var mes = +req.query.mes;
  var query = {};
  if (!anno || anno < 1900 || anno > 2200 || !mes || mes < 1 || mes > 12) {
    return res.json(400, { codigo: 120, mensaje: 'No se han especificado año y mes válidos.'});
  } else {
    query.anno = anno;
    query.mes = mes;
  }
  Asistencia.find(query, function (err, asistencias) {
    if(err) { return handleError(res, err); }
    return res.json(200, asistencias);
  });
};

// Get a single asistencia
exports.show = function(req, res) {
  Asistencia.findById(req.params.id, function (err, asistencia) {
    if(err) { return handleError(res, err); }
    if(!asistencia) { return res.send(404); }
    return res.json(asistencia);
  });
};

// Creates a new asistencia in the DB.
exports.save = function(req, res) {
  var anno = +req.body.anno;
  var mes = +req.body.mes;
  var dia = +req.body.dia;
  var turno = req.body.turno.trim();
  var persona = req.body.persona.trim();
  var estado = req.body.estado.trim().toLowerCase();
  var query = {}, update = {};
  if (!anno || anno < 1900 || anno > 2200 || !mes || mes < 1 || mes > 12 || !dia || dia < 1 || dia > maxMes(mes, anno)) {
    return res.json(400, { codigo: 110, mensaje: 'No se han especificado año, mes y día válidos.'});
  } else if (turno.length === 0 || persona.length === 0) {
    return res.json(400, { codigo: 111, mensaje: 'No se han especificado turno y persona.'});
  } else if (estado !== 'si' && estado !== 'no') {
    return res.json(400, { codigo: 112, mensaje: 'El estado debe ser "si" o "no".'});
  } else {
    query.anno = anno;
    query.mes = mes;
    query.dia = dia;
    query.turno = turno;
    query.persona = persona;
    update.estado = estado;
  }
  Asistencia.findOneAndUpdate(query, update, { upsert: true }, function(err, asistencia) {
    if(err) { return handleError(res, err); }
    res.location('/api/asistencias/' + asistencia._id);
    return res.json(201, asistencia);
  });
};

// Deletes a asistencia from the DB.
exports.destroy = function(req, res) {
  Asistencia.findById(req.params.id, function (err, asistencia) {
    if(err) { return handleError(res, err); }
    if(!asistencia) { return res.send(404); }
    asistencia.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
