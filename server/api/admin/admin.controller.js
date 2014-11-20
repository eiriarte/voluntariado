'use strict';

var _ = require('lodash');
var Admin = require('./admin.model');

// Devuelve la lista completa de admins
var getAdmins = function(cb) {
  Admin.find(function (err, admins) {
    cb(err, admins);
  });
}

exports.getAdmins = getAdmins;

// Get list of admins
exports.index = function(req, res) {
  Admin.find(function (err, admins) {
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
  Admin.create(req.body, function(err, admin) {
    if(err) { return handleError(res, err); }
    return res.json(201, admin);
  });
};

// Updates an existing admin in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
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
