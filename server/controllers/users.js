const { User } = require("../models/user");

exports.getUsers = async (_, res) => {
  try {
    const users = await User.find().select("name email _id isAdmin");
    
    if (!users || users.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng nào!" });
    }

    return res.json(users);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách người dùng:", error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-passwordHash -resetPasswordOtp -resetPasswordOtpExpires -cart');
    
    if (!user) {
      return res.status(404).json({ message: "Không tìm thấy người dùng!" });
    }

    return res.json(user);
  } catch (error) {
    console.error("Lỗi khi lấy thông tin người dùng theo ID:", error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};

exports.updateUser = async (req, res) => {
  try {
    const { name, phone, email } = req.body;
    const user = await User.findByIdAndUpdate(
        req.params.id,
        { name, email, phone },
        { new: true },
    );

    if(!user){
        return res.status(404).json({message: 'User not found'});
    }

    user.passwordHash= undefined; 
    user.cart = undefined;
    return res.json(user);
  } catch (error) {
    console.error("Lỗi khi cập nhật người dùng:", error);
    return res.status(500).json({ type: error.name, message: error.message });
  }
};