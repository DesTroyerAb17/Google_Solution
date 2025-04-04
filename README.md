# AyuSetu - Healthcare Platform

AyuSetu is an innovative healthcare platform designed to enhance access to medical services for underserved populations. Leveraging AI, telemedicine, and an intuitive health blog, AyuSetu provides a comprehensive suite of services that facilitate health education, diagnosis, and consultation with healthcare professionals.

## ✅ Features Breakdown

### Bypass OTP (Development Mode)
- **For Users**: Use "9999999902" or "9999999901" with OTP "123456" for quick access during testing.
- **For Doctors**: Use "9999999903" with OTP "123456" for expedited registration and testing.

### AI Diagnosis
- Currently supports diagnosis for oral health and pneumonia.
- Uses early-stage AI models, with ongoing developments to expand capabilities and accuracy.

### Health Blog
- Provides immediate access to articles on basic medical care, including first aid for burns and cuts.
- Searchable content designed to deliver quick and reliable medical advice.

### Ayu Chatbot
- Offers general health information and navigational assistance within the app.
- Engages users in interactive dialogues to address basic health inquiries.

### Doctor Consultations
- Seamless transition from AI diagnosis to booking consultations with available doctors.
- Aims to simplify the process of connecting patients with healthcare providers.

### Community Feed
- A collaborative platform where users and doctors can share medical experiences and insights.
- Enhances community engagement and spreads valuable health education.

---

## 🚀 Tech Stack

- **Frontend**: Flutter
- **Backend**: Node.js + Express
- **Database**: MongoDB + Mongoose
- **Authentication**: JWT
- **OTP Service**: Twilio
- **File Uploads**: Multer
- **Task Scheduling**: Cron
- **Payment**: Razorpay/Stripe

--

### Development Status

The project is under active development. Features like AI diagnosis and the appointment booking system are operational but still being refined for broader medical coverage and smoother user interaction.


# AyuSetu Backend

This is the complete backend codebase for the **AyuSetu** healthcare application.
Built with **Node.js**, **Express**, and **MongoDB**, this API powers features like:
- User and Doctor registration/login (via OTP)
- Appointment booking and scheduling
- Prescription uploads
- Payment processing
- Doctor earnings tracking
- Family member management
- Social post sharing & discussions
---

## 📁 Folder Structure
```
├── controllers        # Business logic
├── models             # Mongoose schemas
├── routes             # API route definitions
├── middleware         # Auth middlewares
├── utils              # Upload config (Multer)
├── uploads            # Prescription & post files
├── .env               # Environment variables
├── server.js          # Entry point
├── cronJob.js         # Scheduled job for auto-completing appointments
```

---

## ✅ Features Breakdown

### 🔐 Authentication
- OTP-based login (User & Doctor)
- JWT-based session management
- Role-based access (`user` or `doctor`)

### 👤 User Management
- Register/login with phone number
- Update/delete profile
- Add/delete/view family members

### 🧑‍⚕️ Doctor Management
- Detailed registration with medical credentials
- Profile update/view/delete

### 📅 Appointments
- Book slots with doctors for self or family members
- Auto-generate video link (via Jitsi)
- Prescription upload/download
- Auto-mark as completed (via cron job)

### ⏰ Availability
- Doctors can set available time slots per day
- Users see available slots when booking

### 💳 Payments & Earnings
- Record payments (Razorpay/Stripe etc.)
- Link payments to appointments
- Track doctor's earnings and payouts

### 📢 Social Posts
- Users can share medical experiences
- Support image + caption + comments

---

## ⚙️ Running the App

### 1. Install dependencies
```bash
npm install
```

### 2. Configure `.env`
Create a `.env` file with:
```
PORT=5000
MONGODB_URI=your_mongodb_connection
JWT_SECRET=your_jwt_secret
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
TWILIO_PHONE_NUMBER=+91XXXXXXX
```

### 3. Start server
```bash
node server.js
```

Server runs at `http://localhost:5000` and automatically starts the cron job.

---

## 🗃️ API Endpoints with Examples

