const DoctorEarning = require('../models/earningModel');

const recordEarning = async (req, res) => {
  try {
    const { doctorId, appointmentId, amount, platformFee } = req.body;

    const earning = new DoctorEarning({
      doctorId,
      appointmentId,
      amount,
      platformFee,
    });

    await earning.save();
    res.status(201).json({ message: 'Doctor earning recorded', earning });
  } catch (err) {
    res.status(500).json({ message: 'Failed to record earning', error: err.message });
  }
};

const getDoctorEarnings = async (req, res) => {
  try {
    const { doctorId } = req.params;
    const earnings = await DoctorEarning.find({ doctorId }).sort({ createdAt: -1 });
    res.status(200).json(earnings);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch earnings', error: err.message });
  }
};

module.exports = {
  recordEarning,
  getDoctorEarnings,
};
