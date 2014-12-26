'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AdminSchema = new Schema({
  nombre: { type: String, required: true, trim: true },
  apellidos: { type: String, required: true, trim: true },
  identificacion: { type: String, trim: true, select: false }
});

module.exports = mongoose.model('Admin', AdminSchema);
