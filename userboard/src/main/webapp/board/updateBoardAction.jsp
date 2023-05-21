<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%
	// 게시글 수정 (update)
	// 게시글 내용 없을 경우 페이지 리로딩 추가 -> 어디로 넘길지 
	
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
	System.out.println(loginMemberID + " <-- loginMemberID(updateBoardAction)"); // 세션 아이디 디버깅
	
	// 요청값 유효성 확인
	// updateBoardForm.jsp에서 넘어온 기존 게시글 번호, 작성자명 중 하나라도 null 또는 공백일 경우 home.jsp로 이동
	if (request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("memberID") == null
	|| request.getParameter("memberID").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberID = request.getParameter("memberID");
	
	// boardNo, memberID 디버깅
	System.out.println(boardNo + " <-- boardNo(updateBoardAction)");
	System.out.println(memberID + " <-- memberID(updateBoardAction)"); // 여기까지 출력 후 boardOne으로 넘어감
	
	// 요청값 유효성 확인
	// updateBoardForm.jsp에서 넘어온 입력값이 하나라도 null 또는 공백값일 경우 boardOne.jsp로 이동
 	if (request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")
	|| request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")
	|| request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")) {
		String msg2 = URLEncoder.encode("게시글 수정 시 카테고리명, 글 제목, 내용을 모두 입력해주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg2=" + msg2);
		return;
	}
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	// localName, boardTitle, boardContent 디버깅
	System.out.println(localName + " <-- localName(updateBoardAction)");
	System.out.println(boardTitle + " <-- boardTitle(updateBoardAction)");
	System.out.println(boardContent + " <-- boardContent(updateBoardAction)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updateBoardAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updateBoardAction)");
	
	// 게시글 수정(update) 쿼리문 - board 테이블에서 board_no에 해당하는 행의 local_name, board_title, board_content 수정
	String updateSql = "UPDATE board SET local_name=?, board_title=?, board_content=? WHERE board_no=?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, localName);
	updateStmt.setString(2, boardTitle);
	updateStmt.setString(3, boardContent);
	updateStmt.setInt(4, boardNo);
	System.out.println(updateStmt + " <-- updateStmt(updateBoardAction)");
	
	// 쿼리 실행 및 실행값 반환
	int row = updateStmt.executeUpdate();
	System.out.println(row + " <-- row(updateBoardAction)");
	if (row == 1) { // 수정 성공
		System.out.println("게시글 수정 완료");
		msg = URLEncoder.encode("게시글이 수정되었습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	} else { // 수정 실패
		System.out.println("게시글 수정 실패");
		msg = URLEncoder.encode("게시글이 수정되지 않았습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
	}
	
	System.out.println("=====================");
%>