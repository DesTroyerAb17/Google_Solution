// authController.js

const User = require('../models/userModel');
const Doctor = require('../models/doctorModel');
const jwt = require('jsonwebtoken');
const twilio = require('twilio');

// Twilio configuration
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = new twilio(accountSid, authToken);

// In-memory OTP storage
const otpMap = new Map();

// Test numbers (bypass SMS for demo)
const testNumbers = {
  '+919999999901': '123456', // Test User
  '+919999999902': '123456', // Test User
  '+919999999903': '123456', // Test Doctor
};

// ✅ Send OTP
const sendOTP = async (req, res) => {
  const { phoneNumber } = req.body;

  // Test number bypass
  if (testNumbers[phoneNumber]) {
    console.log(`Bypass OTP for ${phoneNumber}: ${testNumbers[phoneNumber]}`);
    return res.status(200).json({ message: 'OTP sent (bypass)' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  otpMap.set(phoneNumber, otp);
  console.log(`OTP for ${phoneNumber} is ${otp}`);

  try {
    await client.messages.create({
      body: `Your OTP code is: ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber,
    });

    res.status(200).json({ message: 'OTP sent successfully' });
  } catch (err) {
    console.error("Error sending OTP:", err);
    res.status(500).json({ message: 'Error sending OTP', error: err.message });
  }
};

// ✅ Check if phone number exists (for login screen)
const checkPhoneNumberExists = async (req, res) => {
  try {
    let { phoneNumber } = req.query;

    if (!phoneNumber) {
      return res.status(400).json({ message: 'Phone number is required' });
    }
    phoneNumber=phoneNumber.trim();
    phoneNumber='+'+phoneNumber,
    // Debug: log the incoming phone number
    console.log('Phone Number to check:', phoneNumber);

    // Query both users and doctors collections to check if the phone number exists with the '+'
    const user = await User.findOne({ phoneNumber });
    const doctor = await Doctor.findOne({ phoneNumber });

    // Debug: log the results of the query
    console.log('User found:', user);
    console.log('Doctor found:', doctor);

    if (user || doctor) {
      // If either user or doctor is found, return the respective role
      return res.status(200).json({
        exists: true,
        role: user ? 'user' : 'doctor',
        message: `${user ? 'User' : 'Doctor'} found`,
      });
    } else {
      // If neither user nor doctor is found, return that the phone number doesn't exist
      return res.status(200).json({ exists: false, message: 'Phone number not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error checking phone number', error: error.message });
  }
};





// ✅ Verify OTP (for both user & doctor, with phone uniqueness check)
const verifyOTP = async (req, res) => {
  const { phoneNumber, otp, name } = req.body;

  // ✅ Enforce OTP check for test numbers (must be '123456')
  if (testNumbers[phoneNumber]) {
    if (otp !== '123456') {
      return res.status(401).json({ message: 'Invalid OTP' });
    }

    let doctor = await Doctor.findOne({ phoneNumber });
    let user = await User.findOne({ phoneNumber });

    if (!user && !doctor) {
      const doctorConflict = await Doctor.findOne({ phoneNumber });
      if (doctorConflict) {
        return res.status(400).json({ message: 'Phone number already registered as a doctor' });
      }

      // ✅ Create new user with name
      user = new User({ phoneNumber, name });
      await user.save();
    }

    const id = doctor ? doctor._id : user._id;
    const role = doctor ? 'doctor' : 'user';
    const token = jwt.sign({ id, role }, process.env.JWT_SECRET, { expiresIn: '7d' });

    return res.status(200).json({ token, role, profile: doctor || user });
  }

  // ❌ OTP verification for non-test numbers
  if (otpMap.get(phoneNumber) !== otp) {
    return res.status(401).json({ message: 'Invalid OTP' });
  }

  let doctor = await Doctor.findOne({ phoneNumber });
  let user = await User.findOne({ phoneNumber });

  if (!user && !doctor) {
    const doctorConflict = await Doctor.findOne({ phoneNumber });
    if (doctorConflict) {
      return res.status(400).json({ message: 'Phone number already registered as a doctor' });
    }

    user = new User({ phoneNumber, name });
    await user.save();
  }

  otpMap.delete(phoneNumber);

  const id = doctor ? doctor._id : user._id;
  const role = doctor ? 'doctor' : 'user';
  const token = jwt.sign({ id, role }, process.env.JWT_SECRET, { expiresIn: '7d' });

  res.status(200).json({ token, role, profile: doctor || user });
};


// ✅ Get user profile (self)
const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// ✅ Edit user profile
const updateUserProfile = async (req, res) => {
  try {
    const updates = req.body;
    const user = await User.findByIdAndUpdate(req.user.id, updates, { new: true });
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.status(200).json({ message: 'User updated', user });
  } catch (error) {
    res.status(500).json({ message: 'Update failed', error: error.message });
  }
};

// ✅ Delete user with OTP verification
const deleteUser = async (req, res) => {
  try {
    const { phoneNumber, otp } = req.body;

    const user = await User.findOne({ _id: req.user.id, phoneNumber });
    if (!user) return res.status(404).json({ message: 'User not found or mismatched' });

    const validOTP = testNumbers[phoneNumber];
    if (!validOTP || validOTP !== otp) {
      return res.status(401).json({ message: 'Invalid OTP for deletion' });
    }

    await User.findByIdAndDelete(user._id);
    res.status(200).json({ message: 'User account deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Deletion failed', error: error.message });
  }
};

// ✅ Logout (client should just delete token)
const logoutUser = async (req, res) => {
  res.status(200).json({ message: 'Logout successful (token removed on client side)' });
};

module.exports = {
  sendOTP,
  verifyOTP,
  getUserProfile,
  updateUserProfile,
  deleteUser,
  logoutUser,
  checkPhoneNumberExists,
};