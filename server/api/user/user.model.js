'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var UserSchema = new Schema({
  persona: { type: Schema.Types.ObjectId, ref: 'Persona' },
  sede: { type: Schema.Types.ObjectId, ref: 'Admin' },
  email: { type: String, lowercase: true },
  provider: String,
  facebook: {},
  google: {}
});

/**
 * Virtuals
 */

// Non-sensitive info we'll be putting in the token
UserSchema
  .virtual('token')
  .get(function() {
    return {
      '_id': this._id
    };
  });

module.exports = mongoose.model('User', UserSchema);
