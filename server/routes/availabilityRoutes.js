const express = require('express');
const router = express.Router();
const {
  setAvailability,
  getAvailabilityByDoctor,
} = require('../controllers/availabilityController');
const { protect } = require('../middleware/authMiddleware');

// ✅ Set availability (only for doctors, requires auth)
router.post('/', protect, setAvailability);

// ✅ Get availability for a doctor (publicly accessible)
router.get('/:doctorId', getAvailabilityByDoctor);

module.exports = router;
