
const mongoose = require('mongoose');

const timelineEventSchema = new mongoose.Schema({
  status: { type: String, required: true },
  description: { type: String, required: true },
  date: { type: Date, default: Date.now },
});

const complaintSchema = new mongoose.Schema({
  title: { type: String, required: [true, 'Please add a title'] },
  description: { type: String, required: [true, 'Please add a description'] },
  location: { type: String, required: true },
  latitude: { type: Number },
  longitude: { type: Number },
  imageUrl: { type: String },
  status: {
    type: String,
    enum: ['Pending', 'InProgress', 'Resolved', 'Rejected', 'Escalated'],
    default: 'Pending',
  },
  raisedDate: {
    type: Date,
    default: Date.now,
  },
  targetDate: {
    type: Date,
    required: true,
  },
  timeline: [timelineEventSchema],
}, {
  timestamps: true,
});

module.exports = mongoose.model('Complaint', complaintSchema);
