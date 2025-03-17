const express = require("express");
const userRouter = express.Router();
const User = require("../models/user");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const Order = require("../models/order");

// Add item to cart
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        if (!product) {
            return res.status(404).json({ error: "Product not found" });
        }

        let user = await User.findById(req.user);

        if (user.cart.length == 0) {
            console.log("====> User cart length 0: incrementing to 1");
            user.cart.push({ product, quantity: 1 });
        } else {
            console.log("====> User cart length non-zero: incrementing to 1");
            let isProductFound = false;

            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(product._id)) {
                    isProductFound = true;
                }
            }

            if (isProductFound) {
                let productFound = user.cart.find((productItem) =>
                    productItem.product._id.equals(product._id)
                );
                console.log("====> Product found in cart already, incrementing by 1");
                productFound.quantity += 1;
            } else {
                user.cart.push({ product, quantity: 1 });
            }
        }

        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Add item to wishList
userRouter.post("/api/add-to-wishList", auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        if (!product) {
            return res.status(404).json({ error: "Product not found" });
        }

        let user = await User.findById(req.user);

        if (user.wishList.length == 0) {
            user.wishList.push({ product });
        } else {
            let isProductFound = false;
            for (let i = 0; i < user.wishList.length; i++) {
                if (user.wishList[i].product._id.equals(product._id)) {
                    isProductFound = true;
                }
            }
            if (!isProductFound) {
                user.wishList.push({ product });
            }
        }

        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({
            error: `Error in adding to wishList ${e.message}`,
        });
    }
});

// Add profile picture
userRouter.post("/api/add-profile-picture", auth, async (req, res) => {
    try {
        const { imageUrl } = req.body;
        let user = await User.findById(req.user);
        user.imageUrl = imageUrl;
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Remove item from cart
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findById(id);
        if (!product) {
            return res.status(404).json({ error: "Product not found" });
        }

        let user = await User.findById(req.user);
        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(product._id)) {
                if (user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1);
                } else {
                    user.cart[i].quantity -= 1;
                }
            }
        }

        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({
            error: `Error in removing product from cart : ${e.message}`,
        });
    }
});

// Save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
    try {
        const { address } = req.body;
        let user = await User.findById(req.user);
        user.address = address;
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Order product
userRouter.post("/api/order", auth, async (req, res) => {
    try {
        const { cart, totalPrice, address } = req.body;
        let products = [];

        for (let i = 0; i < cart.length; i++) {
            let product = await Product.findById(cart[i].product._id);
            if (!product) {
                return res.status(404).json({ error: "Product not found" });
            }
            if (product.quantity >= cart[i].quantity) {
                product.quantity -= cart[i].quantity;
                products.push({ product, quantity: cart[i].quantity });
                await product.save();
            } else {
                return res.status(400).json({ msg: `${product.name} is out of stock` });
            }
        }

        let user = await User.findById(req.user);
        user.cart = [];
        user = await user.save();

        let order = new Order({
            products,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        });

        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get all orders
userRouter.get("/api/orders/me", auth, async (req, res) => {
    try {
        let orders = await Order.find({ userId: req.user });
        res.json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Add search history
userRouter.post("/api/search-history", auth, async (req, res) => {
    try {
        const { searchQuery } = req.body;
        let user = await User.findById(req.user);
        user.searchHistory.push(searchQuery.trim());
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({
            error: `Error in adding search query in DB : ${e.message}`,
        });
    }
});

// Get search history
userRouter.get("/api/get-search-history", auth, async (req, res) => {
    try {
        let user = await User.findById(req.user);
        let searchHistory = user.searchHistory;
        res.json(searchHistory);
    } catch (e) {
        res.status(500).json({
            error: `Error in fetching search history : ${e.message}`,
        });
    }
});

// Get wishList
userRouter.get("/api/get-wishList", auth, async (req, res) => {
    try {
        let user = await User.findById(req.user);
        let wishList = user.wishList;
        res.json(wishList);
    } catch (e) {
        res.status(500).json({
            error: `Error in fetching wishList : ${e.message}`,
        });
    }
});

module.exports = userRouter;
