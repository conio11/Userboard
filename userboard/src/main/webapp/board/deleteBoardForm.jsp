<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %> 
<%
	// 세션 아이디와 member_id 일치해야 삭제 가능
	// board_no로 삭제
	
	// boardOne.jsp에서 boardNo, localName, boardTitle, boardContent, memberID 넘어옴
	// 아래에서 유효값 디버깅
	
	// 인코딩 설정
	response.setCharacterEncoding("UTF-8");

 	// 세션 유효성 확인: 세션 없는 경우(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(deleteBoardForm)"); 

	// 요청값 유효성 확인
	// boardNo, localName, boardTitle, boardContent, memberID 값이 넘어오지 않을 경우 boardOne.jsp로 이동
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
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp");
		return;
	} 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String memberID = request.getParameter("memberID");
	
	// boardNo, localName, boardTitle, boardContent, memberID 디버깅
	System.out.println(boardNo + " <-- boardNo(deleteBoardForm)"); // 게시글 번호 디버깅
	System.out.println(localName + " <-- localName(deleteBoardForm)"); 
	System.out.println(boardTitle + " <-- boardTitle(deleteBoardForm)"); 
	System.out.println(boardContent + " <-- boardContent(deleteBoardForm)"); 
	System.out.println(memberID + " <-- memberID(deleteBoardForm)"); 

	System.out.println("===============================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deleteBoardForm</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<br>
		<!-- 세션 아이디와 member_id가 같은 경우만 form 태그 출력 -->
		<%
			if (loginMemberID.equals(memberID)) {
		%>
			<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
				<table class="table table-bordered">
					<tr>
						<th class="table-primary text-center">boardNo</th>
						<td><input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="table-primary text-center">localName</th>
						<td><input type="text" name="localName" value="<%=localName%>" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="table-primary text-center">boardTitle</th>
						<td><input type="text" name="boardTitle" value="<%=boardTitle%>" readonly="readonly"></td>
					</tr >
					<tr>
						<th class="table-primary text-center">boardContent</th>
						<td><input type="text" name="boardContent" value="<%=boardContent%>" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="table-primary text-center">memberID</th>
						<td><input type="text" name="memberID" value="<%=memberID%>" readonly="readonly"></td>
					</tr>
				</table>
				<button type="submit" class="btn btn-outline-primary">게시글 삭제</button>
			</form>
		<%
			} else {
		%>
				<h5>로그인 계정과 게시글 작성자가 일치하지 않습니다. 삭제할 수 없습니다.</h5>
				<h5>현재 로그인 계정: <%=loginMemberID%></h5>
				
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-primary">이전</a>
		<%	
			}
		%>
		<br>
		<br>
		<div >
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</body>
</html>