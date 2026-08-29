const express = require("express");

const router = express.Router();

const {
  registerUser,
  loginUser,
  getProfile,
  updateProfile,
  forgotPassword,
  resetPassword,
} = require("../controllers/authController");

const { protect } = require("../middleware/authMiddleware");

// ============================================================
// PUBLIC AUTH ROUTES
// ============================================================

router.post("/register", registerUser);

router.post("/login", loginUser);

router.post("/forgot-password", forgotPassword);

router.put("/reset-password/:token", resetPassword);

// ============================================================
// PROTECTED PROFILE ROUTES
// ============================================================

router.get("/profile", protect, getProfile);

router.put("/profile", protect, updateProfile);

module.exports = router;