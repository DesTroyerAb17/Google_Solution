const Payment = require('../models/paymentModel');
const Appointment = require('../models/appointmentModel');  // Add this import

// @desc Create a new payment record (after successful payment or webhook)
const createPaymentRecord = async (req, res) => {
  try {
    const { userId, amount, paymentMethod, status, appointmentId } = req.body;

    // Create a new payment record
    const payment = new Payment({
      userId,
      amount,
      paymentGateway: paymentMethod,  // Save the payment method used (e.g., Stripe, Razorpay)
      paymentStatus: status,  // Status will be 'success', 'failed', or 'pending'
      transactionId: req.body.transactionId,  // Save transaction ID if available
      appointmentId,
    });

    await payment.save();

    // Update the appointment status to "paid" if the payment is successful
    const appointment = await Appointment.findById(appointmentId);
    if (appointment) {
      appointment.paymentStatus = status === 'success';  // Mark payment status as true for success
      await appointment.save();
    }

    res.status(201).json({ message: 'Payment recorded', payment });
  } catch (err) {
    res.status(500).json({ message: 'Payment failed', error: err.message });
  }
};

// @desc Get all payments made by a specific user
// @route GET /api/payments/user/:userId
const getUserPayments = async (req, res) => {
  try {
    const { userId } = req.params;
    const payments = await Payment.find({ userId }).sort({ createdAt: -1 });
    res.status(200).json(payments);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch payments', error: err.message });
  }
};

// @desc Get all payments received by a doctor
// @route GET /api/payments/doctor/:doctorId
const getDoctorPayments = async (req, res) => {
  try {
    const { doctorId } = req.params;

    // Query payments based on the doctor ID, assuming payment is linked via appointmentId
    const payments = await Payment.find({ 'appointmentId.doctorId': doctorId }).sort({ createdAt: -1 });

    if (payments.length === 0) {
      return res.status(404).json({ message: 'No payments found for this doctor' });
    }

    res.status(200).json(payments);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch doctor payments', error: err.message });
  }
};

module.exports = {
  createPaymentRecord,
  getUserPayments,
  getDoctorPayments,
};
