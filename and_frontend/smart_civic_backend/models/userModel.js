
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  googleId: {
    type: String,
    required: true,
    unique: true,
  },
  profilePictureUrl: {
    type: String,
  },
  role: {
    type: String,
    enum: ['citizen', 'official', 'authority'],
    default: 'citizen',
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);
