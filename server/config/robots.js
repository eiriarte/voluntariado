'use strict';

var winston = require('winston');
var config = require('./environment');
var session = require('express-session');
var mongoStore = require('connect-mongo')(session);
var mongoose = require('mongoose');


var isRobot = /Typhoeus|curl|Bot|B-O-T|Crawler|Spider|Spyder|Yahoo|ia_archiver|Covario-IDS|findlinks|DataparkSearch|larbin|Mediapartners-Google|NG-Search|Snappy|Teoma|Jeeves|Charlotte|NewsGator|TinEye|Cerberian|SearchSight|Zao|Scrubby|Qseero|PycURL|Pompos|oegp|SBIder|yoogliFetchAgent|yacy|webcollage|VYU2|voyager|updated|truwoGPS|StackRambler|Sqworm|silk|semanticdiscovery|ScoutJet|Nymesis|NetResearchServer|MVAClient|mogimogi|Mnogosearch|Arachmo|Accoona|holmes|htdig|ichiro|webis|LinkWalker|lwp-trivial|facebookexternalhit|Spinn3r/i;

var isDevice = /phone|Playstation/i;

exports.humanSession = function(env) {
  var humanSession = session({
    secret: config.secrets.session,
    resave: false,
    saveUninitialized: false,
    cookie: { httpOnly: true, secure: ('production' === env) },
    key: 'session',
    store: new mongoStore({ mongooseConnection: mongoose.connection })
  });

  return function(req, res, next) {
      var ua = req.get('user-agent');

      if (isRobot.test(ua) && !isDevice.test(ua)) {
          req.isRobot = true;
          winston.info('Robot detectado. No se guarda sesión');
          next();
      } else {
          req.isRobot = false;
          humanSession(req, res, next);
      }
  };
}
