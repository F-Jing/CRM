const crypto = require('crypto');
const CSRF = {
  generateRandom: function (len) {
    return crypto.randomBytes(Math.ceil(len * 3 / 4)).toString('base64').slice(0, len)
  },
  getToken: function (req, res, next) {
    var token = req.session._csrf;
    var _csrf = req.query.csrf ? req.query.csrf : (req.query.csrf = req.body.csrf);
    if (_csrf !== token) {
      res.writeHead(403);
      res.end("禁止访问");
    } else {
      next();
    }
  },
  setToken: function (req, res, next) {
    var token = req.session._csrf || (req.session._csrf = CSRF.generateRandom(28));
    res.locals.csrf = token;
    next();
  }
}
module.exports = CSRF;
