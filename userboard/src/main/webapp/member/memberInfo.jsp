<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
    
<%
	// 회원정보 보기 (현재 페이지 - memberInfo)
	// member_id, (member_pw), createdate, updatedate
	// 로그인된 상태에서만 '회원정보' 탭 볼 수 있는 상태
	// 로그인한 회원의 아이디 가져오기 -> 어떻게? -> session 변수
	// '회원정보 수정' 버튼
	// '회원 탈퇴' 버튼
	
	// post 방식 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// 세션 유효성 확인: 로그인 상태가 아닌 경우 home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) { 
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg); 
		return;
	} 
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(memberInfo)");	
	
	// DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(memberInfo)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(memberInfo)");
	
	// 회원정보 출력 쿼리
	// SELECT member_id, createdate, updatedate FROM member WHERE member_id=?
			
	String loginMemberSql = "SELECT member_id memberID, createdate, updatedate FROM member WHERE member_id=?";
	PreparedStatement loginMemberStmt = conn.prepareStatement(loginMemberSql);
	loginMemberStmt.setString(1, loginMemberID);
	System.out.println(loginMemberStmt + " <-- loginMemberStmt(memberInfo)");
	ResultSet loginMemberRs = loginMemberStmt.executeQuery(); // row 1 Member 타입
	
	Member member = null;
	if (loginMemberRs.next()) {
		member = new Member();
		member.setMemberID(loginMemberRs.getString("memberID"));
		member.setCreatedate(loginMemberRs.getString("createdate"));
		member.setUpdatedate(loginMemberRs.getString("updatedate"));
	}
	System.out.println(member + " <-- member(memberInfo)");
	
	System.out.println("=====================");
%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>memberInfo</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="container mt-3 d-flex justify-content-center">
			<h1>회원 정보</h1>
		</div>
		<table class="table table-bordered">
			<tr>
				<th class="table-primary text-center">회원ID</th>
				<td><%=member.getMemberID()%></td>
			</tr>
			<tr>
				<th class="table-primary text-center">가입일자</th>
				<td><%=member.getCreatedate()%></td>
			</tr>
			<tr>
				<th class="table-primary text-center">정보수정일자</th>
				<td><%=member.getUpdatedate()%></td>
			</tr>
		</table>
		<div>
			<a href="<%=request.getContextPath()%>/member/updatePwForm.jsp?loginMemberID=<%=loginMemberID%>" class="btn btn-outline-primary">회원정보 수정</a>
			<a href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp" class="btn btn-outline-primary">회원 탈퇴</a>
		</div>
		<br>
			<div>
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>	
	
	</body>
</html>