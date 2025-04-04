const FamilyMember = require('../models/familyMemberModel');

// ➕ Add Family Member
const addFamilyMember = async (req, res) => {
  const { name, gender, dateOfBirth, height, weight, bloodGroup } = req.body;
  const userId = req.user.id;

  try {
    const member = new FamilyMember({
      userId,
      name,
      gender,
      dateOfBirth,
      height,
      weight,
      bloodGroup,
    });

    await member.save();
    res.status(201).json({ message: 'Family member added', member });
  } catch (error) {
    res.status(500).json({ message: 'Failed to add family member', error: error.message });
  }
};

// ❌ Delete Family Member
const deleteFamilyMember = async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const deleted = await FamilyMember.findOneAndDelete({ _id: id, userId });

    if (!deleted) {
      return res.status(404).json({ message: 'Family member not found' });
    }

    res.status(200).json({ message: 'Family member deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to delete family member', error: error.message });
  }
};


// 📥 Get All Family Members for a User
const getAllFamilyMembers = async (req, res) => {
  const userId = req.user.id;

  try {
    const members = await FamilyMember.find({ userId });

    if (members.length === 0) {
      return res.status(200).json({
        message: 'No family members found',
        members: []
      });
    }

    res.status(200).json(members);
  } catch (error) {
    res.status(500).json({ message: 'Failed to retrieve family members', error: error.message });
  }
};

// 📥 Get a Single Family Member by ID for a User
const getFamilyMemberById = async (req, res) => {
  const { id } = req.params;  // Get the ID from the request parameters
  const userId = req.user.id; // Get the user ID from the authenticated user

  try {
    // Find the family member by ID and ensure that it belongs to the current user
    const member = await FamilyMember.findOne({ _id: id, userId });

    if (!member) {
      return res.status(404).json({ message: 'Family member not found' });
    }

    // Respond with the family member data
    res.status(200).json({ member });
  } catch (error) {
    res.status(500).json({ message: 'Failed to retrieve family member', error: error.message });
  }
};


module.exports = {
  addFamilyMember,
  deleteFamilyMember,
  getAllFamilyMembers,
  getFamilyMemberById
};
