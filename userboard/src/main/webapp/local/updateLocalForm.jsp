<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %> 
<%
	// 지역정보(지역명) 수정 폼
	// 지역명 카테고리에 게시글 있는 경우 수정 불가
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인: 세션 없는 경우(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updateLocalForm)");
	
 	// 요청값 유효성 확인
	// localName 값이 넘어오지 않을 경우 localOne.jsp로 이동
	if (request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp");
		return;
	}
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- localName(updateLocalForm)"); 
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updateLocalForm)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updateLocalForm)");
	
	// localName에 해당하는 board 테이블 행의 수(게시글 수)를 구하는 쿼리 작성
	String localSql = "SELECT COUNT(*) cnt FROM board WHERE local_name=?";
	PreparedStatement localStmt = conn.prepareStatement(localSql);
	localStmt.setString(1, localName);
	System.out.println(localStmt + " <-- localStmt(updateLocalForm)");
	
	// 쿼리 실행
	ResultSet localRs = localStmt.executeQuery();
	int cnt = 0;
	if (localRs.next()) {
		cnt = localRs.getInt("cnt");
	}
	System.out.println(cnt + " <-- cnt(updateLocalForm)");
	
/* 	if (cnt != 0) {
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp");
		return;
	} */

	System.out.println("==========================================");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updateLocalForm</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<br>
		<!-- cnt가 0 (게시글이 0)인 경우에만 form 태그 출력  -->
		<%
			if (cnt == 0) { 
		%>
		<div class="text-center">
			<h1>카테고리명 수정</h1>
		</div>
		<%
			if (request.getParameter("msg") != null) {	
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<form action="<%=request.getContextPath()%>/local/updateLocalAction.jsp" method="post"> 
			<table class="table table-bordered">
				<tr>
					<th class="table-primary text-center">현재 카테고리명</th>
					<td><input type="text" name="localName" value="<%=localName%>" readonly="readonly"></td>
				</tr>
				<tr>
					<th class="table-primary text-center">새 카테고리명</th>
					<td><input type="text" name="newLocalName"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-primary">수정</button>
		</form>
		<%
			} else {
		%>
			
			<h5>게시글이 존재하므로 수정 불가능합니다.</h5>
			<h5><%=localName%> 카테고리 게시글 수: <%=cnt%></h5>
		
			<a href="<%=request.getContextPath()%>/local/localOne.jsp" class="btn btn-outline-primary">이전</a>
		<%
			}
		%>
		<br>
		<br>
		<div >
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</body>
</html>