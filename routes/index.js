var express = require('express');
var router = express.Router();
var userController = require('./../controllers/user.js');
var csrf = require('./../middlewares/csrf.js');
var authController = require('./../controllers/auth.js');
var clueListController = require('./../controllers/clueList.js');
// var clueManagementController = require('./../controllers/clueManagement.js')
var landingPageController = require('./../controllers/landingPage.js');
// var allocationController = require('./../controllers/allocation.js');
router.get('/login', csrf.setToken, authController.renderLogin);
router.get('/userBase/userManagement', csrf.setToken, userController.show);
// let url ='userBase/userManagement?name='
// let urlReg = new RegExp("^"+url+"[.]+");
// router.get('/userBase/userManagement?name=1', csrf.setToken, userController.showSearch);
router.get('/userBase/clueList', csrf.setToken, clueListController.show);
// router.get('/userBase/clueList', csrf.setToken, clueManagementController.show);
router.get('/logout', authController.renderLogout);
router.get('/landingPage', csrf.setToken, landingPageController.show);
// router.get('/userBase/clueList/allocation', csrf.setToken, allocationController.show);
module.exports = router;
