<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.guestbook.*" %>
<%@ page import="java.util.*" %>
<%
	//방명록 글삭제 액션 구현
	request.setCharacterEncoding("UTF-8");
	String path = request.getContextPath();

	String gid = request.getParameter("gid");
	String pw = request.getParameter("pw");
	
	int result = 0;
	String txt = "";
	
	if(gid != null) {
		GuestbookDAO dao = new GuestbookDAO();
		result = dao.delete(gid, pw);
		
		if(result==1) {
			txt = "success";
		} else {
			txt = "fail";
		}
	}
	
	response.sendRedirect(path + "/index.jsp?result=" + txt);

%>
