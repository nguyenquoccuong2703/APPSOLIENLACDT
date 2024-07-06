const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');

const app = express();
const port = 3001;

app.use(bodyParser.json());

let storedOTP = null;

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'nguyenquoccuong2703@gmail.com',
    pass: '046202006162Fate',
  },
});

app.post('/send-otp', (req, res) => {
  const { email, otp } = req.body;

  storedOTP = otp; // Lưu OTP tạm thời để so khớp

  const mailOptions = {
    from: 'nguyenquoccuong2703@gmail.com',
    to: email,
    subject: 'Your OTP Code',
    text: `Your OTP code is: ${otp}`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error('Error sending email:', error);
      res.status(500).send({ success: false, message: 'Failed to send OTP.' });
    } else {
      console.log('Email sent:', info.response);
      res.status(200).send({ success: true, message: 'OTP sent successfully.' });
    }
  });
});

app.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  if (otp === storedOTP) {
    console.log('OTP verified successfully');
    res.status(200).send({ success: true, message: 'OTP verified successfully.' });
  } else {
    console.log('Failed to verify OTP');
    res.status(400).send({ success: false, message: 'Failed to verify OTP.' });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
