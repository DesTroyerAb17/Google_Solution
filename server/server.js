const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

// 🔧 Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); // ✅ Add this


// 🔌 MongoDB Connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('✅ MongoDB Connected');
}).catch(err => console.error('❌ MongoDB Connection Error:', err));

// 🚏 Route Imports
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const postRoutes = require('./routes/postRoutes');
const availabilityRoutes = require('./routes/availabilityRoutes');
const appointmentRoutes = require('./routes/appointmentRoutes');
// const blogRoutes = require('./routes/blogRoutes'); // ❌ Removed

// 🛣️ Route Middleware
app.use('/api/auth', authRoutes); // ✅ /send-otp, /verify-otp
app.use('/api/users', userRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/posts', postRoutes);
app.use('/api/availability', availabilityRoutes);
app.use('/api/appointments', appointmentRoutes);
// app.use('/api/blogs', blogRoutes); // ❌ Removed
app._router.stack.forEach((middleware) => {
  if (middleware.route) {
    console.log('✅ ROUTE:', middleware.route.path);
  }
});
// Debug: Print all registered routes
app._router.stack.forEach((middleware) => {
  if (middleware.route) {
    console.log(`${Object.keys(middleware.route.methods)[0].toUpperCase()} ${middleware.route.path}`);
  } else if (middleware.name === 'router') {
    middleware.handle.stack.forEach((handler) => {
      const route = handler.route;
      const method = route && Object.keys(route.methods)[0].toUpperCase();
      const path = route && route.path;
      if (method && path) {
        console.log(`✅ ${method} ${middleware.regexp} → ${path}`);
      }
    });
  }
});

// 🕒 Start background cron jobs
require('./cronJob');
// 📂 Serve uploaded prescriptions statically
app.use('/uploads', express.static('uploads'));

// 🚀 Start Server
app.listen(port, () => {
  console.log(`🚀 Server running on port ${port}`);
});
