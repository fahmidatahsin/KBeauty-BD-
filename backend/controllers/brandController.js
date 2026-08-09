
const Brand = require("../models/Brand");
// Create
exports.createBrand = async (req, res) => {
  try {
    const brand = await Brand.create(req.body);
    res.status(201).json(brand);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get All
exports.getBrands = async (req, res) => {
  try {
    const brands = await Brand.find();
    res.json(brands);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get One
exports.getBrand = async (req, res) => {
  try {
    const brand = await Brand.findById(req.params.id);
    res.json(brand);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update
exports.updateBrand = async (req, res) => {
  try {
    const brand = await Brand.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    res.json(brand);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete
exports.deleteBrand = async (req, res) => {
  try {
    await Brand.findByIdAndDelete(req.params.id);
    res.json({ message: "Deleted" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};