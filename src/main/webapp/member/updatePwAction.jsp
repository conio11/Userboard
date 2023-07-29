<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*" %>

<% 
	// 비밀번호 수정(update)
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인: 로그인 상태가 아닌 경우 home.jsp로 이동
	// 세션 아이디 확인
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return; // 실행 종료
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updatePwAction)");
	
	// updatePwForm.jsp 입력값 확인
	String currentPw = request.getParameter("currentPw");
	String newPw = request.getParameter("newPw");
	String newPw2 = request.getParameter("newPw2");
	
	System.out.println(currentPw + " <-- currentPw(updatePwAction)");
	System.out.println(newPw + " <-- currentPw(updatePwAction)");
	System.out.println(newPw2 + " <-- currentPw(updatePwAction)");
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(updatePwAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(updatePwAction)");
	
	// 비밀번호 변경(update) 쿼리문
	// UPDATE member SET member_pw=PASSWORD(?) WHERE member_id=? AND member_pw=PASSWORD(?)
	String pwSql = "UPDATE member SET member_pw = PASSWORD(?), updatedate = NOW() WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setString(1, newPw);
	pwStmt.setString(2, loginMemberID);
	pwStmt.setString(3, currentPw);
	System.out.println(pwStmt + " <-- pwStmt(updatePwAction)");
	
	// String msg = "";
	if (currentPw == null || currentPw.equals("")) {
		msg = URLEncoder.encode("기존 비밀번호를 입력해주세요", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	} else if (newPw == null || newPw.equals("")){
		msg = URLEncoder.encode("새 비밀번호를 입력해주세요", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	}
	
	if (currentPw.equals(newPw)) {
		msg = URLEncoder.encode("기존 비밀번호와 다르게 입력해주세요", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	}
	
	if (!newPw.equals(newPw2)) {
		msg = URLEncoder.encode("새 비밀번호가 틀렸습니다", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
		return;
	}
	
	// 쿼리 실행 -> row값 1이면 정상 실행, 그 외에는 오류(예외)
	int row = pwStmt.executeUpdate();
	if (row == 1) {
		msg = URLEncoder.encode("비밀번호 변경 완료. 다시 로그인하세요.", "UTF-8");
		session.invalidate(); // 세션 정보 삭제
		System.out.println("비밀번호 변경 완료");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
	} else {
		msg = URLEncoder.encode("비밀번호 변경 실패. 기존 비밀번호를 정확히 입력하세요", "UTF-8"); 
		System.out.println("비밀번호 변경 실패");
		response.sendRedirect(request.getContextPath() + "/member/updatePwForm.jsp?msg=" + msg);
	}
	
	System.out.println("=====================");
 
%>
