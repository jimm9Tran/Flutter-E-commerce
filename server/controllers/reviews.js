const { User } = require('../models/user');
const { Review } = require('../models/review');
const { Product } = require('../models/product');
const { default: mongoose } = require('mongoose');
const jwt = require('jsonwebtoken');

exports.leaveReview = async function (req, res) {
  try {
    const user = await User.findById(req.body.user);
    if (!user) {
      return res.status(404).json({ message: 'Invalid user!' });
    }

    const review = await new Review({
      ...req.body,
      userName: user.name,
    }).save();

    if (!review) {
      return res.status(400).json({ message: 'The review could not be created' });
    }

    let product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    product.reviews.push(review.id);
    product = await product.save();

    return res.status(201).json({ product, review });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};


exports.getProductReviews = async function (req, res) {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const product = await Product.findById(req.params.id).session(session);
    if (!product) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Product not found' });
    }

    const page = Number(req.query.page) || 1;
    const pageSize = 10;

    const reviews = await Review.find({ _id: { $in: product.reviews } })
      .sort({ date: -1 })
      .skip((page - 1) * pageSize)
      .limit(pageSize);

    const processedReviews = [];

    for (const review of reviews) {
      const user = await User.findById(review.user);
      if (!user) {
        processedReviews.push(review);
        continue;
      }

      let updatedReview;
      if (review.userName !== user.name) {
        review.userName = user.name;
        updatedReview = await review.save({ session });
      }

      processedReviews.push(updatedReview ?? review);
    }

    await session.commitTransaction();

    return res.json(processedReviews);
  } catch (error) {
    await session.abortTransaction();
    console.error(error);
    return res.status(500).json({ type: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};