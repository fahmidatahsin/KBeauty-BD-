const SSLCommerzPayment = require("sslcommerz-lts");
const Order = require("../models/orderModel");

const store_id = process.env.SSLCOMMERZ_STORE_ID;
const store_passwd = process.env.SSLCOMMERZ_STORE_PASSWORD;
const is_live = false;

// 💳 Initiate Payment
exports.initiatePayment = async (req, res) => {
  try {
    const { orderId } = req.body;

    // Debugging
    console.log("Payment Order ID:", orderId);
    console.log("Logged-in User ID:", req.user.id);

    const order = await Order.findOne({
      _id: orderId,
      user: req.user.id,
    });

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    const data = {
      total_amount: order.totalAmount,
      currency: "BDT",
      tran_id: order._id.toString(),

      success_url: "http://localhost:5000/api/payment/success",
      fail_url: "http://localhost:5000/api/payment/fail",
      cancel_url: "http://localhost:5000/api/payment/cancel",
      ipn_url: "http://localhost:5000/api/payment/ipn",

      shipping_method: "NO",
      product_name: "KBeauty BD Order",
      product_category: "Beauty",
      product_profile: "general",

      cus_name: req.user.fullName || "Customer",
      cus_email: req.user.email || "customer@example.com",
      cus_add1: "Chittagong",
      cus_city: "Chittagong",
      cus_country: "Bangladesh",
      cus_phone: "01700000000",
    };

    const sslcz = new SSLCommerzPayment(
      store_id,
      store_passwd,
      is_live
    );

    const apiResponse = await sslcz.init(data);

    res.status(200).json(apiResponse);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Payment initialization failed",
      error: error.message,
    });
  }
};


// ✅ Payment Success
exports.paymentSuccess = async (req, res) => {
  try {
    const { tran_id, val_id } = req.body;

    const order = await Order.findById(tran_id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    order.paymentStatus = "Paid";
    order.transactionId = val_id || tran_id;

    await order.save();

    res.status(200).json({
      message: "Payment successful",
      order,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Payment success processing failed",
      error: error.message,
    });
  }
};


// ❌ Payment Failed
exports.paymentFail = async (req, res) => {
  try {
    const { tran_id } = req.body;

    const order = await Order.findById(tran_id);

    if (order) {
      order.paymentStatus = "Failed";
      await order.save();
    }

    res.status(200).json({
      message: "Payment failed",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Payment failure processing failed",
      error: error.message,
    });
  }
};


// 🚫 Payment Cancelled
exports.paymentCancel = async (req, res) => {
  try {
    const { tran_id } = req.body;

    const order = await Order.findById(tran_id);

    if (order) {
      order.paymentStatus = "Cancelled";
      await order.save();
    }

    res.status(200).json({
      message: "Payment cancelled",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Payment cancellation processing failed",
      error: error.message,
    });
  }
};


// 🔔 IPN
exports.paymentIPN = async (req, res) => {
  try {
    console.log("SSLCOMMERZ IPN:", req.body);

    const { tran_id, val_id, status } = req.body;

    const order = await Order.findById(tran_id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    if (status === "VALID" || status === "VALIDATED") {
      order.paymentStatus = "Paid";
      order.transactionId = val_id || tran_id;

      await order.save();
    }

    res.status(200).json({
      message: "IPN processed successfully",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "IPN processing failed",
      error: error.message,
    });
  }
};