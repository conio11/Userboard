<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%
 	// 댓글 삭제(delete) 
 	// -> 쿼리문 where 조건 admin=? and comment_content=? 일 때 일부 댓글 삭제되지 않는 현상
	// -> comment_content=? 를 comment_no=? 바꾸어 해결
 	
 	// boardOne.jsp에서 삭제 버튼 클릭 -> deleteCommentForm.jsp로 이동 -> 삭제 버튼 클릭 시 deleteCommentAction.jsp로 이동
 	// boardOne.jsp 삭제 링크에 memberID, commentContent, boardNo 다 붙여서 넘김
 	// boardForm.jsp 에서 세션값 디버깅, 넘어온 memberID, commentContent, boardNo 디버깅
	
	// 로그인 상태일 때만 수정, 삭제 가능
	// 로그인 세션 아이디와 댓글 작성자가 같을 때만 삭제 가능	-> boardOne에서?
	// 로그인 세션 아이디: (String) session.getAttribute("loginMemberID")
	
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
	System.out.println(loginMemberID + " <-- loginMemberID(deleteCommentAction)"); // 세션 아이디 디버깅
	
	// 요청값 유효성 확인
	// 넘어온 기존 작성자명, 댓글 내용, 게시글 번호, 댓글 번호 중 하나라도 null 또는 공백일 경우 home2.jsp로 이동
	if (request.getParameter("memberID") == null
	|| request.getParameter("memberID").equals("")
	|| request.getParameter("commentContent") == null
	|| request.getParameter("commentContent").equals("")
	|| request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home2.jsp");
		return;
	}
	String memberID = request.getParameter("memberID");
	String commentContent = request.getParameter("commentContent");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo =  Integer.parseInt(request.getParameter("commentNo"));
	
	// memberID, commentContent, boardNo, commentNo 디버깅
	System.out.println(memberID + " <-- memberID(deleteContentAction)");
	System.out.println(commentContent + " <-- commentContent(deleteContentAction)");
	System.out.println(boardNo + " <-- boardNo(deleteContentAction)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(deleteCommentAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(deleteCommentAction)");
	
	// 댓글 삭제 (delete) 쿼리문 - comment 테이블에서 member_id, comment_no 해당하는 행 삭제
	String deleteSql = "DELETE FROM comment WHERE member_id=? AND comment_no=?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setString(1, memberID);
	deleteStmt.setInt(2, commentNo);
	System.out.println(deleteStmt + " <-- deleteStmt(deleteCommentAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = deleteStmt.executeUpdate();
	System.out.println(row + " <-- row(deleteCommentAction)");
	if (row == 1) { // 삭제 성공
		System.out.println("댓글 삭제 완료");
		msg = URLEncoder.encode("댓글이 삭제되었습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	} else { // 삭제 실패
		System.out.println("댓글 삭제 실패");
		msg = URLEncoder.encode("댓글이 삭제되지 않았습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	}
	
	System.out.println("=====================");
%>