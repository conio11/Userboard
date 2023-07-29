<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="vo.*"%>
<%	
	// post 방식 인코딩 처리
	request.setCharacterEncoding("UTF-8");
	
	// 세션 유효성 확인 -> 요청값 유효성 확인
	
	// 세션 유효성 확인: 로그인 상태인 경우 home.jsp로 이동
	if (session.getAttribute("memberID") != null) { 
		response.sendRedirect(request.getContextPath() + "/home.jsp"); 
		return; // 실행 종료
	}
	
	// 요청값 유효성 확인
	// ID 또는 PW가 null값 또는 공백일 경우 회원가입 폼으로 이동
	String msg = null;
	if (request.getParameter("memberID") == null
	|| request.getParameter("memberPW") == null
	|| request.getParameter("memberID").equals("")
	|| request.getParameter("memberPW").equals("")) { 
		msg = URLEncoder.encode("아이디와 비밀번호를 모두 입력하세요", "UTF-8"); // URLEncoder.encode() 메소드: URL 인코딩 수행 -> 특수문자나 한글 등의 문자를 URL에서 사용할 수 있는 형식으로 변환
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg=" + msg);
		return; // 실행 종료
	}
	// 입력된 아이디, 비밀번호 변수로 저장
	String ID = request.getParameter("memberID");
	String PW = request.getParameter("memberPW");
	
	// 입력된 아이디, 비밀번호 디버깅
	System.out.println(ID + " <-- ID(insertMemberAction)");
	System.out.println(PW + " <-- PW(insertMemberAction)");
	
	// 요청값을 Member 클래스에 정리
	Member newMember = new Member();
	newMember.setMemberID(ID);
	newMember.setMemberPW(PW);
	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(insertMemberAction)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(insertMemberAction)");
	
	// 비밀번호 암호화 (PASSWORD(?))
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newMember.getMemberID());
	stmt.setString(2, newMember.getMemberPW());
	
	// 중복 ID 확인
	String sqlID = "SELECT member_id memberID FROM member WHERE member_id=?";
	PreparedStatement stmtID = null;
	stmtID = conn.prepareStatement(sqlID);
	stmtID.setString(1, newMember.getMemberID());
	ResultSet rsID = null;
	
	// stmt값 확인
	System.out.println(stmt + " <-- stmt(insertMemberAction)");
	System.out.println(stmtID + " <--stmtID(insertMemberAction)");
	
	rsID = stmtID.executeQuery(); // 쿼리 실행
	
	if (rsID.next()) { // ID가 중복되는 경우 (true일 때) 실행
		System.out.println("ID 중복(insertMemberAction)");
		msg = URLEncoder.encode("사용 중인 ID입니다", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg=" + msg);
		return; // 실행 종료
	}
	
	int row = stmt.executeUpdate();
	System.out.println(row + "<-- row(insertMemberAction)");
	
	if (row == 1) { // 회원가입 성공 시 home.jsp로 이동
		System.out.println("회원가입 성공");
		msg = URLEncoder.encode("회원가입 성공. 로그인 후 이용 가능합니다.", "UTF-8"); 
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg=" + msg);
	} else { // 실패 시 입력폼으로 이동
		System.out.println("회원가입 실패");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
	}
	
	System.out.println("==============================");
%>