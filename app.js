var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var nunjucks = require('nunjucks');
var indexRouter = require('./routes/index');
var apiRouter = require('./routes/api')
var session = require('express-session');
var favicon = require('serve-favicon');
var bodyParser = require('body-parser');
const filters = require('./filters/index');
var app = express();
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'tpl');
app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(session({
  secret: 'abc',
  resave: true,
  saveUninitialized: true
}));
nunjucks.configure('views', {
  autoescape: true,
  express: app,
  watch: true
});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }))
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
filters(app);
app.use('/', indexRouter);
app.use('/api', apiRouter);
app.use(function (req, res, next) {
  next(createError(404));
});
app.use(function (err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
  res.status(err.status || 500);
  res.render('error');
});
module.exports = app;
