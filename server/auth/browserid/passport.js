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
