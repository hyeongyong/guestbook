<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.picture.*, com.guestbook.*" import="java.util.*"%>

<%
//절대경로 확인
String path = request.getContextPath();
System.out.println(path);


//------------------------------------------------------------------------------------------
/* 사진 리스트 불러오기 및 출력 코드 작성 */
PictureDAO pdao = new PictureDAO();
List<Picture> pictureList = pdao.pictureList();
int pictureCount = pictureList.size();

StringBuilder sb01 = new StringBuilder();
StringBuilder sb02 = new StringBuilder();

if (pictureCount == 0) {
	
	//데이터베이스에 그림파일 정보가 없는 경우 기본값 설정
	sb01.append(String.format("<li data-target=\"#myCarousel\" data-slide-to=\"0\" class=\"active\"></li>"));
	sb02.append(String.format("<div class=\"item active\">"));
	sb02.append(String.format("<img src=\"%s/resources/picture/chicago.jpg\" alt=\"chicago\">",path));
	sb02.append(String.format("<div class=\"carousel-caption\">"));
	sb02.append(String.format("<h3>시카고 공연</h3>"));
	sb02.append(String.format("</div>"));
	sb02.append(String.format("</div>"));
} else {
	/* 
	주의) <li> 태그 생성시 class="active" 속성은 
	첫 번째 <li> 태그만 지정해야 한다. 
	주의) <div> 태그 생성시 class="active" 속성은 
	첫 번째 <div> 태그만 지정해야 한다. 
	*/
	for (int a=0; a<pictureCount; ++a) {
		Picture p = pictureList.get(a);
		sb01.append(String.format("<li data-target=\"#myCarousel\" data-slide-to=\"%d\" %s></li>", a, (a==0)?"class=\"active\"":""));
		sb02.append(String.format("<div class=\"item %s\">", (a==0)?"active":""));
		sb02.append(String.format("<img src=\"%s/resources/picture/%s\" alt=\"%s\">", path, p.getFilename(), p.getContent()));
		sb02.append(String.format("<div class=\"carousel-caption\">"));
		sb02.append(String.format("<h3>%s</h3>", p.getContent()));
		sb02.append(String.format("</div>"));
		sb02.append(String.format("</div>"));
	}
}
//----------------------------------------------------------------------------------------------------------



//방명록 게시물 출력(페이징 적용) ------------------------------------------------------------------------------------

	//페이징 액션 추가
	String pageNum_ = request.getParameter("pageNum");
	String pageCount_ = request.getParameter("pageCount");
	if(pageNum_ == null){		
		pageNum_ = "1"; //페이지 번호 초기값
		pageCount_ = "10"; //페이지 카운트 초기값
	}
	int pageNum = Integer.parseInt(pageNum_);
	int pageCount = Integer.parseInt(pageCount_);
	int pageStart = pageCount*(pageNum-1);
	
	GuestbookDAO dao = new GuestbookDAO();
	StringBuilder sb03 = new StringBuilder();
	
	//페지이  결과 출력
	List<Guestbook> glist = dao.pageList(pageStart, pageCount);
	int count = glist.size();

	//전체 사이즈
	int totalCount = dao.totalCount();
	
	//첫 페이지
	int firstPage = 1;
	//마지막 페이지
	int lastPage = (int)(Math.ceil(totalCount / (double)pageCount));
	
	
	for(Guestbook gb : glist){
		//랜덤 그림출력을 위한 번호 생성
		String randomNum = String.format("%02d",(int)(Math.random()*10) + 1);
		
		sb03.append("<tr>");
		sb03.append(String.format("<td>%s</td>", gb.getGid()));
		
		//글쓴이 정보 출력시 램덤 그림 출력 포함
		sb03.append(String.format("<td><img src=\"%s/resources/img/Fotolia%s.png\" title=\"%s\"></td>", path, randomNum, gb.getName_()));
		sb03.append(String.format("<td class='col-md-6'>%s</td>", gb.getContent()));
		sb03.append(String.format("<td>%tF</td>", gb.getRegDate()));
		
		sb03.append(String.format("<td><button type=\"button\" class=\"btn btn-default btn-xs btnDel\" data-toggle=\"modal\" data-target=\"#deleteFormModal\"title=\"pw 입력 바랍니다.\" value=\"%s\">Del</button></td>",gb.getGid()));
		sb03.append("</tr>");
	}
//-----------------------------------------------------------------------------------------------------------



	 String result = request.getParameter("result");
	 String txt = "";
	  if(result != null){
	      if(result.equals("success")){
	         txt = "<div class=\"alert alert-success alert-dismissible fade in\" style=\"display: inline-block; padding-top: 5px; padding-bottom: 5px; margin: 0px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Success!</strong> 요청한 작업이 처리되었습니다.</div>";
	      }else{
	         txt = "<div class=\"alert alert-danger alert-dismissible fade in\" style=\"display: inline-block; padding-top: 5px; padding-bottom: 5px; margin: 0px;\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a><strong>Fail!</strong> 요청한 작업이 처리되지 못했습니다.</div>";
	      }
	   }

