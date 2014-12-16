/**
 * Express configuration
 */

'use strict';

var express = require('express');
var favicon = require('serve-favicon');
var morgan = require('morgan');
var compression = require('compression');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var cookieParser = require('cookie-parser');
var errorHandler = require('errorhandler');
var path = require('path');
var express_enforces_ssl = require('express-enforces-ssl');
var config = require('./environment');
var passport = require('passport');
var session = require('express-session');
var mongoStore = require('connect-mongo')(session);
var mongoose = require('mongoose');

module.exports = function(app) {
  var env = app.get('env');

  app.set('views', config.root + '/server/views');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');
  app.use(compression());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(methodOverride());
  app.use(cookieParser());
  app.use(passport.initialize());

  app.enable('trust proxy');

  // Persist sessions with mongoStore
  app.use(session({
    secret: config.secrets.session,
    resave: false,
    saveUninitialized: false,
    cookie: { secure: ('production' === env) },
    store: new mongoStore({ mongoose_connection: mongoose.connection })
  }));

  if ('production' === env) {
    app.use(express_enforces_ssl());
    app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use(express.static(path.join(config.root, 'public'), { index: 'noindex' }));
    app.set('appPath', config.root + '/public');
    app.use(morgan('dev'));
  }

  if ('development' === env || 'test' === env) {
    // Simular latencia de BD de 2000ms en desarrollo
    app.use('/api', function(req, res, next) { setTimeout(next, 2000); });
    app.use(require('connect-livereload')());
    app.use(express.static(path.join(config.root, '.tmp'), { index: 'noindex' }));
    app.use(express.static(path.join(config.root, 'client'), { index: 'noindex' }));
    app.set('appPath', 'client');
    app.use(morgan('dev'));
    app.use(errorHandler()); // Error handler - has to be last
  }
};
