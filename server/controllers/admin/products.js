const { Product } = require("../../models/product");
const media_helper = require("../../helpers/media_helper");
const util = require("util");
const { Category } = require("../../models/category");
const multer = require("multer");
const mongoose = require("mongoose");

exports.getProductsCount = async function (req, res) {
  try {
    const count = await Product.countDocuments();
    if (!count) {
      return res.status(500).json({ message: "Could not count products" });
    }

    return res.json({ count });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.getProducts = async function (req, res) {};

exports.addProduct = async function (req, res) {
  try {
    const uploadImage = util.promisify(
      media_helper.upload.fields([
        { name: "image", maxCount: 1 },
        { name: "images", maxCount: 10 },
      ])
    );

    try {
      await uploadImage(req, res);
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        type: error.code,
        message: `${error.message}${error.field}`,
        storageErrors: error.storageErrors,
      });
    }

    const category = await Category.findById(req.body.category);
    if (!category) {
      return res.status(404).json({ message: "Invalid category" });
    }
    if (category.markedForDeletion) {
      return res.status(404).json({ message: "category marded for deletion" });
    }
    const image = req.files["image"][0];
    if (!image) {
      return res.status(404).json({ message: "No file found!" });
    }

    req.body["image"] = `${req.protocol}://${req.get("host")}/${image.path}`;

    const gallery = req.files["images"];
    const imagePaths = [];
    if (gallery) {
      for (const image of gallery) {
        const imagePath = `${req.protocol}://${req.get("host")}/${image.path}`;
        imagePaths.push(imagePath);
      }
    }

    if (imagePaths.length > 0) {
      req.body["image"] = imagePaths;
    }

    const product = await new Product(req.body).save();
    if (!product) {
      return res
        .status(500)
        .json({ message: "The product could not be created" });
    }

    return res.status(201).json(product);
  } catch (error) {
    console.error(error);
    if (err instanceof multer.MulterError) {
      return res.status(err.code).json({ message: err.message });
    }

    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.editProduct = async function (req, res) {
  try {
    if (
      !mongoose.isValidObjectId(req.params.id) ||
      !(await Product.findById(req.params.id))
    ) {
      return res.status(404).json({ message: "Invalid Product" });
    }    

    if (req.body.category) {
      const category = await Category.findById(req.body.category);
      if (!category) {
        return res.status(404).json({ message: "no ..." });
      }
      if (category.markedForDeletion) {
        return res
          .status(404)
          .json({ message: "category marded for deletion" });
      }

      const product = await Product.findById(req.params.id);

      if (req.body.images) {
        const limit = 10 - product.images.length;
        const uploadGalary = util.promisify(
          media_helper.upload.fields([{ name: "images", maxCount: limit }])
        );

        try {
          await uploadGalary(req, res);
        } catch (error) {
          console.error(error);
          return res.status(500).json({
            type: error.code,
            message: `${error.message}${error.field}`,
            storageErrors: error.storageErrors,
          });
        }
        const imageFiles = req.files["images"];
        const updateGalary = imageFiles && imageFiles.length > 0;
        if (updateGalary) {
          const imagePaths = [];
          for (const image of gallery) {
            const imagePath = `${req.protocol}://${req.get("host")}/${
              image.path
            }`;
            imagePaths.push(imagePath);
          }
          req.body["images"] = [...product.images, ...imagePaths];
        }
      }
      if (req.body.image) {
        const uploadImage = util.promisify(
          media_helper.upload.fields([{ name: "image", maxCount: 1 }])
        );

        try {
          await uploadImage(req, res);
        } catch (error) {
          console.error(error);
          return res.status(500).json({
            type: error.code,
            message: `${error.message}${error.field}`,
            storageErrors: error.storageErrors,
          });
        }

        const image = req.files["image"][0];
        if (!image) {
          return res.status(404).json({ message: "No file found!" });
        }

        req.body["image"] = `${req.protocol}://${req.get("host")}/${
          image.path
        }`;
      }
    }

    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      {new: true}
    );
    if(!updatedProduct){
      return res.status(404).json({message: 'Product'})
    }

    return res.json(updatedProduct);
  } catch (error) {
    console.error(error);
    if (err instanceof multer.MulterError) {
      return res.status(err.code).json({ message: err.message });
    }

    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.deleteProductImages = async function (req, res) {};

exports.deleteProduct = async function (req, res) {};
