<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 지역명 수정 실행파일 (게시글 없는 경우에만 수정)
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인 - 세션 없으면(로그인 상태가 아니면) home2.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updateLocalAction)");
	
	// 요청값 유효성 확인
	// 넘어온 기존 지역명이 null이거나 공백이면
	if (request.getParameter("localName") == null	
		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp");
		return;
	}
	String localName = request.getParameter("localName");
	System.out.println(localName + " <-- localName(updateLocalAction)");
	
	// 넘어온 새 지역명이 null이거나 공백이면
	if (request.getParameter("newLocalName") == null	
	|| request.getParameter("newLocalName").equals("")) {
		// 영문을 제외한 기타 문자(한글, 특수문자 등)를 인코딩된 값 URL에 포함하기 위해 설정
		localName = URLEncoder.encode(localName, "UTF-8"); 
		msg = URLEncoder.encode("새 지역명을 입력하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/updateLocalForm.jsp?localName=" + localName + "&msg=" + msg);
		return;
	}
	String newLocalName = request.getParameter("newLocalName");
	System.out.println(newLocalName + " <-- newLocalName(updateLocalAction)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updateLocalAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updateLocalAction)");
	
	// localName 중복 확인
	// newLocalName 기존값과 같은지 확인
	// SELECT COUNT(*) cnt FROM local WHERE local_name=?
	String cntSql = "SELECT COUNT(*) cnt FROM local WHERE local_name=?";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setString(1, newLocalName);
	System.out.println(cntStmt + " <-- cntStmt(updateLocalAction)");
	ResultSet cntRs = cntStmt.executeQuery();
	
	// newLocalName의 개수를 cnt에 저장
	// cnt = 0이면 중복 X		
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	System.out.println(cnt + " <-- cnt(updateLocalAction)");
	
	if (cnt > 0) {
		System.out.println("중복 카테고리 존재");
		msg = URLEncoder.encode("이미 존재하는 카테고리입니다", "UTF-8");
		localName = URLEncoder.encode(localName, "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/updateLocalForm.jsp?localName=" + localName + "&msg=" + msg);		
		return;
	} else {
		System.out.println("중복 카테고리 없음");
	}
	
	// local_name 값을 수정하는 쿼리
	// UPDATE local SET local_name=?, updatedate=NOW() WHERE local_name=?
	String updateSql = "UPDATE local SET local_name=?, updatedate=NOW() WHERE local_name=?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, newLocalName);
	updateStmt.setString(2, localName);
	System.out.println(updateStmt + " <-- updateStmt(updateLocalAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = updateStmt.executeUpdate();
	if (row == 1) { // 지역명 수정 성공
		System.out.println("지역명 수정 완료");
		msg = URLEncoder.encode("지역명이 변경되었습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/localOne.jsp?msg=" + msg);
	} else { // 지역명 수정 실패
		System.out.println("지역명 수정 실패");
		localName = URLEncoder.encode(localName, "UTF-8");
		response.sendRedirect(request.getContextPath() + "/local/updateLocalForm.jsp?localName=" + localName);
	}
	
	System.out.println("=============================");
	
%>