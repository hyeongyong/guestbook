<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.guestbook.*, java.util.*, com.login.*"%>
<%
	
	request.setCharacterEncoding("UTF-8");

	String path = request.getContextPath();
	/* 관리자 전용 페이지 */
	
	Object login = session.getAttribute("login");
	String info  = "";
	/* 세션 저장소에 값이 없는 경우 null이 반환 된다. */
	if(login == null) {
		//로그인하지 못한 사용자 접근 차단
		//->로그인 폼 페이지로 강제 이동
		response.sendRedirect(path + "/views/login/loginfailform.jsp");
	} else {
		info = ((Login)login).getId_();
	}
	
	
	String pageNum_ = request.getParameter("pageNum");
	String pageCount_ = request.getParameter("pageCount");
	if(pageNum_ == null) {
		pageNum_ = "1";
		pageCount_ = "10";
	}
	int pageNum = Integer.parseInt(pageNum_);
	int pageCount = Integer.parseInt(pageCount_);
	int pageStart = pageCount*(pageNum-1);

	adminGuestbookDAO dao = new adminGuestbookDAO();
	StringBuilder sb = new StringBuilder();
	
	//페이지 출력
	List<Guestbook> pageList = dao.pageList(pageStart, pageCount);
	
	//전체 갯수
	int totalCount = dao.totalCount();
	//블라인드 갯수
	int count = pageList.size();
	int blindCount = 0;
	//첫페이지 
	int firstPage = 1;
	int lastPage = (int)(Math.ceil(totalCount/(double)pageCount));
	
	for(Guestbook gb : pageList){
		
		if(gb.getBlind()==1){
			sb.append("<tr style=\"background-color:#D4CECE;\">");
			++blindCount;
		} else{
			sb.append("<tr>");
		}
		sb.append(String.format("<td>%s</td>", gb.getGid()));
		sb.append(String.format("<td>%s</td>", gb.getName_()));
		sb.append(String.format("<td class='col-md-6'>%s</td>", gb.getContent()));
		
		//날짜와 시간을 같이 출력하는 포맷 설정
		sb.append(String.format("<td>%1$tF %1$tT</td>", gb.getTs()));
		sb.append(String.format("<td>%s</td>", gb.getClientIP()));
		//class 식별자 추가 -> jQeury 이벤트 등록 준비
		//value="" 속성 추가 -> 글번호 설정
		sb.append(String.format("<td><div class=\"btn-group\"><button type = \"button\"  class=\"btn btn-default btn-xs btnOn\" value=\"%s\" %s>on</button>\r\n" +
								"<button type = \"button\" class=\"btn btn-default btn-xs btnOff\" value=\"%s\" %s>off</button></div></td>", gb.getGid(), (gb.getBlind()==1)?"disabled":"" , gb.getGid(), (gb.getBlind()==0)?"disabled":""));
		sb.append("</tr>");
	}
	

	String result = request.getParameter("result");
	String txt = "";
	if(result!=null) {
		if(result.equals("success")){
	         txt = "<div class=\"alert alert-success alert-dismissible fade in\" style=\"display: inline-block; padding-top: 5px; padding-bottom: 5px; margin: 0px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Success!</strong> 요청한 작업이 처리되었습니다.</div>";
		} else{
	         txt = "<div class=\"alert alert-danger alert-dismissible fade in\" style=\"display: inline-block; padding-top: 5px; padding-bottom: 5px; margin: 0px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Fail!</strong> 요청한 작업이 처리되지 못했습니다.</div>";
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
		
		$(".btnOn").on("click", function(){
			var txt = "Blind On?";
			
			if(confirm(txt)) {
				window.location.assign("<%=path%>/views/guestbook/guestbook_blind.jsp?gid="+$(this).val()+"&blind=1");
			}
		});

		$(".btnOff").on("click", function(){
			var txt = "Blind Off?";
			
			if(confirm(txt)) {
				window.location.assign("<%=path%>/views/guestbook/guestbook_blind.jsp?gid="+$(this).val()+"&blind=0");
			}
		});

		//페이징 액션 추가
		//주의) 첫 페이지인 경우 Previous 버튼에 대한 비활성 처리 필요
		if(<%=pageNum==firstPage%>) {
			$("#btnPre").attr("disabled", "disabled");
		}
		
		//Previous 버튼 추가
		$("#btnPre").on("click", function(){
			var pageNum = $(this).val();
			window.location.assign("<%=path%>/views/admin/adminbooklist.jsp?pageCount=" + <%=pageCount%> + "&pageNum="+pageNum);
			
		});
		
		if(<%=pageNum==lastPage%>) {
			$("#btnNe").attr("disabled", "disabled");
		}
		
		//Next 버튼 액션
		$("#btnNe").on("click", function(){
			var pageNum = $(this).val();
			window.location.assign("<%=path%>/views/admin/adminbooklist.jsp?pageCount=" + <%=pageCount%> + "&pageNum="+pageNum);
		});
		
		
		//Selected 액션	
		$("#pageCount option[value=<%=pageCount%>]").attr("selected", "selected");
		$("#pageCount").on("change", function(){
			var pageCount= $(this).val();
			window.location.assign("<%=path%>/views/admin/adminbooklist.jsp?pageNum=1&pageCount="+ pageCount);	
		})
	});
