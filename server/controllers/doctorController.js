const Doctor = require('../models/doctorModel');
const User = require('../models/userModel');

// ✅ Register a doctor
const registerDoctor = async (req, res) => {
  try {
    console.log("📩 Received doctor registration request.");
    console.log("📦 Request Body:", req.body);

    const {
      name,
      email,
      phoneNumber,
      registrationNumber,
      aadhar,
      pan,
      stateMedicalCouncil
    } = req.body;

    // Basic null/undefined checks
    if (!name || !email || !phoneNumber || !registrationNumber || !aadhar || !pan || !stateMedicalCouncil) {
      return res.status(400).json({ message: "❌ Missing required fields" });
    }

    const doctorExists = await Doctor.findOne({ phoneNumber });
    const userExists = await User.findOne({ phoneNumber });

    if (doctorExists || userExists) {
      return res.status(400).json({ message: '❌ Phone number already in use' });
    }

    const doctor = new Doctor({
      name,
      email,
      phoneNumber,
      registrationNumber,
      aadhar,
      pan,
      stateMedicalCouncil
    });

    await doctor.save();
    console.log(`✅ Doctor registered: ${name}, ${email}`);

    res.status(201).json({
      message: 'Doctor registered successfully. Please log in via OTP.',
      doctor
    });
  } catch (err) {
    console.error("🔥 Error registering doctor:", err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};


// ✅ Get doctor profile by ID
const getDoctorProfile = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json(doctor);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// ✅ Get current logged-in doctor's own profile
const getOwnDoctorProfile = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.user.id);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json(doctor);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// ✅ Update doctor profile
const updateDoctorProfile = async (req, res) => {
  try {
    const updates = req.body;
    const doctor = await Doctor.findByIdAndUpdate(req.user.id, updates, { new: true });

    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }

    res.status(200).json({ message: 'Doctor profile updated', doctor });
  } catch (err) {
    res.status(500).json({ message: 'Update failed', error: err.message });
  }
};

// ✅ Delete doctor account
const deleteDoctorAccount = async (req, res) => {
  try {
    const doctor = await Doctor.findByIdAndDelete(req.user.id);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json({ message: 'Doctor account deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Account deletion failed', error: err.message });
  }
};

module.exports = {
  registerDoctor,
  getDoctorProfile,
  getOwnDoctorProfile,
  updateDoctorProfile,
  deleteDoctorAccount
};
