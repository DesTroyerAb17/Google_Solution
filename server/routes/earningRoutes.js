const express = require('express');
const router = express.Router();
const { getDoctorEarnings } = require('../controllers/earningController');
const authenticate = require('../middleware/authMiddleware');

// ✅ Get logged-in doctor's earnings
router.get('/me', authenticate, getDoctorEarnings);

module.exports = router;
