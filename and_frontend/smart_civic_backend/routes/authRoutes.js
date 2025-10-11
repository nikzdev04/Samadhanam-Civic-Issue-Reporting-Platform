
const express = require('express');
const { authWithGoogle } = require('../controllers/authController');
const router = express.Router();

router.post('/google', authWithGoogle);

module.exports = router;
