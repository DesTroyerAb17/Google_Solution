const mongoose = require('mongoose');

const doctorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  phoneNumber: { type: String, required: true, unique: true },
  email: { type: String, required: true },
  registrationNumber: { type: String, required: true },
  aadhar: { type: String, required: true },
  pan: { type: String, required: true },
  stateMedicalCouncil: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Doctor', doctorSchema);
