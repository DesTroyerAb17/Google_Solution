const Appointment = require('../models/appointmentModel');
const Doctor = require('../models/doctorModel');
const User = require('../models/userModel');
const FamilyMember = require('../models/familyMemberModel');
const mongoose = require('mongoose');
const path = require('path');
const fs = require('fs');

// 🔗 Generate Jitsi video link
const generateJitsiLink = (doctorName) => {
  const room = `ayu_${doctorName.replace(/\s+/g, '')}_${Date.now()}`;
  return `https://meet.jit.si/${room}`;
};

// ➕ Book Appointment
const bookAppointment = async (req, res) => {
  try {
    const { doctorId, date, timeSlot, familyMemberId } = req.body;
    const userId = req.user.id;

    // Check if family member belongs to user
    if (familyMemberId) {
      const familyMember = await FamilyMember.findById(familyMemberId);
      if (!familyMember) return res.status(404).json({ message: 'Family member not found' });
      if (familyMember.userId.toString() !== userId)
        return res.status(403).json({ message: 'Unauthorized access to family member' });
    }

    if (!mongoose.Types.ObjectId.isValid(doctorId)) {
      return res.status(400).json({ message: 'Invalid doctorId' });
    }

    const existing = await Appointment.findOne({ doctorId, date, timeSlot });
    if (existing) return res.status(400).json({ message: 'Slot already booked' });

    const doctor = await Doctor.findById(doctorId);
    if (!doctor) return res.status(404).json({ message: 'Doctor not found' });

    const videoCallLink = generateJitsiLink(doctor.name);

    const appointment = new Appointment({
      userId,
      familyMemberId,
      doctorId,
      date,
      timeSlot,
      paymentStatus: false,
      videoCallLink,
    });

    await appointment.save();

    if (familyMemberId) {
      await FamilyMember.findByIdAndUpdate(familyMemberId, {
        $push: { appointments: appointment._id },
      });
    }

    res.status(201).json({ message: 'Appointment booked', appointment });
  } catch (err) {
    console.error('❌ Error booking appointment:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// 📥 Get Appointments for the logged-in user
const getAppointmentsForUser = async (req, res) => {
  try {
    const userId = req.user.id;

    const appointments = await Appointment.find({
      $or: [{ userId }, { doctorId: userId }],
    })
      .populate('doctorId', 'name email phoneNumber')
      .populate('familyMemberId', 'name gender')
      .sort({ date: 1 });

    res.status(200).json(appointments);
  } catch (err) {
    console.error('❌ Error fetching appointments:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// 🧒 Get appointments for specific family member
const getAppointmentsForFamilyMember = async (req, res) => {
  try {
    const { familyMemberId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(familyMemberId)) {
      return res.status(400).json({ message: 'Invalid familyMemberId' });
    }

    const appointments = await Appointment.find({ familyMemberId })
      .populate('doctorId', 'name email phoneNumber')
      .populate('familyMemberId', 'name gender')
      .sort({ date: 1 });

    res.status(200).json(appointments);
  } catch (err) {
    console.error('❌ Error in getAppointmentsForFamilyMember:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// 🩺 Upload Prescription
const uploadPrescription = async (req, res) => {
  try {
    const appointmentId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(appointmentId)) {
      return res.status(400).json({ message: 'Invalid appointmentId' });
    }

    const appointment = await Appointment.findById(appointmentId);
    if (!appointment) return res.status(404).json({ message: 'Appointment not found' });

    appointment.prescriptionUrl = `/uploads/prescriptions/${req.file.filename}`;
    await appointment.save();

    res.status(200).json({ message: 'Prescription uploaded', appointment });
  } catch (err) {
    console.error('❌ Error uploading prescription:', err);
    res.status(500).json({ message: 'Upload failed', error: err.message });
  }
};

// 📤 Download Prescription
const downloadPrescription = async (req, res) => {
  try {
    const appointmentId = req.params.id;

    const appointment = await Appointment.findById(appointmentId);
    if (!appointment || !appointment.prescriptionUrl) {
      return res.status(404).json({ message: 'Prescription not found' });
    }

    const filePath = path.join(__dirname, '..', appointment.prescriptionUrl);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: 'File missing on server' });
    }

    res.download(filePath);
  } catch (err) {
    console.error('❌ Error downloading prescription:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// ✅ Get Prescription Info (URL only)
const getPrescription = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const appointment = await Appointment.findById(appointmentId);

    if (!appointment || !appointment.prescriptionUrl) {
      return res.status(404).json({ message: 'Prescription not uploaded' });
    }

    res.status(200).json({ prescriptionUrl: appointment.prescriptionUrl });
  } catch (err) {
    console.error('❌ Error in getPrescription:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// ✏️ Update Appointment Status
const updateAppointmentStatus = async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const { status } = req.body;

    if (!['scheduled', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({ message: 'Invalid status value' });
    }

    const appointment = await Appointment.findByIdAndUpdate(
      appointmentId,
      { status },
      { new: true }
    );

    if (!appointment) return res.status(404).json({ message: 'Appointment not found' });

    res.status(200).json({ message: 'Status updated', appointment });
  } catch (err) {
    console.error('❌ Error updating appointment status:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = {
  bookAppointment,
  getAppointmentsForUser,
  getAppointmentsForFamilyMember,
  uploadPrescription,
  downloadPrescription,
  getPrescription,
  updateAppointmentStatus,
};
