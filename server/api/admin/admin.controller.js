'use strict';

var _ = require('lodash');
var utils = require('../../components/utils');
var Admin = require('./admin.model');

// Devuelve la lista completa de admins
var getAdmins = function(user, cb) {
  var campos = '';
  if (_.isFunction(user)) {
    cb = user;
    user = undefined;
  }
  if (!user) {
    campos += ' -nombre -apellidos';
  } else if (user.sede) {
    campos += ' +identificacion';
  }
  Admin.find({}, campos, function (err, admins) {
    cb(err, admins);
  });
}

exports.getAdmins = getAdmins;

exports.getIdentificacion = function(codigo, done) {
  Admin.findOne({ identificacion: codigo }, function (err, admin) {
    if(err) { return done(err); }
    if(!admin) { return done({ codigo: 312, mensaje: 'Codigo no válido.' }); }
    var nombre = admin.nombre + ' ' + admin.apellidos;
    done(null, { nombre: nombre });
  });
};

// Get list of admins
exports.index = function(req, res) {
  var campos = '';
  if (!req.user) {
    campos += ' -nombre -apellidos';
  }
  Admin.find({}, campos, function (err, admins) {
    if(err) { return handleError(res, err); }
    return res.json(200, admins);
  });
};

// Get a single admin
exports.show = function(req, res) {
  Admin.findById(req.params.id, function (err, admin) {
    if(err) { return handleError(res, err); }
    if(!admin) { return res.send(404); }
    return res.json(admin);
  });
};

// Creates a new admin in the DB.
exports.create = function(req, res) {
  var datos = _.pick(req.body, ['nombre', 'apellidos']);

  if (!req.user || !req.user.sede) {
    return res.json(401, { codigo: 300, mensaje: 'No tienes permiso para dar altas en la sede.' });
  }
  datos.identificacion = utils.nuevaIdentificacion();
  Admin.create(datos, function(err, admin) {
    if(err) { return handleError(res, err); }
    return res.json(201, admin);
  });
};

// Updates an existing admin in the DB.
exports.update = function(req, res) {
  if (!req.user || !req.user.sede) {
    return res.json(401, { codigo: 300, mensaje: 'No tienes permiso para modificar este registro.' });
  }
  if (req.body._id) { delete req.body._id; }
  Admin.findById(req.params.id, function (err, admin) {
    if (err) { return handleError(res, err); }
    if(!admin) { return res.send(404); }
    var updated = _.merge(admin, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, admin);
    });
  });
};

// Deletes a admin from the DB.
exports.destroy = function(req, res) {
  Admin.findById(req.params.id, function (err, admin) {
    if(err) { return handleError(res, err); }
    if(!admin) { return res.send(404); }
    admin.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
