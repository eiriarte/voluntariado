'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var estados = [ 'si', 'no' ]; // Asiste o No asiste

var AsistenciaSchema = new Schema({
  anno: { type: Number, min: 1900, max: 2200, required: true },
  mes: { type: Number, min: 1, max: 12, required: true },
  dia: { type: Number, min: 1, max: 31, required: true },
  turno: { type: Schema.Types.ObjectId, ref: 'Turno', required: true },
  persona: { type: Schema.Types.ObjectId, ref: 'Persona', required: true },
  estado: { type: String, enum: estados, required: true }
});

module.exports = mongoose.model('Asistencia', AsistenciaSchema);
