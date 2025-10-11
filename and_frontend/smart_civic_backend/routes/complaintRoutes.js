
const express = require('express');
const router = express.Router();
const { getComplaints, createComplaint } = require('../controllers/complaintController');

router.route('/').get(getComplaints).post(createComplaint);

module.exports = router;
