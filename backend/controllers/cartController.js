const Cart = require("../models/cartModel");
const Product = require("../models/Product");

// ➕ Add to Cart
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
      // Check if product already exists in cart
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

    res.status(200).json({
      message: "Product added to cart successfully",
      cart,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: error.message,
    });
  }
};


// 🔄 Update quantity
exports.updateCart = async (req, res) => {
  try {
    const { productId } = req.params;
    const { quantity } = req.body;

    if (!quantity || quantity < 1) {
      return res.status(400).json({
        message: "Quantity must be at least 1",
      });
    }

    const cart = await Cart.findOne({
      user: req.user.id,
    });

    if (!cart) {
      return res.status(404).json({
        message: "Cart not found",
      });
    }

    const item = cart.items.find(
      (i) => i.product.toString() === productId
    );

    if (!item) {
      return res.status(404).json({
        message: "Product not found in cart",
      });
    }

    item.quantity = quantity;

    await cart.save();

    res.status(200).json({
      message: "Cart updated successfully",
      cart,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: error.message,
    });
  }
};


// ❌ Remove item
exports.removeFromCart = async (req, res) => {
  try {
    const { productId } = req.params;

    const cart = await Cart.findOne({
      user: req.user.id,
    });

    if (!cart) {
      return res.status(404).json({
        message: "Cart not found",
      });
    }

    cart.items = cart.items.filter(
      (i) => i.product.toString() !== productId
    );

    await cart.save();

    res.status(200).json({
      message: "Product removed from cart",
      cart,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: error.message,
    });
  }
};


// 📥 Get Cart
exports.getCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({
      user: req.user.id,
    }).populate("items.product");

    if (!cart) {
      return res.status(200).json({
        items: [],
      });
    }

    res.status(200).json(cart);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: error.message,
    });
  }
};