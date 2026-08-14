const Wishlist = require("../models/wishlistModel");

// ❤️ Add to Wishlist
exports.addToWishlist = async (req, res) => {
  const { productId } = req.body;

  let wishlist = await Wishlist.findOne({ user: req.user.id });

  if (!wishlist) {
    wishlist = new Wishlist({
      user: req.user.id,
      products: [productId],
    });
  } else {
    const alreadyExists = wishlist.products.some(
      (product) => product.toString() === productId
    );

    if (alreadyExists) {
      return res.status(400).json({
        message: "Product already in wishlist",
      });
    }

    wishlist.products.push(productId);
  }

  await wishlist.save();

  res.status(200).json({
    message: "Product added to wishlist",
    wishlist,
  });
};


// 📋 Get Wishlist
exports.getWishlist = async (req, res) => {
  const wishlist = await Wishlist.findOne({
    user: req.user.id,
  }).populate("products");

  if (!wishlist) {
    return res.status(200).json({
      products: [],
    });
  }

  res.status(200).json(wishlist);
};


// ❌ Remove from Wishlist
exports.removeFromWishlist = async (req, res) => {
  const { productId } = req.params;

  const wishlist = await Wishlist.findOne({
    user: req.user.id,
  });

  if (!wishlist) {
    return res.status(404).json({
      message: "Wishlist not found",
    });
  }

  wishlist.products = wishlist.products.filter(
    (product) => product.toString() !== productId
  );

  await wishlist.save();

  res.status(200).json({
    message: "Product removed from wishlist",
    wishlist,
  });
};