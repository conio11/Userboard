<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%
	// 댓글 수정(update)
	// 댓글 내용 없을 경우 페이지 리로딩 추가하기
	
	// 인코딩 설정
	response.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인 - 세션 없으면(로그인 상태가 아니면) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updateCommentAction)"); // 세션 아이디 디버깅
	
	// 요청값 유효성 확인
	// 넘어온 기존 작성자명, 댓글 내용, 게시글 번호, 댓글 번호 중 하나라도 null 또는 공백일 경우 home.jsp로 이동
	if (request.getParameter("memberID") == null
	|| request.getParameter("memberID").equals("")
	|| request.getParameter("commentContent") == null
	|| request.getParameter("commentContent").equals("")
	|| request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String memberID = request.getParameter("memberID");
	String commentContent = request.getParameter("commentContent");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo =  Integer.parseInt(request.getParameter("commentNo"));

	// memberID, commentContent, boardNo, commentNo 디버깅
	System.out.println(memberID + " <-- memberID(updateCommentAction)");
	System.out.println(commentContent + " <-- commentContent(updateContentAction)");
	System.out.println(boardNo + " <-- boardNo(updateContentAction)");
	System.out.println(commentNo + " <-- commentNo(updateContentAction)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updateCommentAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updateCommentAction)");
	
	// 댓글 수정 (update) 쿼리문 - comment 테이블에서 comment_no에 해당하는 행의 comment_content 수정
	String updateSql = "UPDATE comment SET comment_content=? WHERE comment_no=?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, commentContent);
	updateStmt.setInt(2, commentNo);
	System.out.println(updateStmt + " <-- updateStmt(updateCommectAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = updateStmt.executeUpdate();
	System.out.println(row + " <-- row(updateCommentAction)");
	if (row == 1) { // 수정 성공
		System.out.println("댓글 수정 완료");
		msg = URLEncoder.encode("댓글이 수정되었습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	} else { // 수정 실패
		System.out.println("댓글 수정 실패");
		msg = URLEncoder.encode("댓글이 수정되지 않았습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	}
	
	System.out.println("=====================");
%>