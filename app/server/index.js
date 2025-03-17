const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();

// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

const PORT = process.env.PORT || 3000;
const app = express();

// Lấy chuỗi kết nối DB từ biến môi trường
const DB = process.env.DB_URI;

// Middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// Kết nối CSDL
mongoose
  .connect(DB)
  .then(() => {
    console.log("DB Connected Successfully");
  })
  .catch((e) => console.log(e));

// Khởi chạy server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Listening at PORT ${PORT}`);
});
