const express = require("express");
const router = express.Router();

const {
  initiatePayment,
  paymentSuccess,
  paymentFail,
  paymentCancel,
  paymentIPN,
} = require("../controllers/paymentController");

const authMiddleware = require("../middleware/authMiddleware");

// 💳 Initiate Payment
router.post("/initiate", authMiddleware, initiatePayment);

// ✅ Payment Success
router.post("/success", paymentSuccess);

// ❌ Payment Failed
router.post("/fail", paymentFail);

// 🚫 Payment Cancelled
router.post("/cancel", paymentCancel);

// 🔔 IPN
router.post("/ipn", paymentIPN);

module.exports = router;