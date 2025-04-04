const Availability = require('../models/availabilityModel');
const Appointment = require('../models/appointmentModel');

// Doctor sets availability
const setAvailability = async (req, res) => {
  const { doctorId, date, timeSlots } = req.body;

  try {
    const availability = new Availability({
      doctorId,
      date,
      timeSlots,
    });

    await availability.save();
    res.status(201).json({ message: 'Availability set successfully', availability });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Get availability for a doctor
const getAvailabilityByDoctor = async (req, res) => {
  try {
    const { doctorId } = req.params;
    const availability = await Availability.find({ doctorId });
    res.status(200).json(availability);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Book an appointment
const bookAppointment = async (req, res) => {
  const { patientId, doctorId, date, timeSlot } = req.body;

  try {
    // Save appointment
    const appointment = new Appointment({
      patientId,
      doctorId,
      date,
      timeSlot,
      paymentStatus: false, // Default until payment is confirmed
    });

    await appointment.save();
    res.status(201).json({ message: 'Appointment booked', appointment });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Get appointments for a user (patient or doctor)
const getAppointments = async (req, res) => {
  const { id } = req.params;

  try {
    const appointments = await Appointment.find({
      $or: [{ doctorId: id }, { patientId: id }],
    })
      .populate('doctorId', 'name')
      .populate('patientId', 'name');

    res.status(200).json(appointments);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = {
  setAvailability,
  getAvailabilityByDoctor,
  bookAppointment,
  getAppointments,
};
