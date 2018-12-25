<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.login.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String path = request.getContextPath();
	
	String id_ = request.getParameter("id_");
	String pw = request.getParameter("pw");
	
	LoginDAO dao = new LoginDAO();
	Login result = dao.login(id_, pw);
	
	if(result == null) {
		response.sendRedirect(path+"/views/login/loginfailform.jsp");
	} else {
		session.setAttribute("login", result);
		response.sendRedirect(path + "/views/admin/adminbooklist.jsp");
	}
%>
