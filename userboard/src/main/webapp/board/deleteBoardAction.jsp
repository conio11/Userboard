<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%
	// 게시글 삭제(delete)
	// 쿼리문 where 조건 -> boardNo=? 일 때 해당 게시글 행 삭제
			
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
	System.out.println(loginMemberID + " <-- loginMemberID(deleteBoardAction)"); // 세션 아이디 디버깅
	// 여기까지 출력되고 홈으로 넘어가는 현상
			
	// 요청값 유효성 확인
	// 넘어온 기존 게시글 번호, 카테고리명(지역명), 제목, 내용, 작성자명 중 하나라도 null 또는 공백일 경우 home.jsp로 이동
	if (request.getParameter("boardNo") == null		
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("localName") == null	
	|| request.getParameter("localName").equals("")
	|| request.getParameter("boardTitle") == null	
	|| request.getParameter("boardTitle").equals("")
	|| request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")
	|| request.getParameter("memberID") == null 
	|| request.getParameter("memberID").equals("")) {
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		String localName = request.getParameter("localName");
		String boardTitle = request.getParameter("boardTitle");
		String boardContent = request.getParameter("boardContent");
		String memberID = request.getParameter("memberID");
		
		System.out.println(boardNo + " <-- boardNo(deleteBoardAction)");
		System.out.println(localName + " <-- boardlocalName(deleteBoardAction)");
		System.out.println(boardTitle + " <-- boardTitle(deleteBoardAction)");
		System.out.println(boardContent + " <-- boardContent(deleteBoardAction)");
		System.out.println(memberID + " <-- memberID(deleteBoardAction)");
		
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	} 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String memberID = request.getParameter("memberID");
	
	// boardNo, localName, boardTitle, boardContent, memberID 디버깅

	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(deleteBoardAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(deleteBoardAction)");
	
	// 게시글 삭제 (delete) 쿼리문 - board 테이블에서 board_no=? 에 해당하는 행 삭제
	String deleteSql = "DELETE FROM board WHERE board_no=?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setInt(1, boardNo);
	System.out.println(deleteStmt + " <-- deleteStmt(deleteBoardAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = deleteStmt.executeUpdate();
	System.out.println(row + " <-- row(deleteBoardAction)");
	if (row == 1) { // 삭제 성공
		System.out.println("게시글 삭제 완료");
		msg = URLEncoder.encode("게시글이 삭제되었습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
	} else { // 삭제 실패
		System.out.println("게시글 삭제 실패");
		msg = URLEncoder.encode("게시글이 삭제되지 않았습니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	}
	
	System.out.println("=====================");
%>