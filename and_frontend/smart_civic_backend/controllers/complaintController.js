
const Complaint = require('../models/complaintModel');

const getComplaints = async (req, res) => {
  const complaints = await Complaint.find({}).sort({ createdAt: -1 });
  res.status(200).json(complaints);
};

const createComplaint = async (req, res) => {
  const { title, description, location, latitude, longitude, imageUrl, status } = req.body;

  if (!title || !description || !location) {
    return res.status(400).json({ message: 'Please provide all required fields' });
  }

  const raisedDate = new Date();
  const targetDate = new Date();
  targetDate.setDate(raisedDate.getDate() + 7);

  const complaint = await Complaint.create({
    title,
    description,
    location,
    latitude,
    longitude,
    imageUrl,
    status: status || 'Pending',
    raisedDate,
    targetDate,
    timeline: [{ status: 'Submitted', description: 'Complaint submitted by user.', date: raisedDate }]
  });

  res.status(201).json(complaint);
};

module.exports = {
  getComplaints,
  createComplaint,
};
