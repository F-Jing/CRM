var express = require('express');
var router = express.Router();
var userController = require('./../controllers/user');
var landingPageController = require('./../controllers/landingPage');
var csrf = require('./../middlewares/csrf.js');
var authController = require('./../controllers/auth.js');
const clueListController = require('../controllers/clueList.js');
const clueManagementController = require('../controllers/clueManagement.js')
router.post('/login', csrf.getToken, authController.login);
router.post('/userBase/userManagement/add', csrf.getToken, userController.insert);
router.put('/userBase/userManagement', csrf.getToken, userController.update);
router.delete('/userBase/userManagement', csrf.getToken, userController.delete);
router.post('/userBase/userManagement', csrf.getToken,userController.show);
router.post('/landingPage',csrf.getToken,landingPageController.insert);
router.delete('/userBase/clueList',csrf.getToken,clueListController.delete);
// router.insert('/userBase/clueList',csrf.getToken,clueListController.insert);
router.put('/userBase/clueList',csrf.getToken,clueListController.update);
// router.post('/userBase/clueList',csrf.getToken,clueListController.join);
router.post('/userBase/clueList/clueManagement',csrf.getToken,clueManagementController.insert);
// router.put('/userBase/clueList/allocation',csrf.getToken,clueListController.update);
// router.post('userBase/userManagement/:ID', csrf.setToken, userController.search);
module.exports = router;
