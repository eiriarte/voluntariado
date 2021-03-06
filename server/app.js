/**
 * Main application file
 */

'use strict';

// Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var express = require('express');
var mongoose = require('mongoose');
var winston = require('winston');
var config = require('./config/environment');

// Connect to database
mongoose.set('debug', config.mongo.debug);
mongoose.connect(config.mongo.uri, config.mongo.options);

// Setup server
var app = express();
var server = require('http').createServer(app);
require('./config/express')(app);
require('./routes')(app);

// Start server
server.listen(config.port, config.ip, function () {
  winston.info('Express server listening on %d, in %s mode', config.port, app.get('env'));
});

process.on('SIGTERM', function() {
  server.close();
  winston.info('Recibida SIGTERM: Terminando proceso…');
  process.exit();
});

// Expose app
exports = module.exports = app;
