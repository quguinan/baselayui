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
    <title>系统菜单维护</title>
	<jsp:include page="../../inc/injs.jsp"/> 
	<script type="text/javascript"> 

		
	</script>
  </head>
   
  <body>
	
	系统菜单维护
  </body>
</html>
