<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>用户信息维护</title>
    <style>
    	.layui-table-cell {            overflow: visible !important;        } 
		td .layui-form-select{
			margin-top: -8px;
			margin-left: -15px;
			margin-right: -15px;
		} 
		
    </style>
	<jsp:include page="../../inc/injs.jsp"/> 
	
	<script type="text/javascript">
	
		layui.use(['table','layer', 'form', 'element','upload','laydate'], function(){
			 var table = layui.table
			 ,layer = layui.layer
			 ,form = layui.form
			 ,element = layui.element
			 ,laydate = layui.laydate
			 ,upload = layui.upload; //获取upload模块
			//权限 
			var roleidOptions = "<option value=''>请选择</option>\n";
			
			/* 表单中的list */
			$.ajax({
				url: WEB_ROOT+'/cms/rolemenu/findRoles',
				dataType: 'json',
				//data:{'state': 0},	//查询状态为正常的所有机构类型
				type: 'post',
				success: function (result) {
					$.each(result.rows, function (index, item) {
						//$('#roleid').append(new Option(item.rolename, item.roleid));// 下拉菜单里添加元素
						$('#roleid').append("<option value='" + item.roleid + "'>" + item.rolename + "</option>");
						
						roleidOptions += "<option value='" + item.roleid + "'>" + item.rolename + "</option>\n";
					});
				},
				complete:function(){
					form.render('select','role_filter');//延迟渲染
				}
			});
			 

			 //第一个实例
			 var dg = table.render({
			    elem: '#dg'
			    ,height: 'full-20'
			    ,url: WEB_ROOT+'/cms/user/gridData' //数据接口
			    ,page: true //开启分页
			    ,limit:10
			    ,toolbar:  '#toolbar'
			    ,defaultToolbar: ['filter', 'print', 'exports']
			    ,cols: [[ //表头
			      {field: 'userid', title: 'ID', width:80, sort: true}
			      ,{field: 'username', title: '用户名', width:120, edit: 'text'}
			      ,{field: 'realname', title: '登录名', width:120, sort: true, edit: 'text'}
			      ,{field: 'password', title: '密码', width:350, edit: 'text'} 
			      ,{field: 'roleid', title: '权限ID', width: 220, templet:"#roleSelect"}
			      ,{field: 'rolename', title: '权限名称', width: 120, sort: true, edit: 'text'}
			    ]]
			 	,done:function(res,curr,count){
			 		//alert(JSON.stringify(res))
			 		//alert(curr)
			 		//alert(count)
			 		table.render('select','role_select');//延迟渲染
			 		
			 		$("select[name='roleid1']").html(roleidOptions);
	               layui.each($("select[name='roleid1']"), function (index, item) {
	                   var elem = $(item);
	                   elem.val(elem.data('value'));
	               });
	 
	               form.render('select');
			 	},
			 	
			 });
			 var saveDataAry=[]; 
			//监听单元格编辑
		      table.on('edit(dg)', function (obj) {
	             var value = obj.value;//修改后的数据
	             var field = obj.field;//修改的字段名
	             var data = obj.data;//修改的当行数据
	             console.log(data);
	             console.log(value);
	             console.log(field);
	             saveDataAry.push(data);
		      });
			//监听事件
			table.on('toolbar(dg)', function(obj){
				//var checkStatus = table.checkStatus(obj.config.id);
				//data = checkStatus.data; //获取选中的数据
					switch(obj.event){
						case 'add':
							layer.msg('添加');
							break;
						case 'del':
							layer.msg('删除');
							break;
						case 'save':
							layer.msg('保存');
							if(saveDataAry.length > 0){
								$.ajax({ 
						            type:"POST", 
						            url:WEB_ROOT+'/cms/user/updateUser', 
						            dataType:"json",      
						            contentType:"application/json",               
						            data:JSON.stringify(saveDataAry), 
						            error: function (data){
						            	layer.msg("加载失败，请重新加载");
						            },
						            success:function(data){ 
						                if(data.success){
						                	layer.msg(data.msg);
						                }else{
						                	layer.msg(data.msg);
						                }
						                saveDataAry=[];
						            } 
						         });
							}else{
								layer.msg('请确认修改内容');
							}
							
							break;
						case 'query':
							layer.msg('查询');
							break;
					};
			});
			
			
			
			//执行一个laydate实例
            laydate.render({
                elem: '#start' //指定元素
            });

            //执行一个laydate实例
            laydate.render({
                elem: '#end' //指定元素
            });
		});
    </script>
  </head>
  
  <body>
  	
  	<script type="text/html" id="toolbar">
		
		<form class="layui-form layui-col-space5">
			<div class="layui-input-inline layui-show-xs-block">
        		<input class="layui-input" placeholder="开始日" name="start" id="start">
			</div>
        	<div class="layui-input-inline layui-show-xs-block">
        		<input class="layui-input" placeholder="截止日" name="end" id="end">
			</div>
			<div class="layui-input-inline layui-show-xs-block">
				<input type="text" name="title" required  lay-verify="required" placeholder="请输入登录名" autocomplete="off" class="layui-input">
			</div>
			<div class="layui-input-inline layui-show-xs-block">
				<div class="layui-input-inline"  lay-filter="role_filter">
      				<select name="roleid"  id="roleid" >
						<option value="">请选择</option>
					</select>
    			</div>
			</div>
		</div>

  		<div>
    		<button class="layui-btn" lay-event="query">查询</button>
    		<button class="layui-btn" lay-event="add">新增</button>
    		<button class="layui-btn" lay-event="del">删除</button>
    		<button class="layui-btn" lay-event="save">保存</button>
  		</div>
	</script>
	
 	<script type="text/html" id="roleSelect">
		<select name="roleid1" lay-filter="roleid1" data-value="{{d.roleid}}">
 
    	</select>
	</script>

  	<table id="dg" lay-filter="dg" ></table>
  </body>
</html>
