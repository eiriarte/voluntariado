'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var TurnoSchema = new Schema({
  nombre: String,
  dia: Number,
  franja: String,
  entrada: String,
  salida: String
});

module.exports = mongoose.model('Turno', TurnoSchema);
