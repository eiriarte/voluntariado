var winston = require('winston');
var passport = require('passport');
var FacebookStrategy = require('passport-facebook').Strategy;
var auth = require('../auth.service');

exports.setup = function (User, config) {
  passport.use(new FacebookStrategy({
      clientID: config.facebook.clientID,
      clientSecret: config.facebook.clientSecret,
      callbackURL: config.facebook.callbackURL,
      passReqToCallback: true
    },
    function(req, accessToken, refreshToken, profile, done) {
      User.findOne({
        'facebook.id': profile.id
      },
      function(err, user) {
        if (err) {
          winston.error('Error localizando usuario %s vía Facebook', profile.id);
          return done(err);
        }
        if (!user) {
          auth.identificar(req, function(err, data) {
            if (err) { return done(err); }
            if (!data) { return done(null, false); }
            user = new User({
              persona: data.persona,
              sede: data.sede,
              email: profile.emails[0].value,
              provider: 'facebook',
              facebook: profile._json
            });
            user.save(function(err) {
              if (err) {
                winston.error('Error insertando el nuevo usuario %j', user.toObject(), {});
                done(err);
              }
              winston.info('alta: Generado correctamente el nuevo usuario vía Facebook: %j', user.toObject(), {});
              return done(err, user);
            });
          });
        } else {
          winston.verbose('Usuario autenticado correctamente vía Facebook: %j', user.toObject(), {});
          return done(err, user);
        }
      })
    }
  ));
};
