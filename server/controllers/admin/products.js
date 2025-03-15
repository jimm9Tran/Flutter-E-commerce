const { Product } = require("../../models/product");
const { Review } = require("../../models/review");
const { Category } = require("../../models/category");
const media_helper = require("../../helpers/media_helper");
const util = require("util");
const multer = require("multer");
const { default: mongoose } = require("mongoose");

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
    // Kiểm tra ID sản phẩm hợp lệ
    if (
      !mongoose.isValidObjectId(req.params.id) ||
      !(await Product.findById(req.params.id))
    ) {
      return res.status(404).json({ message: "Invalid Product" });
    }

    // Nếu có cập nhật danh mục, kiểm tra danh mục đó
    if (req.body.category) {
      const category = await Category.findById(req.body.category);
      if (!category) {
        return res.status(404).json({ message: "Invalid category" });
      }
      if (category.markedForDeletion) {
        return res
          .status(404)
          .json({ message: "Category is marked for deletion" });
      }
    }

    // Lấy thông tin sản phẩm hiện tại
    const product = await Product.findById(req.params.id);

    // Xử lý cập nhật gallery nếu có
    if (req.body.images) {
      const limit = 10 - (product.images ? product.images.length : 0);
      const uploadGallery = util.promisify(
        media_helper.upload.fields([{ name: "images", maxCount: limit }])
      );

      try {
        await uploadGallery(req, res);
      } catch (error) {
        console.error(error);
        return res.status(500).json({
          type: error.code,
          message: `${error.message}${error.field}`,
          storageErrors: error.storageErrors,
        });
      }
      const imageFiles = req.files["images"];
      if (imageFiles && imageFiles.length > 0) {
        const imagePaths = [];
        for (const image of imageFiles) {
          // sử dụng imageFiles thay vì gallery
          const imagePath = `${req.protocol}://${req.get("host")}/${
            image.path
          }`;
          imagePaths.push(imagePath);
        }
        req.body["images"] = [...(product.images || []), ...imagePaths];
      }
    }

    // Xử lý cập nhật ảnh chính nếu có
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

      const image = req.files["image"] ? req.files["image"][0] : null;
      if (!image) {
        return res.status(404).json({ message: "No file found!" });
      }

      req.body["image"] = `${req.protocol}://${req.get("host")}/${image.path}`;
    }

    // Cập nhật sản phẩm
    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedProduct) {
      return res.status(404).json({ message: "Product not updated" });
    }

    return res.json(updatedProduct);
  } catch (error) {
    console.error(error);
    if (error instanceof multer.MulterError) {
      return res.status(500).json({ message: error.message });
    }

    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.deleteProductImages = async function (req, res) {
  try {
    const productId = req.params.id;
    const { deletedImageUrls } = req.body;

    if (
      !mongoose.isValidObjectId(productId) ||
      !Array.isArray(deletedImageUrls)
    ) {
      return res.status(400).json({ message: "Invalid request data" });
    }

    await media_helper.deleteImages(deletedImageUrls);

    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    product.images = product.images.filter(
      (image) => !deletedImageUrls.includes(image)
    );

    await product.save();

    return res.status(204).end();
  } catch (error) {
    console.error(`Error deleting product: ${error.message}`);
    if (error.code === "ENOENT") {
      return res.status(404).json({ message: "image not found" });
    }

    return res.status(500).json({ message: error.message });
  }
};

exports.deleteProduct = async function (req, res) {
  try {
    const productId = req.params.id;
    if (!mongoose.isValidObjectId(productId)) {
      return res.status(404).json("Invalid Product");
    }

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    await media_helper.deleteImages(
      [...product.images, product.image],
      "ENOENT"
    );

    await Review.deleteMany({_id: {$in: product.reviews}});

    await Product.findByIdAndDelete(productId);

    return res.status(204).end();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.getProducts = async function (req, res) {
  try {
    
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};
