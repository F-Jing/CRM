const userModels = require('./../models/user.js');
const User = new userModels;
const querystring = require('querystring');
const url = require('url');
const userController = {
  show: async function (req, res, next) {
    let urlReq = req.url;
    let results = url.parse(urlReq);
    let querys = results.query;
    let querysObj = querystring.parse(querys);
    let querysName = querysObj.name
    let name = querysName;
    if (!res.locals.isLogin) {
      res.redirect('/login')
      return
    }
    if(!User.select({'role':'管理员'})){
      return;
    }
    if (!querys) {
      try {
        const users = await User.all();
        res.locals.users = users;
        res.render('user/userManagement.tpl', res.locals);
      } catch (e) {
        res.locals.error = e;
        res.render('error', res.locals)
      }
    } else {
      const users = await User.select({ name });
      res.locals.users = users;
      res.render('user/userManagement.tpl', res.locals);
    }
  },
  search: async function (req, res, next) {
    let name = req.body.value;
    let url = req.url;
    console.log(url, 111)
    if (!name) {
      res.redirect('/userBase/userManagement')
      res.json({ code: 0, data: 'params empty!' })
      return
    }
    try {
      const users = await User.select({ name });
      // res.locals.users = users;
      console.log(users, 123)
      res.locals.users = users;
      res.redirect('/userBase/userManagement');
      // res.json({ code: 200, data: users })

    } catch (e) {
      console.log(e)
      res.json({ code: 0, data: e })
    }
  },
  // showSearch: async function (req, res, next) {
  //   console.log(11111222222)
  //   let name = 0
  //   try {
  //     const users = await User.select({ name });
  //     res.locals.users = users;
  //     res.render('user/userManagement.tpl', res.locals);
  //   } catch (e) {
  //     res.locals.error = e;
  //     res.render('error', res.locals)
  //   }
  // },
  insert: async function (req, res, next) {
    let name = req.body.name;
    let phone = req.body.phone;
    let password = req.body.password;
    let role = req.body.role;
    if (!name || !phone || !password || !role) {
      res.json({ code: 0, data: 'params empty!' });
      return
    }
    try {
      const users = await User.insert({ name, phone, password, role })
      res.json({ code: 200, data: users })
    } catch (e) {
      res.json({ code: 0, data: e })
    }
  },
  update: async function (req, res, next) {
    let id = req.body.id;
    let name = req.body.name;
    let phone = req.body.phone;
    let password = req.body.password;
    let role = req.body.role;
    if (!name || !phone || !password || !role) {
      res.json({ code: 0, data: 'params empty!' })
      return
    }
    try {
      const user = await User.update(id, { name, phone, password, role });
      res.json({ code: 200, data: user })
    } catch (e) {
      res.json({ code: 0, data: e })
    }
  },
  delete: async function (req, res, next) {
    let id = req.body.id;
    if (!id) {
      res.json({ code: 0, data: 'params empty!' })
      return
    }
    try {
      const user = await User.delete(id);
      res.json({ code: 200, data: user })
    } catch (e) {
      res.json({ code: 0, data: e })
    }
  },
  
}
module.exports = userController;

