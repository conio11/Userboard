<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	// 새 지역을 입력하는 폼
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인 - 세션 없으면(로그인 상태가 아니면) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(insertLocalForm)");
%>    
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertLocalForm</title>
		<jsp:include page="/inc/link.jsp"></jsp:include>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="container mt-3">
		<a href="<%=request.getContextPath()%>/local/localOne.jsp" class="btn btn-outline-success">이전</a>
		<br>
		<div class="text-center">
			<h1>새 지역 입력</h1>
		</div>
		
	<% 
		if (request.getParameter("msg") != null) { // 액션 파일에서 넘어오는 값이 있는 경우 실행
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
		<form action="<%=request.getContextPath()%>/local/insertLocalAction.jsp" method="post">
			<br>
			<table class="table table-bordered">
				<tr>
					<th class="table-success text-center">localName</th>
					<td>
						<input type="text" name="localName" class="form-control w-25">
					</td>					
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-success">입력</button>
		</form>
		<br>
		<br>
		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>