const Post = require('../models/postModel');
const User = require('../models/userModel'); // ✅ Import to validate author

// ✅ Create a new post
const createPost = async (req, res) => {
  try {
    const { content, caption, richContent,richCaption } = req.body;
    const imageUrl = req.file ? `/uploads/posts/${req.file.filename}` : null;
    const userId = req.user.id;

    // 🔍 Check if user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(400).json({ message: 'User not found. Cannot create post.' });
    }

    const newPost = new Post({
      author: userId,
      content,
      caption,
      imageUrl,
      richCaption: richCaption ? JSON.parse(richCaption) : undefined, // 👈 parse string to JSON
      richContent: richContent ? JSON.parse(richContent) : undefined // 👈 parse string to JSON
    });

    await newPost.save();
    console.log('REQ BODY:', req.body);

    res.status(201).json({ message: 'Post created successfully', post: newPost });
  } catch (error) {
    res.status(500).json({ message: 'Error creating post', error: error.message });
  }
};

// ✅ Get all posts (with author and comments populated)
const getAllPosts = async (req, res) => {
  try {
    const posts = await Post.find()
      .populate('author', 'name phoneNumber')
      .populate('comments.user', 'name phoneNumber')
      .sort({ createdAt: -1 });

    res.status(200).json(posts);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching posts', error: error.message });
  }
};

// ✅ Add a comment to a post
const addComment = async (req, res) => {
  try {
    const { postId } = req.params;
    const { text } = req.body;
    const userId = req.user.id;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ message: 'Post not found' });
    }

    // Optionally validate user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(400).json({ message: 'User not found. Cannot comment.' });
    }

    const comment = {
      user: userId,
      text,
      createdAt: new Date(),
    };

    post.comments.push(comment);
    await post.save();

    res.status(200).json({ message: 'Comment added', post });
  } catch (error) {
    res.status(500).json({ message: 'Error adding comment', error: error.message });
  }
};

module.exports = {
  createPost,
  getAllPosts,
  addComment,
};