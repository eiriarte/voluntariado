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
        if (err) { return done(err); }
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
              if (err) done(err);
              return done(err, user);
            });
          });
        } else {
          return done(err, user);
        }
      });
    }
  ));
};