const mongoose = require('mongoose');

const availabilitySchema = new mongoose.Schema({
  doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
  date: { type: String, required: true },
  timeSlots: [{ type: String }], // e.g., ['10:00 AM', '11:00 AM']
});

module.exports = mongoose.model('Availability', availabilitySchema);
