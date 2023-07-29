<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%
	// 지역 입력 실행파일
	
	// post 방식 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인 -> 요청값 유효성 확인
	// 세션 유효성 확인 -> 세션 없는 경우(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		String loginMemberID = (String) session.getAttribute("loginMemberID");
		System.out.println(loginMemberID + " <-- loginMemberID(insertLocalAction)");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return; // 실행 종료
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(insertLocalAction)");

	// 요청값 유효성 확인
	// 지역명 입력값이 공백 또는 null일 경우 입력 폼으로 이동
	if (request.getParameter("localName") == null 
	|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("새 지역명을 입력하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/insertLocalForm.jsp?msg=" + msg);
		return; // 실행 종료
	}
	
	// 입력된(form에서 넘어온) 지역명 변수로 저장
	String localName = request.getParameter("localName");
	
	// 지역명 디버깅
	System.out.println(localName + " <-- localName(insertLocalAction)");
	
	// DB 연결 
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(insertLocalAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(insertLocalAction)");
	
	// 지역명 입력
	// INSERT INTO local(local_name, createdate, updatedate) value (?, NOW(), NOW())
	String insertSql = "INSERT INTO local(local_name, createdate, updatedate) value (?, NOW(), NOW())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setString(1, localName);
	System.out.println(insertStmt + " <-- insertStmt(insertLocalAction)");
	
	// 중복 지역명 확인
	String isNewSql = "SELECT local_name localName FROM local WHERE local_name=?";
	PreparedStatement isNewStmt = conn.prepareStatement(isNewSql);
	isNewStmt.setString(1, localName);
	System.out.println(isNewStmt + " isNewStmt(insertLocalForm)");
	
	ResultSet isNewRs = isNewStmt.executeQuery(); // 쿼리 실행
	if (isNewRs.next()) {
		System.out.println("중복된 지역명");
		msg = URLEncoder.encode("이미 입력된 지역입니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/insertLocalForm.jsp?msg=" + msg);
		return; // 실행 종료
	}
	
	// 쿼리 실행
	int row = insertStmt.executeUpdate();
	System.out.println(row + " <-- insertLocalAction");
	
	if (row == 1) {
		System.out.println("입력 성공");
		msg = URLEncoder.encode("새 지역명이 추가되었습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp?msg=" + msg);
	} else {
		System.out.println("입력 실패");
		response.sendRedirect(request.getContextPath()+"/local/insertLocalForm.jsp");
	}
	
	System.out.println("===============================");
%>