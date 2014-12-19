'use strict';

var _ = require('lodash');
var Asistencia = require('./asistencia.model');
var moment = require('moment');
var auth = require('../../auth/auth.service');

// Get list of asistencias
exports.index = function(req, res) {
  var anno = +req.query.anno;
  var mes = +req.query.mes;
  var desdeAnno = +req.query.desdeAnno;
  var desdeMes = +req.query.desdeMes;
  var query = {};
  var or = []
  if (mes || anno) {
    if (!anno || anno < 1900 || anno > 2200 || !mes || mes < 1 || mes > 12) {
      return res.json(400, { codigo: 120, mensaje: 'No se han especificado año y mes válidos.'});
    } else {
      query.anno = anno;
      query.mes = mes;
    }
  } else if (desdeMes || desdeAnno) {
    if (!desdeAnno || desdeAnno < 1900 || desdeAnno > 2200 || !desdeMes || desdeMes < 1 || desdeMes > 12) {
      return res.json(400, { codigo: 120, mensaje: 'No se han especificado año y mes válidos.'});
    } else {
      // anno > desdeAnno || anno === desdeAnno && mes >= desdeMes
      or.push({ anno: { $gt: desdeAnno }});
      or.push({ anno: desdeAnno, mes: { $gte: desdeMes }});
      query = { $or: or };
    }
  } else {
    return res.json(400, { codigo: 120, mensaje: 'No se han especificado año y mes válidos.'});
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
  var fecha = moment([ anno, mes - 1, dia ]);
  var turno = req.body.turno.trim();
  var persona = req.body.persona.trim();
  var estado = req.body.estado.trim().toLowerCase();
  var query = {}, update = {};
  if (!auth.turno(req.user, turno)) {
    return res.json(401, { codigo: 114, mensaje: 'No tienes permiso para modificar esta asistencia.'});
  } else {
    console.log('Usuario del turno o sede validado correctamente');
  }
  if (!fecha.isValid()) {
    return res.json(400, { codigo: 110, mensaje: 'No se han especificado año, mes y día válidos.'});
  } else if (turno.length === 0 || persona.length === 0) {
    return res.json(400, { codigo: 111, mensaje: 'No se han especificado turno y persona.'});
  } else if (estado !== 'si' && estado !== 'no') {
    return res.json(400, { codigo: 112, mensaje: 'El estado debe ser "si" o "no".'});
  } else if (fecha.isBefore(moment(), 'day')) {
    return res.json(400, { codigo: 113, mensaje: 'No se puede cambiar el pasado.'});
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

    if (asistencia.persona.toString() !== req.user.persona &&
        !auth.coord(req.user, asistencia.turno.toString())) {
      return res.json(401, { codigo: 131, mensaje: 'No tienes permiso para borrar esta asistencia.'});
    }

    asistencia.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
