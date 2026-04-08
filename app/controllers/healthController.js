exports.healthCheck = (req, res) => {
  res.json({
    status: 'OK',
    message: 'Dockerized Node app is running 🚀'
  });
};
