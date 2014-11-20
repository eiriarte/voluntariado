'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var PersonaSchema = new Schema({
  nombre: { type: String, trim: true, required: true },
  apellidos: { type: String, trim: true, required: true },
  identificacion: { type: String, select: false },
  coord: { type: Boolean, default: false },
  turnos: [{
    turno: { type: Schema.Types.ObjectId, ref: 'Turno', required: true },
    alta: { type: Date, default: Date.now }
  }],
  estados: [{
    estado: { type: String, default: 'A' },
    fecha: { type: Date, default: Date.now }
  }]
});

module.exports = mongoose.model('Persona', PersonaSchema);
