const clueListModels = require('./../models/clueList.js');
const ClueList = new clueListModels;
const userModels = require('./../models/user.js');
const User = new userModels;
const clueManagementModels = require('./../models/clueManagement');
const ClueManagement = new clueManagementModels;
const timeShift = require('./../models/time.js')
const querystring = require('querystring');
const url = require('url');
const clueListController = {
  show: async function (req, res, next) {
    let urlReq = req.url;
    let results = url.parse(urlReq);
    let querys = results.query;
    let querysObj = querystring.parse(querys);
    let id = querysObj.ID;
    let name = querysObj.name;
    if (!res.locals.isLogin) {
      res.redirect('/login')
      return
    }
    const sougo = await ClueList.select({'utm_source':'sougo'});
    const sougoLength = sougo.length;
    const baiduLength = await (await ClueList.select({'utm_source':'baidu'})).length;
    const allLength = await (await ClueList.all()).length;
    res.locals.sougoPercent = (sougoLength/allLength*100).toFixed(2)+'%';
    res.locals.baiduPercent = (baiduLength/allLength*100).toFixed(2)+'%';
    if (!querys) {
      try {
        let clues = await ClueList.all();
        if(res.locals.userInfo.role=='销售'){
          clues = await ClueList.all().where({'clues.salesman':res.locals.userInfo.name}).leftJoin('users','clues.salesman','=','users.name');
        }
        const users = await User.all();
        res.locals.users = users;
        clues.map((data) => {
          // let timeP = function (s) {
          //   return s < 10 ? '0' + s : s
          // };
          // let time = new Date(data.time)
          // timeObj = {
          //   'year': time.getFullYear(),
          //   'month': timeP(time.getMonth() + 1),
          //   'day': timeP(time.getDate()),
          //   'hour': timeP(time.getHours()),
          //   'min': timeP(time.getMinutes()),
          //   'sec': timeP(time.getSeconds()),
          // }
          // let chinaTime = timeObj.year + '-' + timeObj.month + '-' + timeObj.day + ' ' + timeObj.hour + ':' + timeObj.min + ':' + timeObj.sec;
          // data.time = chinaTime
          data.time = timeShift.formatTime(data.time)
        })
        res.locals.clues = clues;
        res.render('user/clueList.tpl', res.locals);
      } catch (e) {
        res.locals.error = e;
        res.render('error', res.locals);
      }
    } else if(id) {
      const records = await ClueManagement.all();
      res.locals.records = records;
      try {
        const records = await ClueList.all().where({ 'clues.ids': id }).leftJoin('cluemanage', 'clues.ids', '=', 'cluemanage.clue_id');
        console.log(records);
        records.map(data => {
          let time = new Date(data.time);
          data.time = (time.getFullYear() + '-' + parseInt(time.getMonth() + 1)) + '-' + time.getDate() + ' ' + time.getHours() + ':' + time.getMinutes() + ':' + time.getSeconds()
        });
        const users = await User.all();
        res.locals.users = users;
        res.locals.records = records;
        res.render('user/clueManagement.tpl', res.locals);
      } catch (e) {
        res.locals.error = e;
        res.render('error', res.locals);
      }
    }else if(name){
      const clues = await ClueList.select({name});
      clues.map((data) => {
        data.time = timeShift.formatTime(data.time)
      })
      res.locals.clues=clues;
      res.render('user/clueList.tpl',res.locals)
    }
  },
  delete: async function (req, res, next) {
    let id = req.body.id;
    if (!id) {
      res.json({ code: 0, data: 'params empty!' })
      return
    }
    try {
      const user = await ClueList.delete(id);
      res.json({ code: 200, data: user })
    } catch (e) {
      res.json({ code: 0, data: e })
    }
  },
  update: async function (req, res, next) {
    let id = req.body.clue_id;
    let role = req.body.salesman;
    if (!role) {
      const user = await ClueList.update(id, { role });
      res.json({ code: 200, data: user });
    }
    try {
      const user = await ClueList.update(id, { role });
      res.json({ code: 200, data: user });
    } catch (e) {
      res.json({ code: 0, data: e });
    }
  },
  // join: async function (req, res, next) {
  //   let id = req.body.id;
  //   if (!id) {
  //     res.json({ code: 0, data: 'params empty!' })
  //     return
  //   }
  //   try {
  //     const joinId = await ClueList.all().where({ 'clues.id': id }).leftJoin('cluemanage', 'clues.id', '=', 'cluemanage.clue_id');
  //     // res.redirect('/userBase/clueList/clueManagement');
  //     res.locals.joinId = joinId
  //     console.log(joinId);
  //     res.json({ code: 200, data: joinId })
  //   } catch (e) {
  //     console.log(e);
  //     res.json({ code: 0, data: e })
  //   }
  // }
}
module.exports = clueListController;