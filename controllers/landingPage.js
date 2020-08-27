const clueListModels = require('./../models/clueList.js');
const ClueList = new clueListModels;
const landingPageController = {
  show: async function (req, res, next) {
    res.render('landingPage.tpl', res.locals)
  },
  insert: async function (req, res, next) {
    let clue_name = req.body.name;
    let phone = req.body.phone;
    let utm = req.body.utm;
    // console.log(ClueList.all().where({clue}))
    let index = utm.indexOf('=');
    let utm_source = utm.substr(index + 1);
    if (!/^[\u4E00-\u9FA5]{2,4}$/.test(clue_name) || !/^1[3456789]\d{9}$/.test(phone)) {
      res.json({ code: 0, data: "请按正确格式输入" });
      return
    }
    console.log(await ClueList.select({clue_phone: phone}))
    const user = await ClueList.select({clue_phone: phone})
    if (user.length > 0) {
      res.json({ code: 0, data: "该号码已预约" })
      return
    }
    try {
      await ClueList.insert({ clue_name, clue_phone:phone, utm_source })
      res.json({ code: 200, data: '预约成功' });
    } catch (e) {
      console.log(e)
      res.json({ code: 0, data: e });
    }
  },
}
module.exports = landingPageController;