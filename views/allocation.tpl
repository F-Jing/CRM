{% extends './layout.tpl' %}
{% block css %}
<link type="text/css" rel="stylesheet" href="/stylesheets/allocation.css">
{% endblock %}
{% block content %}
<div class="allocation-section">
  <select class="allocation-select">
    {% for val in users %}
    {% if val.role=="销售" %}
      <option>{{val.name}}</option>
    {% endif %}
    {% endfor %}
  </select>
  <button class="allocation-btn">确定</button>
</div>
{% endblock %}
{% block js %}
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
  const PAGE={
    init:function(){
      this.bind();
    },
    bind:function(){
      $('.allocation-btn').on('click',this.allocation);
    },
    allocation:function(){
      let role = $('.allocation-select').val();
      let id = $('.allocation',window.parent.document).html();
      let csrf = $('#scrf',window.parent.document).html();
      $.ajax({
        url:'/api/userBase/clueList/allocation',
        data:{
          role,
          csrf
        },
        type:'PUT',
        success:function(data){
          if(data.code===200){
            alert('分配成功！');
            // location.reload();
          }else{
            console.log(data);
          }
        },
        error:function(e){
          console.log(e)
        }
      })
    }
  }
</script>
{% endblock %}