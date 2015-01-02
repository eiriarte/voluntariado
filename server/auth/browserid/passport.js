var winston = require('winston');
var passport = require('passport');
var BrowserIDStrategy = require('passport-browserid').Strategy;
var auth = require('../auth.service');

exports.setup = function (User, config) {
  passport.use(new BrowserIDStrategy({
      audience: config.browserid.audience,
      passReqToCallback: true
    },
    function(req, email, done) {
      User.findOne({ email: email }, function (err, user) {
        if (err) {
          winston.error('Error localizando usuario %s vía BrowserID', email);
          return done(err);
        }
        if (!user) {
          auth.identificar(req, function(err, data) {
            if (err) { return done(err); }
            if (!data) { return done(null, false); }
            user = new User({
              persona: data.persona,
              sede: data.sede,
              email: email,
              provider: 'browserid'
            });
            user.save(function(err) {
              if (err) {
                winston.error('Error insertando el nuevo usuario %j', user.toObject(), {});
                done(err);
              }
              winston.info('Generado correctamente el nuevo usuario vía BrowserID: %j', user.toObject(), {});
              return done(err, user);
            });
          });
        } else {
          winston.verbose('Usuario autenticado correctamente vía BrowserID: %j', user.toObject(), {});
          return done(err, user);
        }
      });
    }
  ));
};
