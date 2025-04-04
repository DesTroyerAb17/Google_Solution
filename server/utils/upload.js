const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure folders exist
const ensureUploadsFolder = (folderPath) => {
  if (!fs.existsSync(folderPath)) {
    fs.mkdirSync(folderPath, { recursive: true });
  }
};

// Prescription storage
const prescriptionStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const folder = 'uploads/prescriptions/';
    ensureUploadsFolder(folder);
    cb(null, folder);
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}_${file.originalname}`);
  }
});

// Post image storage
const postImageStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const folder = 'uploads/posts/';
    ensureUploadsFolder(folder);
    cb(null, folder);
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}_${file.originalname}`);
  }
});

const fileFilter = (req, file, cb) => {
  const ext = path.extname(file.originalname).toLowerCase();
  if (ext === '.pdf' || ext === '.png' || ext === '.jpg' || ext === '.jpeg') {
    cb(null, true);
  } else {
    cb(new Error('Only PDF or image files allowed!'), false);
  }
};

const uploadPrescription = multer({
  storage: prescriptionStorage,
  fileFilter,
  limits: { fileSize: 10 * 1024 * 1024 },
});

const uploadPostImage = multer({
  storage: postImageStorage,
  fileFilter,
  limits: { fileSize: 10 * 1024 * 1024 },
});

module.exports = {
  uploadPrescription,
  uploadPostImage
};
