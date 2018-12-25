<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.login.*" %>
<%@ page import="java.util.*" %>
<%
	String path = request.getContextPath();

	session.invalidate();
	response.sendRedirect(path + "/views/login/logoutform.jsp");
%>
