const { validationResult } = require('express-validator');
const { User } = require('../models/user');
const bcrypt = require('bcrypt');

exports.register = async function (req, res) {
    const erros = validationResult(req);
    if (!erros.isEmpty()){
        // console.log(erros);
        const errorMessages = erros.array().map((error) => ({
            field: error.path,
            message: error.msg,
        }));
        return res.status(400).json({ erros: errorMessages });
    }
    try {
        let user = new User({
            ...req.body,
            passwordHash: bcrypt.hashSync(req.body.password, 8),
        });

        user = await user.save();
        
        if (!user){
            return res.status(500).json({type: "Internal Server Error", message: "Could not create a new user"});
        }

        return res.status(201).json(user);
    } catch (error) {
        if (error.message.includes('email_1 dup key')){
            return res.status(409).json({type: "AuthError", message: "User with that email already exist"});
        }
        return res.status(500).json({type: error.name, message: error.message});
    }
};

exports.login = async function (req, res) {
    
};

exports.forgotPassword = async function (req, res) {
    
};

exports.verifyPasswordResetOTP = async function (req, res) {
    
};

exports.resetPassword= async function (req, res) {
    
};