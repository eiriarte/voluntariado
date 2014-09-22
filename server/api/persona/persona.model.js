'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var PersonaSchema = new Schema({
  nombre: String,
  apellidos: String,
  turno: String,
  estados: [{ estado: String, fecha: Date }]
});

module.exports = mongoose.model('Persona', PersonaSchema);
