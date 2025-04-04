const mongoose = require('mongoose');

const doctorEarningSchema = new mongoose.Schema({
  doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
  appointmentId: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  totalAmount: { type: Number, required: true }, // what patient paid
  platformFee: { type: Number, default: 0 },     // deducted by platform
  doctorPayout: { type: Number, required: true }, // amount doctor will get
  payoutStatus: { type: String, enum: ['pending', 'paid'], default: 'pending' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('DoctorEarning', doctorEarningSchema);
