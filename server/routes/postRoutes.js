const express = require('express');
const router = express.Router();
const {
  createPost,
  getAllPosts,
  addComment,
} = require('../controllers/postController');
const { authenticateUser } = require('../middleware/authMiddleware');
const { uploadPostImage } = require('../utils/upload');

// ✅ Create a new post (with content, caption, optional image)
router.post('/', authenticateUser, uploadPostImage.single('image'), createPost);

// ✅ Get all posts (with image, caption, content, author)
router.get('/', getAllPosts);

// ✅ Add a comment to a specific post
router.post('/:postId/comments', authenticateUser, addComment);

module.exports = router;
