const express = require('express');
const router = express.Router();

const {
  bookAppointment,
  getAppointmentsForUser,
  uploadPrescription,
  getPrescription,
  updateAppointmentStatus,
  getAppointmentsForFamilyMember,
  downloadPrescription,
} = require('../controllers/appointmentController');

const { authenticateUser } = require('../middleware/authMiddleware');
const { uploadPrescription: prescriptionUpload } = require('../utils/upload'); // ✅ Named import for Multer middleware

// ✅ Book an appointment (requires JWT token)
router.post('/', authenticateUser, bookAppointment);

// ✅ Get all appointments for the logged-in user (patient or doctor)
router.get('/my', authenticateUser, getAppointmentsForUser);

// ✅ Upload prescription for an appointment (requires JWT token + file)
router.patch('/:id/prescription', authenticateUser, prescriptionUpload.single('file'), uploadPrescription);

// ✅ Get prescription for an appointment (requires JWT token)
router.get('/:id/prescription', authenticateUser, getPrescription);

// ✅ Update appointment status (requires JWT token)
router.patch('/:id/status', authenticateUser, updateAppointmentStatus);

// ✅ Get appointments for a specific family member (requires JWT token)
router.get('/family/:familyMemberId', authenticateUser, getAppointmentsForFamilyMember);

// ✅ Download prescription file
router.get('/:id/prescription/download', authenticateUser, downloadPrescription);

module.exports = router;