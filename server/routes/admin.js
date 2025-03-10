const express = require('express');
const router = express.Router();

const adminController = require('../controllers/admin');
const { route } = require('./users');

router.get('/user/count', adminController.getUserCount);
router.delete('/users/:id', adminController.deleteUser);

router.post('/categories', adminController.addCategory);
router.put('/categories/:id', adminController.editCategory);
router.delete('/categories/:id', adminController.deleteCategory);

router.get('/orders', adminController.getOders);
router.get('/oders/count', adminController.getOdersCount);
router.put('/orders/:id', adminController.changeOrderStatus);

module.exports = router;