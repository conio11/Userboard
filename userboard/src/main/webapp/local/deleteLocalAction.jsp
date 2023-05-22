<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 지역명 삭제 실행파일 (게시글 없는 경우에만 삭제)
	
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
	System.out.println(loginMemberID + " <-- loginMemberID(deleteLocalAction)"); 
	
	// 요청값 유효성 확인
	// 넘어온 기존 지역명이 null이거나 공백이면
	if (request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")) {
		String localName = request.getParameter("localName");
		System.out.println(localName + " <-- localName(deleteLocalAction)");
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp");
		return;
	}
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- localName(deleteLocalAction)");

	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(deleteLocalAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(deleteLocalAction)");
	
	// local 테이블에서 local_name에 해당하는 행을 삭제하는 쿼리
	// DELETE FROM local WHERE local_name=?
	String deleteSql = "DELETE FROM local WHERE local_name=?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setString(1, localName);
	System.out.println(deleteStmt + " <-- deleteStmt(deleteLocalAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = deleteStmt.executeUpdate();
	if (row == 1) { // 카테고리 삭제 성공
		System.out.println("지역명 삭제 완료");
		msg = URLEncoder.encode("카테고리가 삭제되었습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp?msg=" + msg);
	} else { // 삭제 실패
		System.out.println(row + " <-- row(deleteLocalAction)");
		System.out.println("지역명 삭제 실패");
		// localName = URLEncoder.encode(localName, "UTF-8");
		msg = URLEncoder.encode("카테고리 삭제에 실패했습니다.", "UTF-8");
		// response.sendRedirect(request.getContextPath() + "/local/deleteLocalForm.jsp?localName=" + localName);
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp?msg=" + msg);
	}
	
	System.out.println("=============================");
%>