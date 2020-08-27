{% extends './../base.tpl' %}
{% block main %}
<div class="search-update">
  <div class="form">
    <input class="form-search" type="text" placeholder="请输入用户名">
    <button class="form-btn">搜索</button>
  </div>
  <button class="new-user-btn">添加新用户</button>
  <input type="text" name="name" class="new-name" placeholder="请输入用户名">
  <input type="tel" name="phone" class="new-phone" placeholder="请输入手机号码">
  <input type="text" name="password" class="new-password" placeholder="请输入密码" value="123">
  <input type="text" name="role" class="new-role" placeholder="请输入角色" value="销售">
  <button class="new-sure">确定</button>
</div>
<div class="clear-fixed"></div>
<div class="user-manage-section">
  <ul class="user-list">
    <div class="user-manage-head">
      <span class="user-head-id">id</span>
      <span class="user-head-name">姓名</span>
      <span class="user-head-phone">电话</span>
      <span class="user-head-password">密码</span>
      <span class="user-head-role">角色</span>
      <span class="user-head-operation">操作</span>
    </div>
    {% for val in users %}
    <li class="user-item">
      <span class="user-id">{{val.id}}</span>
      <span class="user-name">{{val.name}}</span>
      <span class="user-phone">{{val.phone}}</span>
      <span class="user-password">{{val.password}}</span>
      <span class="user-role">{{val.role}}</span>
      <div class="user-operation">
        <button class="update-user" data-id="{{val.id}}">编辑</button>
        {% if val.role!=="管理员" %}
        <button class="delete-user" data-id="{{val.id}}">删除</button>
        {% endif %}
      </div>
    </li>
    {% endfor %}
  </ul>
</div>
{% endblock %}
{% block mainJs %}
<script type="text/javascript">
  const userManagement = {
    init: function () {
      this.bind()
    },
    bind: function () {
      $('.new-sure').on('click', this.newUser);
      $('.update-user').on('click', this.update);
      $('.delete-user').on('click', this.delete);
      $('.new-user-btn').on('click', this.newToggle);
      $('.form-btn').on('click', this.formSearch);
      $('body').on('click', '.update-confirm', this.updateConfirm);
    },
    update: function () {
      $('.user-list').css("color", "rgba(127,127,127,0.5)");
      let id = $(this).data('id');
      let $parent = $(this).parent();
      let name = $parent.siblings('.user-name').text();
      let phone = $parent.siblings('.user-phone').text();
      let password = $parent.siblings('.user-password').text();
      let role = $parent.siblings('.user-role').text();
      let html = '<span class="user-id">' + id + '</span>' +
        '<textarea class="user-name">' + name + '</textarea>' +
        '<textarea class="user-phone">' + phone + '</textarea>' +
        '<textarea class="user-password">' + password + '</textarea>' +
        '<select class="user-role">' + '<option>销售</option>' + '<option>管理员</option>' + '</select>' +
        '<div class="user-operation">' + '<button class="update-confirm" data-id="' + id + '">完成</button>' +
        '</div>';
      $(this).parent().parent().html(html)
    },
    updateConfirm: function () {
      let id = $(this).data('id');
      let csrf = $('#csrf').val();
      let $parent = $(this).parent();
      let name = $parent.siblings('.user-name').val();
      let phone = $parent.siblings('.user-phone').val();
      let password = $parent.siblings('.user-password').val();
      let role = $parent.siblings('.user-role').val();
      $.ajax({
        url: '/api/userBase/userManagement',
        data: {
          id,
          csrf,
          name,
          phone,
          password,
          role
        },
        type: 'PUT',
        success: function (data) {
          if (data.code === 200) {
            location.reload()
          } else {
            console.log(data)
          }
        },
        error: function (e) {
          console.log(e)
        }
      })
    },
    delete: function () {
      let id = $(this).data('id');
      let csrf = $('#csrf').val();
      $.ajax({
        url: '/api/userBase/userManagement',
        data: {
          id,
          csrf
        },
        type: 'DELETE',
        success: function (data) {
          if (data.code === 200) {
            alert('删除成功！')
            location.reload()
          } else {
            console.log(data)
          }
        },
        error: function (err) {
          console.log(err)
        }
      })
    },
    newUser: function (e) {
      let name = $('.new-name').val();
      let phone = $('.new-phone').val();
      let password = $('.new-password').val();
      let csrf = $('#csrf').val();
      let role = $('.new-role').val();
      if (!name || !phone || !password || !role) {
        alert('缺少参数');
        return
      }
      if (!(/^1[3456789]\d{9}$/.test(phone))) {
        alert('请输入正确手机号');
        return
      }
      $.ajax({
        url: '/api/userBase/userManagement/add',
        data: {
          name,
          phone,
          password,
          role,
          csrf
        },
        type: 'POST',
        success: function (data) {
          if (data.code === 200) {
            alert('新增成功！')
            location.reload()
          } else {
            console.log(data)
          }
        },
        error: function (err) {
          console.log(err)
        }
      })
    },
    // getCookie: function (name) {
    //   let allCookies = document.cookie;
    //   let cookie_pos = allCookies.indexOf(name);
    //   if (!cookie_pos) {
    //     cookie_pos = cookie_pos + name.length + 1;
    //     let cookie_end = allCookies.indexOf(';', cookie_pos);
    //     if (cookie_end == -1) {
    //       cookie_end = allCookies.length;
    //     }
    //     var value = unescape(allCookies.substring(cookie_pos, cookie_end))
    //   }
    //   return value;
    // },
    newToggle: function () {
      $('.new-user-btn~input').stop().toggle(500);
      $('.new-user-btn~button').stop().toggle(500)
    },
    addURLParam: function (url, name, value) {
      url += (url.indexOf("?") == -1 ? "?" : "&");
      url += encodeURIComponent(name) + "=" + encodeURIComponent(value);
      return url;
    },
    formSearch: function (e) {
      let value = $('.form-search').val();
      let csrf = $('#csrf').val();
      let url = '/api/userBase/userManagement';
      url = userManagement.addURLParam(url, 'name', value);
      if (value || value === 0) {
        location.assign(url.substr(4))
      } else {
        location.assign('/userBase/userManagement')
      }
      $.ajax({
        url: '/api/userBase/userManagement',
        data: {
          value,
          csrf,
          url
        },
        type: 'POST',
        success: function (data) {
          if (data.code === 200) {
            alert('成功')
            location.assign(url.substr(4));
            // location.reload();
            // window.location.assign('http://localhost:3001/userBase/userManagement/search')
          } else {
            console.log(data)
          }
        },
        error: function (err) {
          console.log(err)
        }
      })
    }
  };
  $(function () {
    userManagement.init();
  })
</script>
{% endblock %}