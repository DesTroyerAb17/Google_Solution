const cron = require('node-cron');
const Appointment = require('./models/appointmentModel');

// Runs every 10 minutes
cron.schedule('*/10 * * * *', async () => {
  try {
    console.log('⏰ Running scheduled appointment check...');
    const now = new Date();

    const appointments = await Appointment.find({ status: 'scheduled' });

    for (const appt of appointments) {
      const appointmentDateTime = new Date(`${appt.date} ${appt.timeSlot}`);
      const timeDiff = (now - appointmentDateTime) / (1000 * 60); // in minutes

      if (timeDiff > 10) {
        appt.status = 'completed';
        await appt.save();
        console.log(`✅ Appointment ${appt._id} marked as completed.`);
      }
    }
  } catch (err) {
    console.error('❌ Error in cron job:', err.message);
  }
});
