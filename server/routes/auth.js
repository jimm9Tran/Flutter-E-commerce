const express = require("express");
const router = express.Router();

const authController = require('../controllers/auth');

const { body } = require('express-validator');

const validateUser = [
    body('name').not().isEmpty().withMessage('Vui lòng nhập tên'),
    body('email')
        .notEmpty().withMessage("Vui lòng nhập địa chỉ email")
        .isEmail().withMessage("Vui lòng nhập địa chỉ email hợp lệ"),
    body('password')
        .isLength({ min: 8 })
        .withMessage("Mật khẩu tối thiểu 8 ký tự")
        .isStrongPassword({
            minLowercase: 1,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1,
        })
        .withMessage("Mật khẩu cần chứa ít nhất ký tự in hoa và kí tự đặc biệt và số"),
    body('phone').isMobilePhone().withMessage("Vui lòng nhập số điện thoại"),
];

router.post('/login', authController.login);
router.post('/register', validateUser ,authController.register);
router.post('/forgot-password', authController.forgotPassword);
router.post('/verify-otp', authController.verifyPasswordResetOTP);
router.post('/reset-password', authController.resetPassword);

module.exports = router;