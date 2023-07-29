<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%
	// post 방식 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인 (로그인 여부)
	// 세션 아이디값 없으면 (로그인되지 않은 상태이면) home.jsp로 이동
	String msgComment = "";
	
	if (session.getAttribute("loginMemberID") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return; // 실행 종료
	}
	String memberID = (String) session.getAttribute("loginMemberID");
	
	// 요청값 유효성 확인 (boardNo, commentContent) 
	// boardNo 값이 null 또는 공백이면 home2.jsp로 이동
	// commentContent 값이 null 또는 공백이면 boardOne.jsp?=boardNo=?로 이동 (입력폼 다시 실행)
	if (request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return; // 실행 종료
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	if (request.getParameter("commentContent") == null 
	|| request.getParameter("commentContent").equals("")) {
		msgComment = URLEncoder.encode("댓글을 입력해주세요.", "UTF-8");	
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msgComment=" + msgComment);
		return; // 실행 종료
	}
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(memberID + " <-- memberID(insertCommentAction)");
	System.out.println(boardNo + " <-- boardNo(insertCommentAction)");
	System.out.println(commentContent + " <-- commentContent(insertCommentAction)");
	
	// 모델 뷰
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(insertCommentAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(insertCommentAction)");
	
	// comment 테이블에 내용 입력하는 쿼리
	String commentSql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql); 	
	commentStmt.setInt(1, boardNo);
	commentStmt.setString(2, commentContent);
	commentStmt.setString(3, memberID);
	System.out.println(commentStmt + " <-- commentStmt(insertCommentAction)");
	// ResultSet commentRs = commentStmt.executeQuery(); // 실행 중복 // 필요없는 코드
	
	// 쿼리 결과
	int row = commentStmt.executeUpdate();
	if (row == 1) { // 댓글 입력 성공
		System.out.println("댓글 입력 성공(insertCommentAction)");
		msgComment = URLEncoder.encode("댓글이 작성되었습니다.", "UTF-8");
	} else { // 입력 실패
		System.out.println("댓글 입력 실패(insertCommentAction)");
		msgComment = URLEncoder.encode("댓글이 작성되지 않았습니다.", "UTF-8");
	}
	
	// 모든 과정 종료 후 boardOne.jsp로 이동
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msgComment=" + msgComment);
	
	System.out.println("====================================");
%>