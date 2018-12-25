<%@page import="com.guestbook.adminGuestbookDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.connection.*" %>
<%@ page import="java.sql.*" %>
<%
	String path = request.getContextPath();
	/* 관리자 전용 페이지 */
	
	Object login = session.getAttribute("login");
	if(login==null){
		response.sendRedirect(path+"/views/login/loginfailform.jsp");
	}

	
	//글번호, 블라인드 값을 수신
	String gid = request.getParameter("gid");
	String blind = request.getParameter("blind");
	
	int result = 0;
	String txt = "";
	//데이터베이스 액션
	if(gid!=null) {
		adminGuestbookDAO dao = new adminGuestbookDAO();
		result = dao.blind(gid, Integer.parseInt(blind));
		
		if(result == 1) {
			txt = "success";
		}
		else {
			txt = "fail";
		}
	}
	
	
	//결과메시지 반환 및 페이지 이동
	response.sendRedirect(path + "/views/admin/adminbooklist.jsp?result="+txt);
%>
