var winston = require('winston');
var passport = require('passport');
var GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
var auth = require('../auth.service');

exports.setup = function (User, config) {
  passport.use(new GoogleStrategy({
      clientID: config.google.clientID,
      clientSecret: config.google.clientSecret,
      callbackURL: config.google.callbackURL,
      passReqToCallback: true
    },
    function(req, accessToken, refreshToken, profile, done) {
      User.findOne({
        'google.id': profile.id
      },
      function(err, user) {
        if (err) {
          winston.error('Error localizando usuario %s vía Google', profile.id);
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
              provider: 'google',
              google: profile._json
            });
            user.save(function(err) {
              if (err) {
                winston.error('Error insertando el nuevo usuario %j', user.toObject(), {});
                done(err);
              }
              winston.info('Generado correctamente el nuevo usuario vía Google: %j', user.toObject(), {});
              return done(err, user);
            });
          });
        } else {
          winston.verbose('Usuario autenticado correctamente vía Google: %j', user.toObject(), {});
          return done(err, user);
        }
      });
    }
  ));
};
