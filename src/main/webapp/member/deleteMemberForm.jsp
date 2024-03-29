<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*"%>    
<%
	// 회원탈퇴(delete) 폼
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// 세션 유효성 확인 - 세션 없으면(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(deleteMemberForm)");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deleteMemberForm</title>
		<jsp:include page="/inc/link.jsp"></jsp:include>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="container mt-3">
		<a href="<%=request.getContextPath()%>/member/memberInfo.jsp" class="btn btn-outline-success">이전</a>
		<div class="text-center">
			<h1>회원 탈퇴</h1>
		</div>
		<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post">
			<%
				if (request.getParameter("msg") != null) { // 액션 페이지에서 넘어올 때 msg에 값이 있으면 출력
			%>
					<%=request.getParameter("msg")%>
			<%	
				}
			%>
			<br>
			<table class="table table-bordered">
				<tr>
					<th class="table-success text-center">비밀번호 확인</th>
					<td><input type="password" name="currentPw" class="form-control w-25"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-success">회원 탈퇴</button>
		</form>
		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>