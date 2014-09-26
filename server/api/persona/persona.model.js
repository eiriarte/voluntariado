'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var PersonaSchema = new Schema({
  nombre: String,
  apellidos: String,
  turnos: [{
    turno: { type: Schema.Types.ObjectId, ref: 'Turno' },
    alta: { type: Date, default: Date.now }
  }],
  estados: [{
    estado: String,
    fecha: { type: Date, default: Date.now }
  }]
});

module.exports = mongoose.model('Persona', PersonaSchema);
