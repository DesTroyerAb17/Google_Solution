const jwt = require('jsonwebtoken');

// Middleware to authenticate and decode the token
const authenticateUser = (req, res, next) => {
  const authHeader = req.headers.authorization;

  // Check for missing or malformed authorization header
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Authorization token missing or malformed' });
  }

  const token = authHeader.split(' ')[1];

  try {
    // Verify token using secret
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Attach decoded user info to the request
    req.user = {
      id: decoded.id,
      role: decoded.role // 🔑 Include role: 'user' or 'doctor'
    };

    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};

module.exports = {
  authenticateUser,
  protect: authenticateUser // Optional alias
};
