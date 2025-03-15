const { Product } = require("../models/product");

exports.getProducts = async function (req, res) {
  let products;
  const page = req.query.page || 1;
  const pageSize = 10;

  try {
    if (req.query.criteria) {
      let query = {};

      if (req.query.category) {
        query["category"] = req.query.category;
      }

      switch (req.query.criteria) {
        case "newArrivals":
          const twoWeeksAgo = new Date();
          twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
          query["dateAdded"] = { $gte: twoWeeksAgo };
          break;

        case "popular":
          query["rating"] = { $gte: 4.5 };
          break;

        default:
          break;
      }

      products = await Product.find(query)
        .skip((page - 1) * pageSize)
        .limit(pageSize);

      return res.json(products);
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.searchProducts = async function (req, res) {};

exports.getProductById = async function (req, res) {};
