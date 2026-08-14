const adminMiddleware = (req, res, next) => {

  console.log(req.user); // 👈 এই লাইনটা এখানে যোগ করো

  if (!req.user) {
    return res.status(401).json({
      message: "Not authenticated",
    });
  }

  if (req.user.role !== "admin") {
    return res.status(403).json({
      message: "Admin access required",
    });
  }

  next();
};

module.exports = adminMiddleware;