{% extends './../base.tpl' %}
{% block main %}
<!-- <div class="pop-up-bg"></div> -->
<div class="search-update">
  <div class="form">
    <input class="form-search" type="text" placeholder="请输入用户名">
    <button class="form-btn">搜索</button>
  </div>
  {% if userInfo.role === "管理员" %}
  <span class="not-allocation">未分配</span>
  <p class="sougo">sougo:</p>
  <p class="sougo-percent">{{sougoPercent}}</p>
  <p class="baidu">baidu:</p>
  <p class="baidu-percent">{{baiduPercent}}</p>
  {% endif %}
</div>
<div class="clear-fixed"></div>
<div class="user-manage-section">
  <ul class="user-list">
    <div class="user-manage-head">
      <span class="user-head-name">姓名</span>
      <span class="user-head-phone">电话</span>
      <span class="user-head-channel">来源</span>
      <span class="user-head-time">时间</span>
      {% if userInfo.role=="管理员" %}
      <span class="user-head-salesman">销售</span>
      {% endif %}
      <!-- <span class="user-head-state">状态</span> -->
      <span class="user-head-operation">操作</span>
    </div>
    {% for val in clues %}
    <li class="user-item">
      <span class="user-name">{{val.clue_name}}</span>
      <span class="user-phone">{{val.clue_phone}}</span>
      <span class="user-channel">{{val.utm_source}}</span>
      <span class="user-time">{{val.time}}</span>
      {% if userInfo.role=="管理员" %}
      <span class="user-salesman">{{val.salesman}}</span>
      {% endif %}
      <!-- <span class="user-state"></span> -->
      <div class="user-operation">
        <button class="edit" data-id="{{val.ids}}">编辑</button>
        {% if userInfo.role=="管理员" %}
        <button class="delete-user" data-id="{{val.id}}">删除</button>
      </div>
      {% endif %}
    </li>
    {% endfor %}
  </ul>
</div>
<!-- <div class="allocation-section">
  <select class="allocation-select">
    {% for val in users %}
    {% if val.role=="销售" %}
    <option>{{val.name}}</option>
    {% endif %}
    {% endfor %}
  </select>
  <button class="allocation-confirm">确定</button>
  <button class="allocation-cancel">取消</button>
</div> -->
<!-- <iframe class="allocation-iframe" width="310px" height="410px" src="/userBase/clueList/allocation" scrolling="no"
  frameborder="0"></iframe> -->
{% endblock %}
{% block mainJs %}
<script type="text/javascript">
  const clueList = {
    init: function () {
      this.bind();
    },
    bind: function () {
      $(document).on('click', '.edit', this.edit);
      // $('.delete-user').on('click', this.delete);
      $('.edit').on('click', this.edit);
      $('.form-btn').on('click', this.formSearch);
      $('.not-allocation').on('click',this.notAllocation);
      // $('.allocation').on('click', this.allocation);
      // $('.allocation-confirm').on('click', this.allocationConfirm);
      // $('.allocation-cancel').on('click', this.allocationCancel);
    },
    delete: function () {
      let id = $(this).data('id');
      let csrf = $('#csrf').val();
      $.ajax({
        url: '/api/userBase/clueList',
        type: 'DELETE',
        data: {
          id,
          csrf
        },
        success: function (data) {
          if (data.code === 200) {
            alert('删除成功！');
            location.reload();
          } else {
            console.log(data);
          }
        },
        error: function (e) {
          console.log(e)
        }
      })
    },
    addURLParam: function (url, name, value) {
      url += (url.indexOf("?") == -1 ? "?" : "&");
      url += encodeURIComponent(name) + "=" + encodeURIComponent(value);
      return url;
    },
    edit: function () {
      let url = location.href;
      let id = $(this).data('id');
      url = clueList.addURLParam(url, "ID", id);
      console.log(url)
      location.assign(url);
      // let id = $(this).data('id');
      // let csrf = $('#csrf').val();
      // let url = '/api/userBase/userManagement';
      // url = userManagement.addURLParam(url, 'name', value);
      // if(value || value === 0){
      //   location.assign(url.substr(4))
      // }else{
      //   location.assign('/userBase/userManagement')
      // }
      // $.ajax({
      //   url: '/api/userBase/clueList',
      //   type: 'GET',
      //   data: {
      //     id
      //   },
      //   success: function (data) {
      //     if (data.code === 200) {
      //       // location.assign('/userBase/clueList/clueManagement');
      //       // console.log(data)
      //     } else {
      //       console.log(data)
      //     }
      //   },
      //   error: function (e) {
      //     console.log(e)
      //   }
      // })
    },
    formSearch: function () {
      let value = $('.form-search').val();
      let csrf = $('#csrf').val();
      let url = location.href;
      console.log(url);
      url = clueList.addURLParam(url, "name", value);
      if (!value) {
        url = url.split("?")[0];
        console.log(url);
        location.assign(url)
      } else {
        location.assign(url);
      }
    },
    notAllocation:function(){
        $('.user-salesman').each(function(){
          if($(this).text()==null || $(this).text().length==0){
            $(this).parent().show()
          }else{
            $(this).parent().hide()
          }
        })
    }
    // allocation: function () {
    //   id = $(this).data('id');
    //   $('.allocation-section').show();
    //   $('.pop-up-bg').show();
    // },
    // allocationConfirm: function () {
    //   let role = $('.allocation-select').val();
    //   console.log(role,id);
    //   let csrf = $('#csrf').val();
    //   $.ajax({
    //     url: '/api/userBase/clueList',
    //     data: {
    //       role,
    //       csrf,
    //       id
    //     },
    //     type: 'PUT',
    //     success: function (data) {
    //       if (data.code === 200) {
    //         alert('分配成功！');
    //         location.reload();
    //       } else {
    //         console.log(data);
    //       }
    //     },
    //     error: function (e) {
    //       console.log(e)
    //     }
    //   })
    // },
    // allocationCancel: function () {
    //   $('.allocation-section').hide();
    //   $('.pop-up-bg').hide();
    // }
  };
  $(function () {
    clueList.init();
  })
</script>
{% endblock %}