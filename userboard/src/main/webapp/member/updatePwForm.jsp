<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%> 
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>

<%
 	// 회원정보(비밀번호) 수정 폼
 	// 비밀번호만 변경 가능
  	
	// post 방식 인코딩 설정
	response.setCharacterEncoding("UTF-8");
	
	// 세션 유효성 확인: 로그인 상태가 아닌 경우 home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) { 
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg); 
		return;
	} 
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updatePwForm)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updatePwForm)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updatePwForm)");
	
	// member_id, createdate, updatedate 를 가져오기 위한 쿼리 작성
	// SELECT member_id memberID, createdate, updatedate FROM member WHERE member_id=?
	String memberSql = "SELECT member_id memberID, member_pw memberPW, createdate, updatedate FROM member WHERE member_id=?";
	PreparedStatement memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, loginMemberID);
	System.out.println(memberStmt + " <-- memberStmt(updatePwForm)");
	
	ResultSet memberRs = memberStmt.executeQuery();
	Member member = null;
	if (memberRs.next()) {
		member = new Member();
		member.setMemberID(memberRs.getString("memberID"));
		// member.setMemberPW(memberRs.getString("memberPW"));
		// member.setCreatedate(memberRs.getString("createdate"));
		// member.setUpdatedate(memberRs.getString("updatedate"));
	}
	System.out.println(member + " <-- member(updatePwForm)");
	
	System.out.println("=============================");
%>
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updatePwForm</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>	
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="container mt-3 d-flex justify-content-center">
			<h1>비밀번호 수정</h1>
		</div>
		<form action="<%=request.getContextPath()%>/member/updatePwAction.jsp" method="post">
		<%
			if (request.getParameter("msg") != null) { // 액션 페이지에서 넘어올 때 msg에 값이 있으면 출력
		%>
				<%=request.getParameter("msg")%>
		<%	
			}
		%>
		<table class="table table-bordered">
			<tr>
				<th class="table-primary text-center">회원ID</th>
				<td><%=member.getMemberID()%></td>
			</tr>
			<tr>
				<th class="table-primary text-center">기존 비밀번호 입력</th>
				<td><input type="password" name="currentPw"></td>
			</tr>
			<tr>
				<th class="table-primary text-center">새 비밀번호 입력</th>
				<td><input type="password" name="newPw"></td>
			</tr>
			<tr>
				<th class="table-primary text-center">새 비밀번호 다시 입력</th>
				<td><input type="password" name="newPw2"></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-primary">비밀번호 변경</button>
		</form>
	</body>
</html>