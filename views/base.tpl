{% extends './layout.tpl' %}
<title>{{ title }}</title>
{% block css %}
<link rel="stylesheet" href="/stylesheets/base.css">
{% endblock %}
{% block content %}
<div class="nav-section">
  <p class="title">{{ title }}</p>
  <ul class="nav-list">
    {% if userInfo.role === '管理员' %}
    <li class="nav-item">
      <a href="/userBase/userManagement" class="user-manage">用户管理</a>
    </li>
    {% endif %}
    <li class="nav-item">
      <a href="/userBase/clueList" class="clue-list">线索列表</a>
    </li>
  </ul>
  <div class="csrf-container">
    <input type="text" name="csrf" id="csrf" value="{{csrf}}" hidden>
  </div>
</div>
<div class="user-section">
  <img class="user-icon" src="/images/user-line.png">&nbsp;&nbsp;
  <p class="user">你好,&nbsp;</p>
  <p class="user-link">{{ userInfo.name }}({{ userInfo.role }})</p>
  &nbsp;&nbsp;
  <span class="user-border"></span>&nbsp;&nbsp;
  <a href="/logout" class="logout">退出</a>
</div>
{% block main %}
{% endblock %}
<!-- <iframe class="iframe" marginwidth="20px" marginheight="20px" scrolling="no" frameborder="0" style="width:100%;height:100%" src="./userManagement"></iframe> -->
{% endblock %}
{% block js %}
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
  const indexPage = {
    init: function () {
      this.bind();
      this.highlight();
    },
    bind: function () {
      $('.logout').on('click', this.logout);
      // $('.user-manage').on('click', this.userList);
      // $('.clue-list').on('click', this.clueList);
      // $('.clue-track').on('click', this.clueTrack);
    },
    logout: function () {
      // let ac = indexPage.getCookie("ac")
      $.ajax({
        type: 'GET',
        data: {
          csrf,
          // ac
        },
        url: '/logout',
        success: function (data) {
          if (data.code === 200) {
            location.reload()
          } else {
            console.log(data, 11111)
          }
        },
        error: function (err) {
          console.log(err)
        }
      })
    },
    highlight: function () {
      $('.nav-item>a').each(function () {
        if ($(this)[0].href == String(window.location)) {
          $(this).parent().addClass('current')
        } else {
          $(this).parent().removeClass('current')
        }
      })
    }
    // userList: function () {
    //   // $('.iframe').attr('src','./userManagement.tpl');
    //   $(this).parent().addClass('current').siblings().removeClass('current');
    // },
    // clueList: function () {
    //   // $('.iframe').attr('src','./clueList.tpl');
    //   $(this).parent().addClass('current').siblings().removeClass('current');
    // },
    // clueTrack: function () {
    //   // $('.iframe').attr('src','./clueTrack.tpl');
    //   $(this).parent().addClass('current').siblings().removeClass('current');
    // }
  };
  $(function () {
    let url = 'http://localhost:3000/userBase/userManagement';
    let re = new RegExp("^"+url)
    if (re.test(window.location.href)) {
      $('.nav-list .nav-item:nth-child(1)>a').addClass('current')
    }
    indexPage.init();
  });
</script>
{% block mainJs %}
{% endblock %}
{% endblock %}