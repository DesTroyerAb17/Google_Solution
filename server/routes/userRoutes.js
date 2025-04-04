const express = require('express');
const router = express.Router();

const authController = require('../controllers/authController'); // we use this for user profile functions
const userController = require('../controllers/userController');
const { authenticateUser } = require('../middleware/authMiddleware');

// 👤 User Profile (self)
router.get('/me', authenticateUser, authController.getUserProfile);
router.patch('/me', authenticateUser, authController.updateUserProfile);
router.delete('/me', authenticateUser, authController.deleteUser);

// 🔐 Family Member Routes
router.post('/add-family-member', authenticateUser, userController.addFamilyMember);
router.delete('/delete-family-member/:id', authenticateUser, userController.deleteFamilyMember);
router.get('/family-members', authenticateUser, userController.getAllFamilyMembers);
router.get('/family-member/:id', authenticateUser,userController.getFamilyMemberById); // New route

module.exports = router;
