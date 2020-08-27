{% extends './layout.tpl' %}
{% block css %}
<link type="text/css" rel="stylesheet" href="/stylesheets/landingPage.css">
{% endblock %}
{% block content %}
<div class="appointment-section">
  <div class="appointment-cells">
    <div class="appointment-cell">
      <input class="name" type="text" name="name" placeholder="姓名">
      <span class="name-hint">用户名由2~4位中文字符组成</span>
    </div>
    <div class="appointment-cell">
      <input class="phone" type="phone" name="phone" placeholder="电话">
      <span class="phone-hint">手机号码格式不正确</span>
    </div>
    <div class="appointment-cell">
      <button class="submit">立即预约</button>
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
      $('.submit').on('click', this.debounce(this.submit,2000));
      $('.name').on('blur', this.name);
      $('.phone').on('blur', this.phone);
    },
    submit: function () {
      let name = $('.name').val();
      let phone = $('.phone').val();
      let csrf = $('.csrf').val();
      let utm = location.search;
      $.ajax({
        url: '/api/landingPage',
        data: {
          name,
          phone,
          csrf,
          utm
        },
        type: 'POST',
        success: function (data) {
          console.log(data)
          if (data.code === 200) {
            alert('预约成功');
            location.reload();
          } else {
            alert(data.data);
          }
        },
        error: function (e) {
          console.log(e);
        }
      })
    },
    debounce: function (func, wait) {
      let timeout;
      return function () {
        let context = this;
        let args = arguments;
        if (timeout) {
          clearTimeout(timeout);
        }
        timeout = setTimeout(() => {
          func.apply(context, args)
        }, wait);
      }
    },
    name: function () {
      let name = $('.name').val();
      if (/^[\u4E00-\u9FA5]{2,4}$/.test(name)) {
        $(this).next().hide();
      } else {
        $(this).next().show();
      }
    },
    phone: function () {
      let phone = $('.phone').val();
      if (/^1[3456789]\d{9}$/.test(phone)) {
        $(this).next().hide();
      } else {
        $(this).next().show();
      }
    }
  }
  PAGE.init();
</script>
{% endblock %}