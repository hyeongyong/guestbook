<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.picture.*, java.util.*, com.login.*" %>
<%
	String path = request.getContextPath();
	
	/* 관리자 전용 페이지 */
	
	Object login = session.getAttribute("login");
	String info= "";
	/* 세션 저장소에 값이 없는 경우 null이 반환 된다. */
	if(login == null) {
		//로그인하지 못한 사용자 접근 차단
		//->로그인 폼 페이지로 강제 이동
		response.sendRedirect(path + "/views/login/loginfailform.jsp");
	} else {
		info = ((Login)login).getId_();
	}
	
	PictureDAO dao = new PictureDAO();
	List<Picture> pictureList = dao.pictureList();
	int pictureCount = pictureList.size();
	StringBuilder sb01 = new StringBuilder();
	
	for(int a=0; a<pictureCount; ++a){
		Picture p = pictureList.get(a);
		sb01.append(String.format("<div class='col-md-3'>"));
		sb01.append(String.format("<div class='thumbnail'>"));
		sb01.append(String.format("<img src=\"%s/resources/picture/%s\" alt='%s' style='width:100%%'>",
				path, p.getFilename(), p.getContent()));
		sb01.append(String.format("<div class='caption'>"));
		
		/* 이미지 파일 및 정보 삭제를 위한 삭제버튼 추가 */
		sb01.append(String.format("<p>%s<button type=\"button\" class=\"close btnDel\" value=\"%s\">&times;</button></p>", p.getContent(), p.getPid()));
		
		sb01.append(String.format("</div>"));
		sb01.append(String.format("</div>"));
		sb01.append(String.format("</div>"));
		
		//크기가 제각각인 사진인 경우에도 한 줄에 4개씩 출력되도록
		if ((a+1)%4 == 0) {
			sb01.append("</div><div class=\"row\"");
		}
	}
	
	String result = request.getParameter("result");
	String txt = "";
	if (result != null) {
		if (result.equals("success")) {
			//성공 메시지
			txt = "<div class=\"alert alert-success alert-dismissible fade in\" style=\"padding-top: 5px; padding-bottom: 5px; margin-top: 5px; margin-bottom: 5px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Success!</strong> 요청한 작업이 처리되었습니다.</div>";
		} else {
			//실패 메시지
			txt = "<div class=\"alert alert-danger alert-dismissible fade in\" style=\"padding-top: 5px; padding-bottom: 5px; margin-top: 5px; margin-bottom: 5px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Fail!</strong> 요청한 작업이 처리되지 못했습니다.</div>";
		}
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1">

<title>쌍용교육센터</title>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<style>
div#input:hover, div#output:hover {
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.19);
}
</style>

<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<script>
	$(document).ready(function() {
		$(".btnDel").on("click", function(){
			var txt = "삭제하시겠습니까?";
			if(confirm(txt)){
				window.location.assign("<%=path%>/views/admin/adminpicturedelete.jsp?pid="+$(this).val());
			}
		});
		
	});
</script>
</head>
<body>

	<div class="container">

		<div class="panel page-header" style="text-align: center;">
			<h1 style="font-size: xx-large;">
				<a href="adminbooklist.jsp"><img
					src="<%=path%>/resources/img/sist_logo.png" alt="sist_logo.png"></a> 방명록 <small>v1.0</small>
				<span style="font-size: small; color: #777777;"></span>
			</h1>
		</div>
		<span><%=txt%></span>

		<nav class="navbar navbar-default" id="input">
			<div class="container-fluid">
				<div class="navbar-header"></div>
				<ul class="nav navbar-nav">
					<li><a href="<%=path%>/views/admin/adminbooklist.jsp">방명록 관리</a></li>
					<li class="active"><a href="<%=path%>/views/admin/adminpicturelist.jsp">사진 관리</a></li>
					<li><a href="<%=path%>/views/login/admin_logout.jsp">[관리자/<%=info%>]로그 아웃 </a></li>
				</ul>
			</div>
		</nav>

		<div class="panel panel-default" id="input">
			<div class="panel-heading">사진 업로드</div>
			<div class="panel-body">
				<form action="<%=path%>/views/admin/adminpictureinsert.jsp" method="post"
					enctype="multipart/form-data">

					<div class="form-group">
						<input type="text" class="form-control" id="content"	
							name="content" placeholder="사진 설명(max:10)" required>
					</div>
					<div class="form-group">
						<input type="file" class="form-control" id="filename"
							name="filename" required> <span class="help-block">(.jpg
							or .png, max 5M)</span>
					</div>

					<button type="submit" class="btn btn-default">Submit</button>

				</form>

			</div>
		</div>

		<div class="panel panel-default" id="output">
			<div class="panel-heading">사진 목록</div>
			<div class="panel-body">

				<div class="row">
					<%=sb01.toString()%>
				</div>
			</div>
		</div>
	</div>

</body>
</html>