</script>
</head>
<body>

	<div class="container">

		<div class="panel page-header" style="text-align: center;">
			<h1 style="font-size: xx-large;">
				<a href="<%=path%>/views/admin/adminbooklist.jsp"><img src="<%=path%>/resources/img/sist_logo.png"
					alt="sist_logo.png"></a> 방명록 <small>v1.0</small> <span
					style="font-size: small; color: #777777;"></span>
			</h1>
		</div>
		<%=txt%>

		<nav class="navbar navbar-default">
			<div class="container-fluid">
				<div class="navbar-header"></div>
				<ul class="nav navbar-nav">
					<li class="active"><a href="<%=path%>/views/admin/adminbooklist.jsp">방명록 관리</a></li>
					<li><a href="<%=path%>/views/admin/adminpicturelist.jsp">사진 관리</a></li>
					<li><a href="<%=path%>/views/login/admin_logout.jsp">[관리자/<%=info%>]로그 아웃</a></li>
				</ul>
			</div>
		</nav>


		<div class="panel panel-default" id="output">
			<div class="panel-heading">방명록 글목록</div>
			<div class="panel-body">

				<table class="table table">
					<thead>
						<tr>
							<th>번호</th>
							<th>글쓴이</th>
							<th>글내용</th>
							<th>작성일</th>
							<th>Client IP</th>
							<th>Blind</th>
						</tr>
					</thead>
					<tbody>
						<%=sb.toString()%>
					</tbody>
				</table>

				<form class="form-inline" method="post">
					<div class="form-group">
						<button type="button" class="btn btn-default">
							TotalCount <span class="badge"><%=totalCount%></span>
						</button>
						<button type="button" class="btn btn-default">
							Count <span class="badge"><%=count%></span>
						</button>
						<button type="button" class="btn btn-default">
							BlindCount <span class="badge"><%=blindCount%></span>
						</button>

						<!-- 페이징 버튼 추가 -->
						<div class="form-inline">
							<button type="button" class="btn btn-default">
								Page <span class="badge" id="pageNum"><%=pageNum%></span>
							</button>
							<button type="button" class="btn btn-default btn-md " id="btnPre"
								value="<%=pageNum - 1%>">
								<span class="glyphicon glyphicon-hand-left"></span> Previous
							</button>
							<button type="button" class="btn btn-default btn-md" id="btnNe"
								value="<%=pageNum + 1%>">
								Next <span class="glyphicon glyphicon-hand-right"></span>
							</button>

							<!-- 페이징 기준 선택 항목 -->
							<select class="form-control" id="pageCount" name="pageCount">
								<option value="5">5개씩보기</option>
								<option value="10" selected="selected">10개씩보기</option>
								<option value="15">15개씩보기</option>
								<option value="20">20개씩보기</option>
							</select>
						</div>
					</div>		
				</form>

			</div>


		</div>

	</div>


</body>
</html>
