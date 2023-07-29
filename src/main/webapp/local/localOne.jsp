<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*"%>
<%@ page import="vo.*" %>   
<%			
	// local 테이블 상세정보
	// 각 항목별로 수정, 삭제 옵션
	// 수정, 삭제의 경우 게시글이 없는 카테고리(지역명)만 가능
	
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
	System.out.println(loginMemberID + " <-- loginMemberID(localOne)");

	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(localOne)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(localOne)");
	
	// local 테이블의 모든 정보를 가져오는 쿼리
	// SELECT * FROM local
	String localSql = "SELECT local_name localName, createdate FROM local";
	PreparedStatement localStmt = conn.prepareStatement(localSql);
	System.out.println(localStmt + " <-- localStmt(localOne)");
	ResultSet localRs = localStmt.executeQuery(); // 쿼리 실행
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while (localRs.next()) {
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		localList.add(l);
	}
	
	System.out.println(localList + " <-- localList(localOne)");
	System.out.println(localList.size() + " <-- localList.size()(localOne)");
	
	System.out.println("==========================================");
%>
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>localOne</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include><br>
		<div class="container mt-3">
		<div class="text-center">
			<h1>카테고리 정보</h1>
		</div><br>
		<% 
			if (request.getParameter("msg") != null) { 
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<table class="table table-bordered text-center">
			<tr class="table-success">
				<th>카테고리명</th>
				<th>생성일자</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			
		<% 
			for (Local l : localList) {
		%>
			<tr>
				<td><%=l.getLocalName()%></td>
				<td><%=l.getCreatedate().substring(0, 10)%></td>
				<td><a href="<%=request.getContextPath()%>/local/updateLocalForm.jsp?localName=<%=l.getLocalName()%>" class="btn btn-outline-success">수정</a></td>
				<td><a href="<%=request.getContextPath()%>/local/deleteLocalForm.jsp?localName=<%=l.getLocalName()%>" class="btn btn-outline-success">삭제</a></td>
			</tr>
		<%
			}
		%>
		</table>
		<div class="text-center">
			<a href="<%=request.getContextPath()%>/local/insertLocalForm.jsp" class="btn btn-outline-success">새 카테고리 입력</a>
		</div>
		<br>
		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>