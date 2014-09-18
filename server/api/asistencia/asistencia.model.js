'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AsistenciaSchema = new Schema({
  anno: Number,
  mes: Number,
  dia: Number,
  turno: String,
  persona: String,
  estado: String
});

module.exports = mongoose.model('Asistencia', AsistenciaSchema);
