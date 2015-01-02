'use strict';

var express = require('express');
var controller = require('./persona.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.getUser(true), controller.index);
router.post('/', auth.getUser(true), controller.create);
router.post('/:id/estados', auth.getUser(true), controller.nuevoEstado);
router.put('/:id', auth.getUser(true), controller.update);

module.exports = router;
