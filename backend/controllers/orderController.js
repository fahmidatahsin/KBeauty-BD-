const Order = require("../models/orderModel");
const Cart = require("../models/cartModel");

// ============================================================
// 🛒 PLACE ORDER
// ============================================================

exports.placeOrder = async (req, res) => {
  try {
    const { customerName, address, contactNo } = req.body;

    if (!customerName || !address || !contactNo) {
      return res.status(400).json({
        message: "Name, address and contact number are required.",
      });
    }

    const cart = await Cart.findOne({
      user: req.user.id,
    }).populate("items.product");

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({
        message: "Cart is empty",
      });
    }

    const items = cart.items.map((item) => ({
      product: item.product._id,
      quantity: item.quantity,
      price: item.product.price,
    }));

    const subtotal = cart.items.reduce((total, item) => {
  return total + item.product.price * item.quantity;
}, 0);

const deliveryCharge = 80;

const totalAmount = subtotal + deliveryCharge;
    const order = new Order({
      user: req.user.id,
      customerName,
      address,
      contactNo,
      items,
      totalAmount,
      paymentMethod: "Cash on Delivery",
      paymentStatus: "Pending",
      status: "Pending",
    });

    await order.save();

    // Clear cart after order
    cart.items = [];
    await cart.save();

    res.status(201).json({
      message: "Order placed successfully",
      order,
    });
  } catch (error) {
    console.error("Place order error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ============================================================
// 📋 USER ORDER HISTORY
// ============================================================

exports.getOrderHistory = async (req, res) => {
  try {
    const orders = await Order.find({
      user: req.user.id,
    })
      .populate("items.product")
      .sort({ createdAt: -1 });

    res.status(200).json(orders);
  } catch (error) {
    console.error("Get order history error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ============================================================
// 🔍 USER ORDER DETAILS
// ============================================================

exports.getOrderDetails = async (req, res) => {
  try {
    const { id } = req.params;

    const order = await Order.findOne({
      _id: id,
      user: req.user.id,
    }).populate("items.product");

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    res.status(200).json(order);
  } catch (error) {
    console.error("Get order details error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ============================================================
// 👨‍💼 ADMIN - GET ALL ORDERS
// ============================================================

exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find()
      .populate("user", "fullName email phone")
      .populate("items.product")
      .sort({ createdAt: -1 });

    res.status(200).json({
      orders,
    });
  } catch (error) {
    console.error("Admin get all orders error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ============================================================
// 👨‍💼 ADMIN - UPDATE ORDER STATUS
// ============================================================

exports.updateOrderStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const allowedStatuses = [
      "Pending",
      "Processing",
      "Shipped",
      "Delivered",
      "Cancelled",
    ];

    if (!allowedStatuses.includes(status)) {
      return res.status(400).json({
        message: "Invalid order status",
      });
    }

    const order = await Order.findById(id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    order.status = status;

    await order.save();

    const updatedOrder = await Order.findById(id)
      .populate("user", "fullName email phone")
      .populate("items.product");

    res.status(200).json({
      message: "Order status updated successfully",
      order: updatedOrder,
    });
  } catch (error) {
    console.error("Admin update order status error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};