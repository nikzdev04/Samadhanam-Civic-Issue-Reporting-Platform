
const express = require('express');
const dotenv = require('dotenv');
const cron = require('node-cron');
const connectDB = require('./config/db');
const complaintRoutes = require('./routes/complaintRoutes');
const authRoutes = require('./routes/authRoutes');
const { checkAndEscalateComplaints } = require('./cron/escalationService');

dotenv.config();
connectDB();

const app = express();
app.use(express.json());

// API Routes
app.use('/api/complaints', complaintRoutes);
app.use('/api/auth', authRoutes);

// Schedule the Cron Job to run at the start of every hour
cron.schedule('0 * * * *', () => {
  checkAndEscalateComplaints();
});

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
