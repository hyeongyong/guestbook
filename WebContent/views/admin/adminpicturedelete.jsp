<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.picture.*" %>
<%@ page import="java.util.*" %>
<%
	String path = request.getContextPath();
	
	String pid = request.getParameter("pid");

	Object login = session.getAttribute("login");
	/* 세션 저장소에 값이 없는 경우 null이 반환 된다. */
	if(login == null) {
		//로그인하지 못한 사용자 접근 차단
		//->로그인 폼 페이지로 강제 이동
		response.sendRedirect(path + "/views/login/loginfailform.jsp");
	}
	
	
	int result = 0;
	String txt = "";
	
	if(pid!=null){
		PictureDAO dao = new PictureDAO();
		result = dao.pictureRemove(new Picture(pid,null,null));
		
		if(result == 1) {
			txt = "success";
		} else {
			txt = "fail";
		}
	}
	
	//주의) 서버에 등록된 물리적 사진 삭제 필요!
	//--------------------------------------------	

	//결과메시지 반환 및 페이지 이동
	response.sendRedirect(path + "/views/admin/adminpicturelist.jsp?result="+txt);
%>
