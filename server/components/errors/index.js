'use strict';

var winston = require('winston');

module.exports[404] = function pageNotFound(req, res) {
  var viewFilePath = '404';
  var statusCode = 404;
  var result = {
    status: statusCode
  };

  res.status(result.status);
  res.render(viewFilePath, function (err) {
    if (err) { return res.status(result.status).json(result); }

    res.render(viewFilePath);
  });
};

module.exports[500] = function error500(err, req, res, next) {
  var viewFilePath = '500';
  var result = {};

  if (err.code === 'EBADCSRFTOKEN') {
    result.status = 403;
    result.message = 'La sesión ha expirado o se ha corrompido. Por favor, vuelve a iniciar sesión.';
  } else {
    result.status = 500;
    result.message = 'Se ha producido un error en el servidor. Por favor, intenta más tarde.';
  }

  res.status(result.status);

  res.render(viewFilePath, result, function (err) {
    if (err) { return res.status(result.status).json(result); }

    res.render(viewFilePath, result);
  });

  winston.error('error500(): %j', err, {});
};
