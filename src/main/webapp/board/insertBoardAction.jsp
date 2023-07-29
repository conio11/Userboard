<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*"%> 
<%@ page import="java.sql.*"%>

<%
	// 새 게시글 추가(localName, boardTitle, boardContent)
	// 하나라도 입력되지 않았을 경우 insertBoardForm.jsp로 
	
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
	System.out.println(loginMemberID + " <-- loginMemberID(updateBoardAction)"); // 세션 아이디 디버깅
	
	// 요청값 유효성 확인
	// insertBoardForm.jsp에서 넘어온 localName, boardTitle, boardContent 중 하나라도 null 또는 공백일 경우 insertBoardForm.jsp로 이동
	if (request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")
	|| request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")
	|| request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")) {
		msg = URLEncoder.encode("카테고리명, 게시글 제목, 내용을 모두 입력해주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?msg=" + msg);
		return;
	}
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	// localName, boardTitle, boardContent 디버깅
	System.out.println(localName + " <-- localName(insertBoardAction)");
	System.out.println(boardTitle + " <-- boardTitle(insertBoardAction)");
	System.out.println(boardContent + " <-- boardContent(insertBoardAction)");

	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updateBoardAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updateBoardAction)");
	
	// 게시글 입력(insert) 쿼리문 - board 테이블에 board_no 제외 모든 컬럼값 입력
	String insertSql = "INSERT INTO board (local_name, board_title, board_content, member_id, createdate, updatedate) VALUES (?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setString(1, localName);
	insertStmt.setString(2, boardTitle);
	insertStmt.setString(3, boardContent);
	insertStmt.setString(4, loginMemberID);
	System.out.println(insertStmt + " <-- insertStmt(insertBoardAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = insertStmt.executeUpdate();
	System.out.println(row + " <-- row(insertBoardAction)");
	if (row == 1) { // 수정 성공
		System.out.println("게시글 입력 완료");
		msg = URLEncoder.encode("게시글이 입력되었습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
	} else { // 수정 실패
		System.out.println("게시글 입력 실패");
		msg = URLEncoder.encode("게시글이 입력되지 않았습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
	}
	
	System.out.println("=====================");
%>