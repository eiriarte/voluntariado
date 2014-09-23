'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var PersonaSchema = new Schema({
  nombre: String,
  apellidos: String,
  turno: String,
  estados: [{
    estado: String,
    fecha: { type: Date, default: Date.now }
  }]
});

module.exports = mongoose.model('Persona', PersonaSchema);
