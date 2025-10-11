
const { OAuth2Client } = require('google-auth-library');
const User = require('../models/userModel');
const jwt = require('jsonwebtoken');

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const client = new OAuth2Client(GOOGLE_CLIENT_ID);

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
};

const authWithGoogle = async (req, res) => {
  const { credential } = req.body;

  if (!credential) {
    return res.status(400).json({ message: 'Missing Google ID token.' });
  }

  try {
    const ticket = await client.verifyIdToken({
      idToken: credential,
      audience: GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { sub: googleId, name, email, picture } = payload;

    let user = await User.findOne({ email: email });

    if (!user) {
      user = await User.create({
        googleId,
        name,
        email,
        profilePictureUrl: picture,
      });
    }

    if (user) {
      const token = generateToken(user._id);
      res.status(200).json({
        message: 'Authentication successful!',
        token: token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          role: user.role,
        },
      });
    } else {
      res.status(500).json({ message: 'Could not log in user.' });
    }
  } catch (error) {
    console.error('Google Auth Error:', error);
    res.status(401).json({ message: 'Invalid Google token. Authentication failed.' });
  }
};

module.exports = { authWithGoogle };
