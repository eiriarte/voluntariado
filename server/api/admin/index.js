'use strict';

var express = require('express');
var controller = require('./admin.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.getUser(), controller.index);
router.post('/', auth.getUser(), controller.create);
router.put('/:id', auth.getUser(), controller.update);

module.exports = router;
