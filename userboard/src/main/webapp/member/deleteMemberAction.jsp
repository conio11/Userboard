<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>
<%
	// 회원 탈퇴(delete)	
	// 세션 유효성 확인 - 로그인 상태가 아닌 경우 home.jsp로 이동
	// 세션 아이디 확인
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}

	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(deleteMemberAction)");
	
	// deleteMemberForm.jsp 입력값(유효성) 확인
	if (request.getParameter("currentPw") == null
	|| request.getParameter("currentPw").equals("")) {
		msg = URLEncoder.encode("비밀번호를 입력해주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/deleteMemberForm.jsp?msg=" + msg);
		return;
	}
	
	String currentPw = request.getParameter("currentPw");
	System.out.println(currentPw + " <-- currentPw(deleteMemberPw)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(deleteMemberAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(deleteMemberAction)");
	
	// 회원정보 탈퇴(delete) 쿼리문
	// DELETE FROM member WHERE member_id=? AND member_pw=?
	String deleteSql = "DELETE FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setString(1, loginMemberID);
	deleteStmt.setString(2, currentPw);
	System.out.println(deleteStmt + " <-- deleteStmt(deleteMemberAction)");
	
	// 쿼리 실행 -> row 값 1이면 정상 실행, 그 외에는 오류(예외)
	int row = deleteStmt.executeUpdate();
	if (row == 1) {
		msg = URLEncoder.encode("회원 탈퇴가 완료되었습니다", "UTF-8");
		session.invalidate(); // 세션 정보 삭제
		System.out.println("회원 탈퇴 완료");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
	} else {
		msg = URLEncoder.encode("비밀번호가 틀렸습니다. 다시 입력해주세요", "UTF-8");
		System.out.println("회원 탈퇴 실패");
		response.sendRedirect(request.getContextPath() + "/member/deleteMemberForm.jsp?msg=" + msg);
	}
	
	System.out.println("=====================");
%>