### 🔐 `/api/auth`
#### `POST /send-otp`
**Request:** `{ "phoneNumber": "+919999999901" }`
**Response:** `{ "message": "OTP sent successfully" }`

#### `POST /verify-otp`
**Request:** `{ "phoneNumber": "+919999999901", "otp": "123456", "name": "John Doe" }`
**Response:** `{ "token": "jwt_token", "role": "user", "profile": { ... } }`

#### `GET /check-phone?phoneNumber=9999999901`
**Response:** `{ "exists": true, "role": "user" }`

#### `GET /me`
**Returns the user’s profile.**

---

### 👤 `/api/users`
#### `POST /add-family-member`
**Request:**
```json
{
  "name": "Jane Doe",
  "gender": "Female",
  "dateOfBirth": "2000-01-01",
  "height": 160,
  "weight": 55,
  "bloodGroup": "A+"
}
```

#### `GET /family-members`
Returns a list of added family members.

#### `DELETE /delete-family-member/:id`
Deletes a family member.

---

### 🧑‍⚕️ `/api/doctors`
#### `POST /register`
Registers a new doctor with credentials.
```json
{
  "name": "Dr. Smith",
  "email": "smith@example.com",
  "phoneNumber": "+919999999903",
  "registrationNumber": "REG123",
  "aadhar": "123456789012",
  "pan": "ABCDE1234F",
  "stateMedicalCouncil": "Delhi"
}
```

#### `GET /me` — Get own profile  
#### `PATCH /me` — Update profile  
#### `DELETE /me` — Delete doctor account

---

### 📅 `/api/appointments`
#### `POST /`
**Book Appointment**
```json
{
  "doctorId": "doctorObjectId",
  "date": "2024-04-10",
  "timeSlot": "10:00 AM",
  "familyMemberId": "optionalFamilyMemberId"
}
```
**Response:** `{ "message": "Appointment booked", "appointment": { ... } }`

#### `GET /my`
Returns appointments booked by user or assigned to doctor.

#### `PATCH /:id/status`
Update appointment status (`scheduled`, `completed`, `cancelled`)

#### `PATCH /:id/prescription`
Upload a prescription PDF/image file.

#### `GET /:id/prescription` or `/download`
Fetch or download prescription file.

---

### ⏰ `/api/availability`
#### `POST /`
**Doctor sets availability**
```json
{
  "doctorId": "doctorObjectId",
  "date": "2024-04-10",
  "timeSlots": ["10:00 AM", "11:00 AM"]
}
```

#### `GET /:doctorId`
Returns availability for a doctor.

---

### 💳 `/api/payments`
#### `POST /`
Record a payment
```json
{
  "userId": "userObjectId",
  "appointmentId": "appointmentObjectId",
  "amount": 399,
  "paymentMethod": "Razorpay",
  "status": "success",
  "transactionId": "txn_001"
}
```

#### `GET /user`
Get all payments made by the logged-in user.

#### `GET /doctor`
Get all payments made to a doctor.

---

### 💰 `/api/earnings`
#### `GET /me`
Get earnings for logged-in doctor.

---

### 📢 `/api/posts`
#### `POST /`
Create post with optional image
```json
{
  "content": "My experience with AyuSetu was great!",
  "caption": "Great service!"
}
```

#### `GET /`
Fetch all posts with comments and authors.

#### `POST /:postId/comments`
Add comment to post:
```json
{
  "text": "Thanks for sharing!"
}
```

---

## 🧪 Notes
- Auto-completion of appointments happens every 10 minutes via `cronJob.js`
- Uploaded files are stored under `/uploads/prescriptions/` and `/uploads/posts/`
- Access them at: `http://localhost:5000/uploads/...`

---

## 🛡️ Security
- JWT-secured routes
- OTP protected login and deletion
- File validation on upload (type + size)

---

## 📦 Future Improvements
- Admin dashboard
- Payout settlement for doctors
- SMS/email alerts
- Firebase push notifications

---

Made with ❤️ for AyuSetu
