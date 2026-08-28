
const express = require("express");

const router = express.Router();

const {
  registerUser,
  loginUser,
  getProfile,
  updateProfile,
} = require("../controllers/authController");

const { protect } = require("../middleware/authMiddleware");


// ============================================================
// PUBLIC AUTH ROUTES
// ============================================================

router.post("/register", registerUser);

router.post("/login", loginUser);


// ============================================================
// PROTECTED PROFILE ROUTES
// ============================================================

router.get("/profile", protect, getProfile);

router.put("/profile", protect, updateProfile);


module.exports = router;