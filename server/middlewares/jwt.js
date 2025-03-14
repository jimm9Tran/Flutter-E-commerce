const { expressjwt: expjwt } = require('express-jwt');
const { Token } = require('../models/token');

function authJwt() {
  const API = process.env.API_URL;
  return expjwt({
    secret: process.env.ACCESS_TOKEN_SECRET,
    algorithms: ['HS256'],
    isRevoked,
  }).unless({
    path: [
      `${API}/login`,
      `${API}/login/`,
      `${API}/register`,
      `${API}/register/`,
      `${API}/forgot-password`,
      `${API}/forgot-password/`,
      `${API}/verify-otp`,
      `${API}/verify-otp/`,
      `${API}/reset-password`,
      `${API}/reset-password/`,
    ]
  });
}

async function isRevoked(req, token) {
  const authHeader = req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return true;
  }
  
  const accessToken = authHeader.replace('Bearer ', '').trim();
  let tokenDoc;
  try {
    tokenDoc = await Token.findOne({ accessToken });
  } catch (err) {
    console.error('Error fetching token from DB:', err);
    return true;
  }
  
  const adminRouteRegex = /^\/api\/v1\/admin\//i;
  const adminFault = !token?.payload?.isAdmin && adminRouteRegex.test(req.originalUrl);

  return adminFault || !tokenDoc;
}

module.exports = authJwt;