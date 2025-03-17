const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
    try {
        const { name, description, brandName, images, quantity, price, category } = req.body;

        let product = new Product({
            name,
            description,
            brandName,
            images,
            quantity,
            price,
            category,
        });

        product = await product.save();
        res.json(product);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Get all products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
    try {
        const products = await Product.find({});
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Delete product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Change order status
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
    try {
        const { id, status } = req.body;

        let order = await Order.findById(id);
        if (!order) {
            return res.status(404).json({ msg: "Order not found" });
        }

        order.status = status;
        await order.save();
        res.json(order);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Get all orders
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        res.json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i].products.length; j++) {
                totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price;
            }
        }

        let mobileEarnings = await fetchCategoryWiseProducts("Mobiles");
        let essentialsEarnings = await fetchCategoryWiseProducts("Essentials");
        let appliancesEarnings = await fetchCategoryWiseProducts("Appliances");
        let booksEarnings = await fetchCategoryWiseProducts("Books");
        let fashionEarnings = await fetchCategoryWiseProducts("Fashion");

        let earnings = {
            totalEarnings,
            mobileEarnings,
            essentialsEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings,
        };

        res.json(earnings);
    } catch (e) {
        res.status(500).json({
            error: `Analytics get request error : ${e.message}`,
        });
    }
});

async function fetchCategoryWiseProducts(category) {
    let earnings = 0;
    const categoryOrders = await Order.aggregate([
        { $unwind: "$products" },
        { $match: { "products.product.category": category } },
        { $group: {
            _id: "$products.product.category",
            total: { $sum: { $multiply: ["$products.quantity", "$products.product.price"] } }
        }}
    ]);

    if (categoryOrders.length > 0) {
        earnings = categoryOrders[0].total;
    }

    return earnings;
}

module.exports = adminRouter;
