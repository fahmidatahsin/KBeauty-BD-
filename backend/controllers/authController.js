const User = require("../models/User");
const bcrypt = require("bcrypt");
const registerUser = async (req, res) => {
    const { fullName, email, password, phone } = req.body;
    const existingUser = await User.findOne({ email });

if (existingUser) {
    return res.status(400).json({
        message: "Email already exists"
    });
}
const hashedPassword = await bcrypt.hash(password, 10);
const user = new User({
    fullName,
    email,
    password: hashedPassword,
    phone,
});
await user.save();
res.status(201).json({
    message: "User registered successfully",
    user,
});

};
module.exports = {
    registerUser,
};