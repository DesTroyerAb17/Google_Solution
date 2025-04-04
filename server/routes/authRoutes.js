const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authenticateUser } = require('../middleware/authMiddleware');

// 📲 OTP-based authentication routes
router.post('/send-otp', authController.sendOTP);
router.post('/verify-otp', authController.verifyOTP);
router.get('/check-phone', authController.checkPhoneNumberExists); // 👈 New route
// 👤 Profile routes (protected)
router.get('/me', authenticateUser, authController.getUserProfile);
router.patch('/me', authenticateUser, authController.updateUserProfile);
router.delete('/delete', authenticateUser, authController.deleteUser);
router.post('/logout', authenticateUser, authController.logoutUser);

module.exports = router;
