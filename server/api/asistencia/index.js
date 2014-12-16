'use strict';

var express = require('express');
var controller = require('./asistencia.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', controller.index);
router.get('/:id', controller.show);
router.post('/', auth.getUser(true), controller.save);
router.delete('/:id', auth.getUser(true), controller.destroy);

module.exports = router;
