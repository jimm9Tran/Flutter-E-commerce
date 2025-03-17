const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const User = require("../models/user");

productRouter.get("/api/products/", auth, async (req, res) => {
  try {
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);
    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = { userId: req.user, rating };
    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});
    if (products.length === 0) {
      return res.status(404).json({ error: "No products found" });
    }
    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;
      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }
      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });
    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.get("/api/get-all-products-names", auth, async (req, res) => {
  try {
    const products = await Product.find({});
    let productNames = products.map((p) => p.name);
    res.json(productNames);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


productRouter.get("/api/get-user-of-product", auth, async (req, res) => {
  try {
    const productId = req.query.id;
    if (!productId) {
      return res.status(400).json({ error: "Product ID is required" });
    }
    let product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }
    let usersList = [];
    for (let i = 0; i < product.ratings.length; i++) {
      let userExist = await User.findById(product.ratings[i].userId);
      if (userExist) usersList.push(userExist);
    }
    res.json(usersList);
  } catch (e) {
    res.status(500).json({ error: `Error in getting users: ${e.message}` });
  }
});

module.exports = productRouter;
