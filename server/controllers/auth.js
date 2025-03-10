const { validationResult } = require('express-validator');
const { User } = require('../models/user');
const { Token } = require('../models/token');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mailSender = require('../helpers/email_sender');

exports.register = async function (req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map((error) => ({
      field: error.path,
      message: error.msg,
    }));
    return res.status(400).json({ errors: errorMessages });
  }
  try {
    let user = new User({
      ...req.body,
      passwordHash: bcrypt.hashSync(req.body.password, 8),
    });

    user = await user.save();

    if (!user) {
      return res.status(500).json({ 
        type: "Lỗi hệ thống", 
        message: "Không thể tạo người dùng mới" 
      });
    }

    return res.status(201).json(user);
  } catch (error) {
    if (error.message.includes('email_1 dup key')) {
      return res.status(409).json({ 
        type: "Lỗi đăng ký", 
        message: "Email này đã được sử dụng" 
      });
    }
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.login = async function (req, res) {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email: email });
    if (!user) {
      return res.status(404).json({ 
        message: 'Không tìm thấy người dùng! Vui lòng kiểm tra lại email.' 
      });
    }

    if (!bcrypt.compareSync(password, user.passwordHash)) {
      return res.status(400).json({ message: "Mật khẩu không đúng!" });
    }

    const accessToken = jwt.sign(
      { id: user.id, isAdmin: user.isAdmin },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: '24h' }
    );

    const refreshToken = jwt.sign(
      { id: user.id, isAdmin: user.isAdmin },
      process.env.REFRESH_TOKEN_SECRET,
      { expiresIn: '60d' }
    );

    const token = await Token.findOne({ userId: user.id });
    if (token) {
      await token.deleteOne();
    }
    await new Token({ userId: user.id, accessToken, refreshToken }).save();

    user.passwordHash = undefined;
    return res.json({ ...user._doc, accessToken });
  } catch (error) {
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.verifyToken = async function (req, res) {
  try {
    let accessToken = req.headers.authorization;
    if (!accessToken) {
      return res.json(false);
    }

    accessToken = accessToken.replace('Bearer ', '').trim();

    const token = await Token.findOne({ accessToken });
    if (!token) {
      return res.json(false);
    }

    const tokenData = jwt.decode(token.refreshToken);
    const user = await User.findById(tokenData.id);
    if (!user) {
      return res.json(false);
    }

    jwt.verify(token.refreshToken, process.env.REFRESH_TOKEN_SECRET);
    return res.json(true);
  } catch (error) {
    return res.json(false);
  }
};

exports.forgotPassword = async function (req, res) {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng với email này!' });
    }

    // Tạo mã OTP gồm 4 chữ số
    const otp = Math.floor(1000 + Math.random() * 9000);

    user.resetPasswordOTP = otp;
    user.resetPasswordOTPExpires = Date.now() + 600000; // 10 phút

    await user.save();

    const response = await mailSender.sendMail(
      email,
      'Mã OTP đặt lại mật khẩu',
      `Mã OTP đặt lại mật khẩu của bạn là: ${otp}`
    );
    return res.json({ message: response.message });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.verifyPasswordResetOTP = async function (req, res) {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng!' });
    }

    if (user.resetPasswordOTP !== +otp || Date.now() > user.resetPasswordOTPExpires) {
      return res.status(401).json({ message: 'OTP không hợp lệ hoặc đã hết hạn' });
    }

    user.resetPasswordOTP = 1;
    user.resetPasswordOTPExpires = undefined;
    await user.save();
    return res.status(200).json({ message: 'Xác thực OTP thành công. Bạn có thể đặt lại mật khẩu.' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.resetPassword = async function (req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map((error) => ({
      field: error.path,
      message: error.msg,
    }));
    return res.status(400).json({ errors: errorMessages });
  }
  try {
    const { email, newPassword } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng!' });
    }

    if (user.resetPasswordOTP !== 1) {
      return res.status(401).json({ message: 'Vui lòng xác thực OTP trước khi đặt lại mật khẩu.' });
    }

    user.passwordHash = bcrypt.hashSync(newPassword, 8);
    user.resetPasswordOTP = undefined;

    await user.save();

    return res.json({ message: 'Đặt lại mật khẩu thành công' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
