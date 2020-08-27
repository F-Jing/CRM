const userModels = require('./../models/user.js');
const User = new userModels;
const allocationController = {
  show: async function (req, res, next) {
    try {
      const users = await User.all();
      res.locals.users = users;
      res.render('allocation.tpl', res.locals);
    } catch (e) {
      res.locals.error = e;
      res.render('error', res.locals)
    }
  },
}
module.exports = allocationController;