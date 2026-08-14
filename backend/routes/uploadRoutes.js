const express = require("express");
const router = express.Router();

const upload = require("../middleware/uploadMiddleware");

router.post("/", upload.single("image"), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        message: "No image uploaded"
      });
    }

    const imageUrl = `/uploads/${req.file.filename}`;

    res.status(201).json({
      message: "Image uploaded successfully",
      image: imageUrl
    });

  } catch (error) {
    res.status(500).json({
      message: "Image upload failed",
      error: error.message
    });
  }
});

module.exports = router;