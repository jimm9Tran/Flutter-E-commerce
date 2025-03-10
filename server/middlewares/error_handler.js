const jwt = require('jsonwebtoken');
const { Token } = require('../models/token');
const { User } = require('../models/user');

async function errorHandler(error, req, res, next) {
  if (error.name === 'UnauthorizedError') {
    if (!error.message.includes('jwt expired')) {
      const statusCode = error.status || 401;
      return res.status(statusCode).json({ message: error.message });
    }
  } else {
    return next(error);
  }

  try {
    const tokenHeader = req.header('Authorization');
    const accessToken = tokenHeader?.split(' ')[1]; 

    const token = await Token.findOne({ 
      accessToken, 
      refreshToken: { $exists: true } 
    });
    if (!token) {
      return res.status(401).json({ 
        type: 'Unauthorized', 
        message: 'Token không tồn tại trong hệ thống' 
      });
    }

    const userData = jwt.verify(token.refreshToken, process.env.REFRESH_TOKEN_SECRET);

    const user = await User.findById(userData.id);
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không hợp lệ!' });
    }

    const newAccessToken = jwt.sign(
      { id: user.id, isAdmin: user.isAdmin },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: '24h' }
    );

    req.headers['authorization'] = `Bearer ${newAccessToken}`;

    await Token.updateOne(
      { _id: token.id },
      { accessToken: newAccessToken }
    );

    res.set('Authorization', `Bearer ${newAccessToken}`);

    return next();
  } catch (refreshError) {
    return res.status(401).json({ 
      type: 'Unauthorized', 
      message: refreshError.message 
    });
  }
  
  return res.status(error.status).json({type: error.name, message: error.message});
}

module.exports = errorHandler;