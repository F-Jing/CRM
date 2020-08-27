{% extends './../base.tpl' %}
{% block main %}
<div class="clue-manage-container">
  <div class="client-sidebar">
    <ul class="client-list">
      <li class="client-item">
        <span class="client-item-type">姓名：</span>
        <span class="client-item-name">{{records[0].clue_name}}</span>
      </li>
      <li class="client-item">
        <span class="client-item-type">电话：</span>
        <span class="client-item-phone">{{records[0].clue_phone}}</span>
      </li>
      <li class="client-item">
        <span class="client-item-type">来源：</span>
        <span class="client-item-source">{{records[0].utm_source}}</span>
      </li>
      <li class="client-item">
        <span class="client-item-type">预约时间：</span>
        <span class="client-item-time">{{records[0].time}}</span>
      </li>
    </ul>
  </div>
  <div class="record-section">
    <ul id="record-list">
      {% for val in records %}
      <li class="record-item">
        <p class="record-item-time">{{val.time}}</p>
        <p class="record-item-info">{{val.record}}</p>
      </li>
      {% endfor %}
    </ul>
    <div class="page-section">
      <div class="first-page">首页</div>
      <div class="previous-page">上一页</div>
      <ul class="page-list">
        <li class="page-item active">1</li>
        <li class="page-item">2</li>
        <li class="page-item">3</li>
      </ul>
      <div class="next-page">下一页</div>
      <div class="last-page">末页</div>
      <div class="all-page">共&nbsp;3&nbsp;页</div>
      <div class="present-page">当前<input class="present-page-number" value="1">页</div>
      <div class="sure-page">确定</div>
    </div>
  </div>
  <div class="salesman-sidebar">
    {% if userInfo.role === "销售" %}
    <p class="salesman">{{userInfo.name}}</p>
    {% endif %}
    {% if userInfo.role === "管理员" %}
    <select class="salesman-select">
      {% for val in users %}
      {% if val.role=="销售" %}
      <option>{{val.name}}</option>
      {% endif %}
      {% endfor %}
    </select>
    <button class="salesman-confirm-btn">分配</button>
    <button class="salesman-cancel-btn">取消分配</button>
    {% endif %}
  </div>
  {% if userInfo.role === "销售"  %}
  <div class="add-record-section">
    <textarea placeholder="请输入..." class="add-record-area"></textarea>
    <button class="add-record-btn">提交</button>
  </div>
  {% endif %}
</div>
{% endblock %}
{% block js %}
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
  const clueManagement = {
    data: {
      current: 1,
    },
    init: function () {
      this.showPage();
      this.bind();
    },
    bind: function () {
      $(document).on('click', '.add-record-btn', this.submit)
        .on('click', '.first-page', this.firstPage)
        .on('click', '.previous-page', this.previousPage)
        .on('click', '.page-item', this.pageItem)
        .on('click', '.next-page', this.nextPage)
        .on('click', '.last-page', this.lastPage)
        .on('click', '.sure-page', this.surePage)
        .on('click','.salesman-confirm-btn',this.salesmanConfirm)
        .on('click','.salesman-cancel-btn',this.salesmanCancel);
      // $('.add-record-btn').on('click', this.submit);
      // $('.first-page').on('click', this.firstPage);
      // $('.previous-page').on('click', this.previousPage);
      // $('.page-item').on('click', this.pageItem);
      // $('.next-page').on('click', this.nextPage);
      // $('.last-page').on('click', this.lastPage);
      // $('.sure-page').on('click', this.surePage);
    },
    submit: function () {
      let value = $('.add-record-area').val();
      let csrf = $('#csrf').val();
      let index = location.search.indexOf('=');
      let clue_id = location.search.substr(index+1);
      $.ajax({
        url: '/api/userBase/clueList/clueManagement',
        data: {
          value,
          csrf,
          clue_id
        },
        type: 'POST',
        success: function (data) {
          if (data.code === 200) {
            alert('提交成功！');
            location.reload();
          } else {
            console.log(data)
          }
        },
        error: function (e) {
          console.log(e)
        }
      })
    },
    showPage: function () {
      let current = clueManagement.data.current;
      let recordItem = $('.record-item');
      // if (recordItem.length == 0) {
      //   $('.record-section').hide();
      // }
      for (let i = 1; i <= recordItem.length; i++) {
        let everyPage = 3;
        let total = recordItem.length;
        let pageNum = Math.ceil(total / everyPage);
        console.log(pageNum);
        let nullArr = [];
        for (let j = 1; j <= pageNum; j++) {
          nullArr.push(j);
          let html = nullArr.map(j => {
            return `<li class="page-item ${j===current ? 'active' : ''}">${j}</li>`
          })
          $('.page-list').html(html)
        }
        $('.active').show();
        $('.active').prev().show();
        $('.active').next().show();
        $('.all-page').text('共 ' + pageNum + ' 页');
        let minItem = (current - 1) * everyPage;
        let maxItem = current * everyPage;
        $('.record-item').slice(minItem, maxItem).show();
        $('.record-item').slice(0, minItem).hide();
        $('.record-item').slice(maxItem, total).hide();
      }
    },
    firstPage: function () {
      clueManagement.data.current = 1;
      clueManagement.showPage();
    },
    previousPage: function () {
      if (clueManagement.data.current > 1) {
        --clueManagement.data.current
      }
      clueManagement.showPage();
    },
    pageItem: function () {
      clueManagement.data.current = Number($(this).text())
      clueManagement.showPage();
    },
    nextPage: function () {
      if (clueManagement.data.current < $('.page-item').length) {
        ++clueManagement.data.current
      }
      clueManagement.showPage();
    },
    lastPage: function () {
      clueManagement.data.current = $('.page-item').length;
      clueManagement.showPage();
    },
    surePage: function () {
      let value = $('.present-page-number').val();
      console.log(value);
      if (!value || value > $('.page-item').length) {
        return
      } else {
        clueManagement.data.current = Number(value);
      }
      clueManagement.showPage();
    },
    salesmanConfirm:function(){
      let salesman = $('.salesman-select').val();
      let csrf = $('#csrf').val();
      let index = location.search.indexOf('=');
      let clue_id = location.search.substr(index+1);
      $.ajax({
        url:'/api/userBase/clueList',
        data:{
          salesman,
          csrf,
          clue_id
        },
        type:'PUT',
        success:function(data){
          if(data.code===200){
            alert('分配成功！');
            location.reload();
          }else{
            console.log(data);
          }
        },
        error:function(e){
          console.log(e);
        }
      })
    },
    salesmanCancel:function(){
      let csrf = $('#csrf').val();
      let salesman = null;
      let index = location.search.indexOf('=');
      let clue_id = location.search.substr(index+1);
      $.ajax({
        url:'/api/userBase/clueList',
        data:{
          csrf,
          salesman,
          clue_id
        },
        type:'PUT',
        success:function(data){
          if(data.code===200){
            alert('已取消分配！');
          }else{
            console.log(data)
          }
        },
        error:function(e){
          console.log(e);
        }
      })
    }
  };
  $(function () {
    clueManagement.init();
  })
</script>
{% endblock %}