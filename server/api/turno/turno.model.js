'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var franjas = ['m', 't']; // Mañana o Tarde

var TurnoSchema = new Schema({
  nombre: { type: String, required: true, trim: true },
  dia: { type: Number, required: true, min: 0, max: 6 },
  franja: { type: String, required: true, enum: franjas },
  entrada: { type: String, required: true, trim: true },
  salida: { type: String, required: true, trim: true }
});

module.exports = mongoose.model('Turno', TurnoSchema);
