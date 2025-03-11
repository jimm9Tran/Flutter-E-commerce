const express = require('express');
const router = express.Router();

const adminController = require('../controllers/admin');
const { route } = require('./users');

router.get('/user/count', adminController.getUserCount);
router.delete('/users/:id', adminController.deleteUser);

router.post('/categories', adminController.addCategory);
router.put('/categories/:id', adminController.editCategory);
router.delete('/categories/:id', adminController.deleteCategory);

router.get('/products/count', adminController.addCategory);
router.post('/products', adminController.addProduct);
router.put('/products/:id', adminController.editProduct);
router.delete('/products/:id/images', adminController.deleteProductImages);
router.delete('/products/:id', adminController.deleteProduct);

router.get('/orders', adminController.getOrders);
router.get('/oders/count', adminController.getOrdersCount);
router.put('/orders/:id', adminController.changeOrderStatus);

module.exports = router;