const router = express().Router();
const productControllers = require('../controllers/products');

router.get('/products/count', productControllers.getProductsCount);
router.get('/products/:id', productControllers.getProductDetail);
router.delete('/products/:id');
router.put('/products/:id');

module.exports = router;