%>
<!DOCTYPE html>
<html>
<head>
<title>쌍용교육센터</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<style>
/* 박스에 그림자 효과 지정 */
div#carousel:hover, div#input:hover, div#output:hover {
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.19);
}

#myCarousel img {
	width:1200px;
	height:700px;
}
</style>

<!-- Google Map API -->
<script src="https://maps.googleapis.com/maps/api/js"></script>

<!-- Util.js 라이브러리 연결 -->
<script src="resources/script/util.js"></script>

<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<script>
	function myMap() {

		//위도, 경도 
		var handok = new google.maps.LatLng(37.499285, 127.033271);
		var center = new google.maps.LatLng(37.500544, 127.033215);

		//맵 정보
		var mapProp = {
			center : center,
			zoom : 17,
		};
		//맵 요청
		var map = new google.maps.Map(document.getElementById("googleMap"),
				mapProp);

		//마커 표시
		var marker = new google.maps.Marker({
			position : handok
		});
		marker.setMap(map);

		//InfoWindow
		var infowindow = new google.maps.InfoWindow(
				{
					content : "<div style=\"text-align:center;\"><strong>한독약품빌딩</strong><br>서울특별시 강남구 역삼1동 735<br><img src=\"<%=path%>/resources/img/handok_small.png\"></div>"
				});
		infowindow.open(map, marker);

	}
</script>


<script>
	$(document).ready(function() {
		
		//남은 날짜 출력 -----------------------------
		//->Util.js 라이브러리 필요
		$("#date").text("("+dDay("2019-01-17")+")");
		//--------------------------------------------
		
		
		//페이징 액션 추가 -----------------------------------------------------------
		//주의) 첫 페이지인 경우 Previous 버튼에 대한 비활성 처리 필요
		if(<%=pageNum==firstPage%>) {
			$("#btnPre").attr("disabled", "disabled");
		}
		
		//Previous 버튼 추가
		$("#btnPre").on("click", function(){
			var pageNum = $(this).val();
			window.location.assign("<%=path%>/index.jsp?pageCount="+<%=pageCount%> + "&pageNum="+pageNum);
			
		});
		
		if(<%=pageNum==lastPage%>) {
			$("#btnNe").attr("disabled", "disabled");
		}
		
		//Next 버튼 액션
		$("#btnNe").on("click", function(){
			var pageNum = $(this).val();
			window.location.assign("<%=path%>/index.jsp?pageCount="+<%=pageCount%> + "&pageNum="+pageNum);
		});
		
		//select 액션
		$("#pageCount option[value=<%=pageCount%>]").attr("selected", "selected");
		$("#pageCount").on("change", function(){
			var pageCount = $(this).val();
			window.location.assign("<%=path%>/index.jsp?pageNum=1&pageCount=" + pageCount);
		});
		
		//---------------------------------------------------------------------------------------
	
		
		//방명록 삭제 액션--------------------------------------------------------------------------
		
		$(".btnDel").on("click", function(){
			$("#gid").attr("value",$(this).val());
		})
		
		//-------------------------------------------------------------------------------------------
		

		
		//------------------------------------------------------------------------------
		//맵 버튼 클릭시 (구글맵)모달창 오픈하는 과정
		$("button.map").on("click", function() {
			$("div#googleMapModal").modal();
		});
		//모달창 이벤트 등록 -> myMap() 함수 호출, 동적 생성된 엘리먼트 삭제 연계
		$("div#googleMapModal").on("shown.bs.modal", function() {
			myMap();
		});
		$("div#googleMapModal").on("hidden.bs.modal", function() {
			$("div#googleMap").empty();
		});
		//------------------------------------------------------------------------------
	});
</script>

