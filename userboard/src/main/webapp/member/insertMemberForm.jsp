<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 인코딩 설정	
	request.setCharacterEncoding("UTF-8");

	// 로그인된 상태이면 home.jsp로 이동
	if (session.getAttribute("memberID") != null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return; // 실행 종료
	}

	String msg = request.getParameter("msg"); // 다른 페이지에서 받아오는 msg 변수
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertMemberForm</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="container mt-3">
		<h1 class="text-center">회원가입</h1>
		<br>
	<%
		if (request.getParameter("msg") != null) { // 넘어오는 msg 값이 있으면 실행
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
		<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post" accept-charset="UTF-8">
			<table class="table table-bordered">
				<tr>
					<th class="table-success text-center">아이디</th>
					<td><input type="text" name="memberID" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="table-success text-center">비밀번호</th>
					<td><input type="password" name="memberPW" class="form-control w-25"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-success">회원가입</button>
		</form>
		<br>

		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>