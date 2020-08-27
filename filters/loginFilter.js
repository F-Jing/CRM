const authCodeFunc = require('./../utils/authCode.js');
module.exports = function (req, res, next) {
  res.locals.title = "CRM客户管理系统";
  res.locals.isLogin = false;
  res.locals.userInfo = {};
  let auth_Code = req.cookies.ac;
  if (auth_Code) {
    auth_Code = authCodeFunc(auth_Code, 'DECODE');
    authArr = auth_Code.str.split('\t');
    let phone = authArr[0];
    let password = authArr[1];
    let id = authArr[2];
    let name = authArr[3];
    let role = authArr[4];
    res.locals.isLogin = true;
    res.locals.userInfo = {
      phone, password, id, name, role
    }
  }
  next();
}
