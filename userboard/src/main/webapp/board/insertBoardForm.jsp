<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %> 
<%
	// 게시글 입력 폼
	// 로그인 상태여야 입력 가능
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// 세션 유효성 확인: 세션 없는 경우(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(insertBoardForm)");
	
	System.out.println("==========================================");
%>
    
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertBoardForm</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<br>
		<div class="container mt-3">
		<div class="text-center">
			<h1>게시글 입력</h1>
		</div>
		<br>
		
		<% 
			if (request.getParameter("msg") != null) { // 액션 파일에서 넘어오는 값이 있는 경우 실행
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-success text-center">localName</th>
					<td><input type="text" name="localName" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="table-success text-center">boardTitle</th>
					<td><input type="text" name="boardTitle" class="form-control"></td>
				</tr>
				<tr>
					<th class="table-success text-center">boardContent</th>
					<td><textarea rows="2" cols="80" name="boardContent" class="form-control"></textarea></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-success">게시글 입력</button>
		</form>
		<br>
		<br>
		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>