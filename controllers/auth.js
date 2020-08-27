const UserModels = require('./../models/user.js');
const User = new UserModels();
const authCodeFunc = require('./../utils/authCode.js');
const authController = {
  login: async function (req, res, next) {
    let phone = req.body.phone;
    let password = req.body.password;
    if (!phone || !password) {
      res.json({ code: 0, data: 'params empty!' });
      return
    }
    try {
      const users = await User.select({ phone, password });
      const user = users[0];
      if (user) {
        res.locals.user = user.name;
        let auth_Code = phone + '\t' + password + '\t' + user.id + '\t' + user.name + '\t' + user.role;
        auth_Code = authCodeFunc(auth_Code, 'ENCODE');
        res.cookie('ac', auth_Code, { maxAge: 24 * 60 * 60 * 1000, httpOnly: true })
        res.json({ code: 200, message: '登录成功！' })
        return
      } else {
        res.json({ code: 0, data: { msg: '登录失败，没有此用户！' } })
      }
    } catch (e) {
      res.json({ code: 0, data: e })
    }
  },
  renderLogin: async function (req, res, next) {
    if (res.locals.isLogin && res.locals.userInfo.role=='管理员') {
      res.redirect('/userBase/userManagement');
      return
    }else if(res.locals.isLogin && res.locals.userInfo.role=='销售'){
      res.redirect('/userBase/clueList');
      return
    }
    res.render('login', res.locals)
  },
  // logout: async function (req, res, next) {
  //   // let ac = req.body.ac;
  //   // if (req.cookies.ac == ac) {
  //   res.clearCookie('ac');
  //   res.json({ code: 200, message: '退出成功！' })
  //   return
  //   // } else {
  //   // res.json({ code: 0, data: { msg: '退出失败！' } })
  //   // }
  // },
  renderLogout: async function (req, res, next) {
    // if (!req.cookies.ac) {
    res.clearCookie('ac');
    res.redirect('/login');
    res.json({ code: 200, message: '退出成功！' })
    return
    // }
    // res.render('user', res.locals)
  },
  // renderUser: async function (req, res, next) {
  //   let btn = req.body.btn;
  //   if (btn === "clue-manage" && res.locals.isLogin) {
  //     res.redirect('/userBase/clueList');
  //     return
  //   } else if (btn === "clue-track") {
  //     res.redirect('/userBase/clueTrack');
  //     return
  //   } else if (btn === "user-manage") {
  //     res.redirect('/userBase/userManagement')
  //     return
  //   }
  // }
}
module.exports = authController;
