const express = require('express');
const router = express.Router();

const {
  registerDoctor,
  getDoctorProfile,
  getOwnDoctorProfile,
  updateDoctorProfile,
  deleteDoctorAccount
} = require('../controllers/doctorController');

const { authenticateUser } = require('../middleware/authMiddleware');

// ✅ Doctor registration (public)
router.post('/register', registerDoctor);

// ✅ Logged-in doctor: View own profile
router.get('/me', authenticateUser, getOwnDoctorProfile);

// ✅ Logged-in doctor: Update own profile
router.patch('/me', authenticateUser, updateDoctorProfile);

// ✅ Logged-in doctor: Delete own account
router.delete('/me', authenticateUser, deleteDoctorAccount);

// ✅ Public: Get doctor profile by ID
router.get('/:id', getDoctorProfile);

module.exports = router;
