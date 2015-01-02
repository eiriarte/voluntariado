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
var csrf = require('csurf');
var helmet = require('helmet');
var winston = require('winston');
var errors = require('../components/errors');

module.exports = function(app) {
  var env = app.get('env');

  app.set('views', config.root + '/server/views');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');
  app.use(compression());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(methodOverride());
  app.use(cookieParser(config.secrets.session));
  app.use(passport.initialize());

  app.enable('trust proxy');

  // Persist sessions with mongoStore
  app.use(session({
    secret: config.secrets.session,
    resave: false,
    saveUninitialized: false,
    cookie: { httpOnly: true, secure: ('production' === env) },
    key: 'session',
    store: new mongoStore({ mongooseConnection: mongoose.connection })
  }));

  // Protección contra ataques XSRF
  app.use(csrf());
  app.use(function(req, res, next) {
    res.cookie('XSRF-TOKEN', req.csrfToken());
    next();
  });

  // Protección contra ataques XSS
  var csp = {
    defaultSrc: [ "'none'" ],
    scriptSrc: [
      "'self'",
      "'unsafe-inline'",
      "'unsafe-eval'",
      'https://login.persona.org',
      'https://ajax.googleapis.com'
    ],
    frameSrc: [ 'https://login.persona.org' ],
    fontSrc: [ "'self'" ],
    styleSrc: [ "'self'", "'unsafe-inline'" ],
    connectSrc: [ "'self'" ],
    imgSrc: [ "'self'", 'data:' ]
  }
  if ('development' === env) {
    // Livereload
    csp.scriptSrc.push('http://localhost:35729');
    csp.connectSrc.push('ws://localhost:35729');
  }
  app.use(helmet.contentSecurityPolicy(csp));
  app.use(helmet.xssFilter());

  // Protección contra secuestros de click (Clickjacking)
  app.use(helmet.frameguard('deny'));
  // Cabecera HTTP Strict-Transport-Security
  app.use(helmet.hsts( { maxAge: 10886400000, includeSubdomains: true }));
  // Ocultar información del software del servidor
  app.use(helmet.hidePoweredBy({ setTo: 'Enanito con manivela' }));
  // Desactivar caché
  app.use(helmet.noCache());
  // Impedir que el navegador trate de "adivinar" el tipo MIME
  app.use(helmet.noSniff());
  // Impedir cargar recursos desde Adobe Flash, entre otros
  app.use(helmet.crossdomain());

  if ('production' === env) {
    // Forzar conexión segura
    app.use(express_enforces_ssl());

    app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use(express.static(path.join(config.root, 'public'), { index: 'noindex' }));
    app.set('appPath', config.root + '/public');
    app.use(morgan('combined'));
    app.use(errors[500]);
  }

  if ('development' === env || 'test' === env) {
    // Simular latencia de BD de 2000ms en desarrollo
    app.use('/api', function(req, res, next) { setTimeout(next, 2000); });

    // Nivel de log: 'debug'
    winston.default.transports.console.level = 'debug'

    app.use(require('connect-livereload')());
    app.use(express.static(path.join(config.root, '.tmp'), { index: 'noindex' }));
    app.use(express.static(path.join(config.root, 'client'), { index: 'noindex' }));
    app.set('appPath', 'client');
    app.use(morgan('dev'));
    app.use(errorHandler()); // Error handler - has to be last
  }
};
