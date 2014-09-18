'use strict';

var express = require('express');
var controller = require('./asistencia.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', controller.save);
router.delete('/:id', controller.destroy);

module.exports = router;
