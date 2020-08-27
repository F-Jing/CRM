{% extends './layout.tpl' %}
{% block css %}
<link rel="stylesheet" type="text/css" href="/stylesheets/login.css">
{% endblock %}
{% block content %}
<div class="login-section">
  <div class="login-cells">
    <h1>CRM客户管理系统</h1>
    <div class="login-cell">
      <input class="phone" type="phone" name="phone" placeholder="电话">
    </div>
    <div class="login-cell">
      <input class="password" type="password" name="password" placeholder="密码">
    </div>
    <div class="login-cell">
      <button class="submit">登录</button>
      <input type="text" name="csrf" class="csrf" value="{{csrf}}" hidden>
    </div>
  </div>
</div>
{% endblock %}
{% block js %}
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
  const PAGE = {
    init: function () {
      this.bind();
    },
    bind: function () {
      $('.submit').on('click', this.handleSubmit);
    },
    handleSubmit: function () {
      let phone = $('.phone').val();
      let password = $('.password').val();
      let csrf = $('.csrf').val();
      if (!phone || !password) {
        alert('params empty!')
        return
      }
      $.ajax({
        url: '/api/login',
        data: {
          phone,
          password,
          csrf
        },
        type: 'POST',
        success: function (data) {
          if (data.code === 200) {
            alert('登录成功！')
            location.reload()
          } else {
            console.log(data)
            alert(data.data.msg)
          }
        },
        error: function (e) {
          console.log(e)
        }
      })
    }
  }
  PAGE.init();
  $(function () {
    if (window.history && window.history.pushState) {
      $(window).on("popstate", function () {
        window.history.pushState("forward", null, "#");
        window.history.forward(1);
      });
    }
    window.history.pushState("forward", null, "#"); //在IE中必须得有这两行
    window.history.forward(1);
  });
</script>
{% endblock %}