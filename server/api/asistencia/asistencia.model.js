'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AsistenciaSchema = new Schema({
  anno: Number,
  mes: Number,
  dia: Number,
  turno: { type: Schema.Types.ObjectId, ref: 'Turno' },
  persona: { type: Schema.Types.ObjectId, ref: 'Persona' },
  estado: String
});

module.exports = mongoose.model('Asistencia', AsistenciaSchema);
