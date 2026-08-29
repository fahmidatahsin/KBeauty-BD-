const Cart = require("../models/cartModel");
const Product = require("../models/Product");

// ======================================================
// ADD TO CART
// ======================================================

exports.addToCart = async (req, res) => {
  try {
    const { productId, quantity } = req.body;

    // Validate input
    if (!productId || !quantity || quantity < 1) {
      return res.status(400).json({
        message: "Product ID and valid quantity are required",
      });
    }

    // Check whether product exists
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    // Find user's cart
    let cart = await Cart.findOne({
      user: req.user.id,
    });

    // Create new cart
    if (!cart) {
      cart = new Cart({
        user: req.user.id,
        items: [
          {
            product: productId,
            quantity: quantity,
          },
        ],
      });
    } else {
      // Check if product already exists
      const index = cart.items.findIndex(
        (item) => item.product.toString() === productId
      );

      if (index > -1) {
        // Increase existing quantity
        cart.items[index].quantity += quantity;
      } else {
        // Add new product
        cart.items.push({
          product: productId,
          quantity: quantity,
        });
      }
    }

    await cart.save();

    // Populate product information before sending response
    await cart.populate("items.product");

    res.status(200).json({
      message: "Product added to cart successfully",
      cart,
    });
  } catch (error) {
    console.error("Add to cart error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ======================================================
// UPDATE CART QUANTITY
// ======================================================

exports.updateCart = async (req, res) => {
  try {
    const { productId } = req.params;
    const { quantity } = req.body;

    // Validate quantity
    if (!quantity || quantity < 1) {
      return res.status(400).json({
        message: "Quantity must be at least 1",
      });
    }

    // Find user's cart
    const cart = await Cart.findOne({
      user: req.user.id,
    });

    if (!cart) {
      return res.status(404).json({
        message: "Cart not found",
      });
    }

    // Find product in cart
    const item = cart.items.find(
      (i) => i.product.toString() === productId
    );

    if (!item) {
      return res.status(404).json({
        message: "Product not found in cart",
      });
    }

    // Update quantity
    item.quantity = quantity;

    await cart.save();

    // Populate product information
    await cart.populate("items.product");

    res.status(200).json({
      message: "Cart updated successfully",
      cart,
    });
  } catch (error) {
    console.error("Update cart error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ======================================================
// REMOVE SINGLE PRODUCT FROM CART
// ======================================================

exports.removeFromCart = async (req, res) => {
  try {
    const { productId } = req.params;

    // Find user's cart
    const cart = await Cart.findOne({
      user: req.user.id,
    });

    if (!cart) {
      return res.status(404).json({
        message: "Cart not found",
      });
    }

    // Check whether product exists in cart
    const existingItem = cart.items.find(
      (i) => i.product.toString() === productId
    );

    if (!existingItem) {
      return res.status(404).json({
        message: "Product not found in cart",
      });
    }

    // Remove product
    cart.items = cart.items.filter(
      (i) => i.product.toString() !== productId
    );

    await cart.save();

    // Populate product information
    await cart.populate("items.product");

    res.status(200).json({
      message: "Product removed from cart",
      cart,
    });
  } catch (error) {
    console.error("Remove cart item error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ======================================================
// CLEAR ENTIRE CART
// ======================================================

exports.clearCart = async (req, res) => {
  try {
    // Find user's cart
    const cart = await Cart.findOne({
      user: req.user.id,
    });

    // If cart doesn't exist
    if (!cart) {
      return res.status(200).json({
        message: "Cart is already empty",
        cart: {
          items: [],
        },
      });
    }

    // Remove all items
    cart.items = [];

    await cart.save();

    res.status(200).json({
      message: "Cart cleared successfully",
      cart,
    });
  } catch (error) {
    console.error("Clear cart error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};

// ======================================================
// GET CART
// ======================================================

exports.getCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({
      user: req.user.id,
    }).populate("items.product");

    // No cart found = empty cart
    if (!cart) {
      return res.status(200).json({
        items: [],
      });
    }

    res.status(200).json(cart);
  } catch (error) {
    console.error("Get cart error:", error);

    res.status(500).json({
      message: error.message,
    });
  }
};