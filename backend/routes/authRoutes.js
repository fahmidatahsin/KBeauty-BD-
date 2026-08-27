

const express = require("express");
const router = express.Router();

const {
  registerUser,
  loginUser,
} = require("../controllers/authController");

// 👉 middleware import কর
const { protect } = require("../middleware/authMiddleware");

// ✅ routes
router.post("/register", registerUser);
router.post("/login", loginUser);

// 🔐 protected route
router.get("/profile", protect, (req, res) => {
  res.json({
    message: "Profile data",
    user: req.user,
  });
});

module.exports = router;