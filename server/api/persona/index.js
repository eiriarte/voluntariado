'use strict';

var express = require('express');
var controller = require('./persona.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.post('/:id/estados', controller.nuevoEstado);
router.put('/:id', controller.update);

module.exports = router;
