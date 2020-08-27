const clueManagementModels = require('./../models/clueManagement');
const ClueManagement = new clueManagementModels;
const clueManagementController = {
  // show: async function (req, res, next) {
  //   if (!res.locals.isLogin) {
  //     res.redirect('/login');
  //     return
  //   }
  //   try {
  //     const records = await ClueManagement.all();
  //     console.log(records);
  //     res.locals.records = records;
  //     res.render('user/clueManagement.tpl', res.locals);
  //   } catch (e) {
  //     res.locals.error = e;
  //     res.render('error', res.locals);
  //   }
  // },
  insert:async function(req,res,next){
    let clue_id = req.body.clue_id;
    let record = req.body.value;
    if(!record){
      res.json({code:0,data:'params empty!'})
      return;
    }
    try{
      const records = await ClueManagement.insert({record,clue_id});
      res.json({code:200,data:records})
    }catch(e){
      res.json({code:0,data:e});
    }
  }
  // join: async function (req, res, next) {
  //   clue_id = req.body.id
  //   if (!clue_id) {
  //     res.json({ code: 0, data: 'params empty!' })
  //     return
  //   }
  //   try {
  //     const user = await ClueManagement.all().where({clue_id}).join('clues','cluemanage.clue_id','=','clues.id')
  //     res.redirect('/userBase/clueList/clueManagement');
  //     res.json({ code: 200, data: user })
  //   } catch (e) {
  //     res.json({ code: 0, data: e })
  //   }
  // }
}
module.exports = clueManagementController