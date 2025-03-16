const { User } = require('../models/user');
const { CartProduct } = require('../models/cart_product');
const { Product } = require('../models/product');
const { default: mongoose } = require('mongoose');

exports.getUserCart = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }
    const cartProducts = await CartProduct.find({ _id: { $in: user.cart } });
    if (!cartProducts || cartProducts.length === 0) {
      return res.json([]);
    }
    const cart = [];
    for (const cartProduct of cartProducts) {
      const cartProductData = cartProduct.toObject();
      const product = await Product.findById(cartProduct.product);
      if (!product) {
        cart.push({
          ...cartProductData,
          productExists: false,
          productOutOfStock: false
        });
      } else {
        cartProductData.productName = product.name;
        cartProductData.productImage = product.image;
        cartProductData.productPrice = product.price;
        cartProductData.productExists = true;
        cartProductData.productOutOfStock = product.countInStock < cartProduct.quantity;
        cart.push(cartProductData);
      }
    }
    return res.json(cart);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.getUserCartCount = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: 'Người dùng không tồn tại' });
    return res.json(user.cart.length);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.getCartProductById = async function (req, res) {
  try {
    const cartProduct = await CartProduct.findById(req.params.cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ message: 'Sản phẩm trong giỏ không tồn tại' });
    }
    const cartProductData = cartProduct.toObject();
    const product = await Product.findById(cartProduct.product);
    if (!product) {
      cartProductData.productExists = false;
      cartProductData.productOutOfStock = false;
    } else {
      cartProductData.productName = product.name;
      cartProductData.productImage = product.image;
      cartProductData.productPrice = product.price;
      cartProductData.productExists = true;
      cartProductData.productOutOfStock = product.countInStock < cartProduct.quantity;
    }
    return res.json(cartProductData);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.addToCart = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const { productId, quantity, selectedColour, selectedSize } = req.body;
    const user = await User.findById(req.params.id).session(session);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }
    const userCartProducts = await CartProduct.find({ _id: { $in: user.cart } }).session(session);
    const existingCartItem = userCartProducts.find((item) =>
      item.product.equals(mongoose.Types.ObjectId(productId)) &&
      item.selectedSize === selectedSize &&
      item.selectedColour === selectedColour
    );
    const product = await Product.findById(productId).session(session);
    if (!product) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Sản phẩm không tồn tại' });
    }
    if (existingCartItem) {
      let condition = product.countInStock >= existingCartItem.quantity + 1;
      if (existingCartItem.reserved) {
        condition = product.countInStock >= 1;
      }
      if (condition) {
        existingCartItem.quantity += 1;
        await existingCartItem.save({ session });
        await Product.findOneAndUpdate(
          { _id: productId },
          { $inc: { countInStock: -1 } },
          { session }
        );
        await session.commitTransaction();
        return res.status(201).end();
      }
      await session.abortTransaction();
      return res.status(404).json({ message: 'Hết hàng' });
    }
    const cartProduct = await new CartProduct({
      ...req.body,
      selectedSize,
      selectedColour,
      product: productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price,
      reserved: true
    }).save({ session });
    if (!cartProduct) {
      await session.abortTransaction();
      return res.status(500).json({ message: 'Không thể thêm sản phẩm vào giỏ hàng của bạn' });
    }
    user.cart.push(cartProduct.id);
    await user.save({ session });
    const updateProduct = await Product.findOneAndUpdate(
      { _id: productId, countInStock: { $gte: cartProduct.quantity } },
      { $inc: { countInStock: -cartProduct.quantity } },
      { new: true, session }
    );
    if (!updateProduct) {
      await session.abortTransaction();
      return res.status(400).json({ message: 'Số lượng tồn kho không đủ hoặc có sự cố' });
    }
    await session.commitTransaction();
    return res.status(201).json(cartProduct);
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};

exports.modifyProductQuantity = async function (req, res) {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: 'Người dùng không tồn tại' });
    const { quantity } = req.body;
    if (typeof quantity !== 'number' || quantity < 1) {
      return res.status(400).json({ message: 'Số lượng không hợp lệ' });
    }
    let cartProduct = await CartProduct.findById(req.params.cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ message: 'Sản phẩm trong giỏ không tồn tại' });
    }
    const actualProduct = await Product.findById(cartProduct.product);
    if (!actualProduct) {
      return res.status(404).json({ message: 'Sản phẩm không tồn tại' });
    }
    if (quantity > actualProduct.countInStock) {
      return res.status(400).json({ message: 'Số lượng tồn kho không đủ cho số lượng yêu cầu' });
    }
    cartProduct = await CartProduct.findByIdAndUpdate(
      req.params.cartProductId,
      { quantity: quantity },
      { new: true }
    );
    if (!cartProduct) {
      return res.status(404).json({ message: 'Sản phẩm trong giỏ không tồn tại' });
    }
    return res.json(cartProduct);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.removeFromCart = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const user = await User.findById(req.params.id).session(session);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }
    if (!user.cart.includes(req.params.cartProductId)) {
      await session.abortTransaction();
      return res.status(400).json({ message: 'Sản phẩm không có trong giỏ hàng của bạn' });
    }
    const cartItemToRemove = await CartProduct.findById(req.params.cartProductId).session(session);
    if (!cartItemToRemove) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Sản phẩm trong giỏ không tồn tại' });
    }
    if (cartItemToRemove.reserved) {
      const updatedProduct = await Product.findOneAndUpdate(
        { _id: cartItemToRemove.product },
        { $inc: { countInStock: cartItemToRemove.quantity } },
        { new: true, session }
      );
      if (!updatedProduct) {
        await session.abortTransaction();
        return res.status(500).json({ message: 'Lỗi hệ thống' });
      }
    }
    user.cart.pull(cartItemToRemove.id);
    await user.save({ session });
    const deletedCartProduct = await CartProduct.findByIdAndDelete(cartItemToRemove.id).session(session);
    if (!deletedCartProduct) {
      await session.abortTransaction();
      return res.status(500).json({ message: 'Lỗi hệ thống' });
    }
    await session.commitTransaction();
    return res.status(204).end();
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};