</head>
<body>

	<div class="container" id="top">

		<div class="panel page-header" style="text-align: center;">
			<h1 style="font-size: xx-large;">
				<a href="<%=path%>/index.jsp"><img src="<%=path%>/resources/img/sist_logo.png"
					alt="sist_logo.png"></a> 방명록 <small>v1.0</small> <span
					style="font-size: small; color: #777777;"></span>
			</h1>
		</div>
		<span><%=txt%></span>

		<div class="nanel panel-default" id="title" style="padding-bottom: 10px;">
			<div class="panel-heading">
				서울특별시 강남구 역삼 1동 735 한독약품빌딩 8층 쌍용교육센터 / 지하철 2호선 역삼역 3번출구<br>
				Java&amp;Python 기반 응용SW 개발자 양성과정 2018.06.25 ~ 2019.01.17 <span
					style="color: red;" id="date"></span>
				<button class="btn btn-default btn-xs map">Map</button>
				<button class="btn btn-default btn-xs admin" data-toggle="modal" data-target="#adminFormModal">Admin</button>
			</div>
		</div>

		<div class="panel panel-default" id="carousel">
			<div class="panel-heading">Picture List</div>
			<div class="panel-body">
				<div id="myCarousel" class="carousel slide" data-ride="carousel">
					<!-- Indicators -->
					<ol class="carousel-indicators">
						<!-- <li data-target="#myCarousel" data-slide-to="0" class="active"></li> -->
							<%=sb01.toString()%>
					</ol>

					<!-- Wrapper for slides -->
					<div class="carousel-inner">

						<!-- <div class="item active">
							<img src="resources/picture/chicago.jpg" alt="Chicago"
								style="width: 100%;">
							<div class="carousel-caption">
								<h3>Chicago</h3>
							</div>
						</div> -->
						<%=sb02.toString()%>
					</div>

					<!-- Left and right controls -->
					<a class="left carousel-control" href="#myCarousel"
						data-slide="prev"> <span
						class="glyphicon glyphicon-chevron-left"></span> <span
						class="sr-only">Previous</span>
					</a> <a class="right carousel-control" href="#myCarousel"
						data-slide="next"> <span
						class="glyphicon glyphicon-chevron-right"></span> <span
						class="sr-only">Next</span>
					</a>
				</div>
			</div>
		</div>

		<div class="panel panel-default" id="input">
			<div class="panel-heading">방명록 글쓰기</div> 
			<div class="panel-body">

				<form action="<%=path%>/views/guestbook/guestbook_insert.jsp" method="post">
					<div class="form-group">
						<input type="text" class="form-control" id="name_" name="name_"
							placeholder="Name(max:50)" required>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" id="pw" name="pw"
							placeholder="PASSWORD(max:50)" required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							name="content" placeholder="CONTENT(max:500)">
					</div>


					<button type="submit" class="btn btn-default">Submit</button>

				</form>


			</div>
		</div>


		<div class="panel panel-default" id="output">
			<div class="panel-heading">방명록 글목록</div>
			<div class="panel-body">

				<table class="table">
					<thead>
						<tr>
							<th>번호</th>
							<th>글쓴이</th>
							<!-- 고정너비 지정 -->
							<th class="com-md-8">글내용</th>
							<th>작성일</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
							<%=sb03.toString()%>

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
						
						<!-- 페이징 버튼 추가 -->
						<button type="button" class="btn btn-default">
								Page <span class="badge" id="pageNum"><%=pageNum%></span>
						</button>
						<button type="button" class="btn btn-default btnPrevious" id="btnPre" value="<%=pageNum-1%>">
							<span class="glyphicon glyphicon-step-backward"></span> Previous
						</button>
						<button type="button" class="btn btn-default btnNext" id="btnNe" value="<%=pageNum+1%>">
							Next <span class="glyphicon glyphicon-step-forward"></span>
						</button>

						<!-- 페이징 기준 선택 항목 -->
						<select class="form-control" id="pageCount" name="pageCount">
							<option value="5">5개씩보기</option>
							<option value="10" selected="selected">10개씩보기</option>
							<option value="15">15개씩보기</option>
							<option value="20">20개씩보기</option>
						</select>
					</div>

				</form>

			</div>


		</div>

	</div>
	

	<!-- Modal -->
	<div id="deleteFormModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Delete</h4>
				</div>
				<div class="modal-body">

					<p>본인이 작성한 글인지 확인하는 절차입니다.</p>

					<form action="<%=path%>/views/guestbook/guestbook_delete.jsp" method="post">

						<!-- 주의) 삭제 진행을 위해서 글번호 정보가 필요합니다. -->
						<input type="hidden" id="gid" name="gid" value="">

						<div class="form-group">
							<input type="password" class="form-control" id="pw" name="pw"
								placeholder="PASSWORD(max:20)" required>
						</div>

						<button type="submit" class="btn btn-default">Submit</button>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>


	<!-- Modal -->
	<div id="adminFormModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Admin Login</h4>
				</div>
				<div class="modal-body">

					<p>관리자인지 확인하는 절차입니다.</p>

					<form action="<%=path%>/views/login/admin_login.jsp" method="post">

						<div class="form-group">
							<input type="text" class="form-control" id="id_" name="id_"
								placeholder="ID(max:20)" required>
						</div>

						<div class="form-group">
							<input type="password" class="form-control" id="pw" name="pw"
								placeholder="PASSWORD(max:20)" required>
						</div>

						<button type="submit" class="btn btn-default">Submit</button>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>


	<!-- Modal -->
	<div id="googleMapModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Google Map</h4>
				</div>
				<div class="modal-body">

					<!-- 맵 출력 -->
					<div id="googleMap" style="width: 100%; height: 500px;"></div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

</body>
</html>