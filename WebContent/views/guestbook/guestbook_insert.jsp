<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.guestbook.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	String path = request.getContextPath();

	String name_=request.getParameter("name_");
	String pw=request.getParameter("pw");
	String content=request.getParameter("content");
	String clientIP=request.getRemoteAddr();
	
	
	int result = 0;
	String txt = "";
	
	if(name_ != null) {
		GuestbookDAO dao = new GuestbookDAO();
		result = dao.insert(new Guestbook(name_, pw, content, clientIP));
		
		if(result == 1) {
			txt="success";
		} else {
			txt="fail";
		}
		
	}  
	
	response.sendRedirect(path + "/index.jsp?result="+txt);
%>
