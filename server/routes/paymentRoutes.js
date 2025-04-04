const express = require('express');
const router = express.Router();
const {
  createPaymentRecord,
  getUserPayments,
  getDoctorPayments,
} = require('../controllers/paymentController');

const authenticate = require('../middleware/authMiddleware');

// ✅ Create a payment record after successful payment (usually triggered by webhook or client confirmation)
router.post('/', authenticate, createPaymentRecord);

// ✅ Get all payments made by a user
router.get('/user', authenticate, getUserPayments);

// ✅ Get all payments received by a doctor
router.get('/doctor', authenticate, getDoctorPayments);

module.exports = router;
