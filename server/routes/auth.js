const express = require("express");
const router = express.Router();

const authController = require('../controllers/auth');
const { body } = require('express-validator');

const validateUser = [
    body('name')
        .not().isEmpty().withMessage('Vui lòng nhập tên'),
    body('email')
        .notEmpty().withMessage("Vui lòng nhập địa chỉ email")
        .isEmail().withMessage("Vui lòng nhập địa chỉ email hợp lệ"),
    body('password')
        .isLength({ min: 8 }).withMessage("Mật khẩu tối thiểu 8 ký tự")
        .isStrongPassword({
            minLowercase: 1,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1,
        }).withMessage("Mật khẩu cần chứa ít nhất 1 ký tự in hoa, 1 ký tự đặc biệt và 1 chữ số"),
    body('phone')
        .isMobilePhone().withMessage("Vui lòng nhập số điện thoại"),
];

const validatePassword = [
    body('newPassword')
        .isLength({ min: 8 }).withMessage("Mật khẩu tối thiểu 8 ký tự")
        .isStrongPassword({
            minLowercase: 1,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1,
        }).withMessage("Mật khẩu cần chứa ít nhất 1 ký tự in hoa, 1 ký tự đặc biệt và 1 chữ số"),
];

router.post('/login', authController.login);
router.post('/register', validateUser, authController.register);
router.get('/verify-token', authController.verifyToken);
router.post('/forgot-password', authController.forgotPassword);
router.post('/verify-otp', authController.verifyPasswordResetOTP);
router.post('/reset-password', validatePassword, authController.resetPassword);

module.exports = router;