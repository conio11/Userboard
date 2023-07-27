<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %> 
<%
	// 댓글 수정 폼
	// comment 테이블의 member_id와 세션 아이디가 같아야 수정 가능 & comment_no 확인
	
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 확인: 세션 없는 경우(로그인 상태가 아닌 경우) home.jsp로 이동
	String msg = "";
	if (session.getAttribute("loginMemberID") == null) {
		msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + msg);
		return;
	}
	String loginMemberID = (String) session.getAttribute("loginMemberID");
	System.out.println(loginMemberID + " <-- loginMemberID(updateCommentForm)"); 
	
	// 요청값 유효성 확인
	// member_id 값이 넘어오지 않을 경우 boardOne.jsp로 이동
	if (request.getParameter("memberID") == null
	|| request.getParameter("memberID").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp");
		return;
	}
	
	String memberID = request.getParameter("memberID");
	System.out.println(memberID + " <-- memberID(updateCommentForm)");
	
	// comment_content 값이 넘어오지 않을 경우 boardOne.jsp로 이동
	if (request.getParameter("commentContent") == null
	|| request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp");
		return;
	}
	String commentContent = request.getParameter("commentContent");
	System.out.println(commentContent + " <-- commentContent(updateCommentForm)");
	
	// comment_no 값이 넘어오지 않을 경우 boardOne.jsp 로 이동
	if (request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp");
		return;
	}
	String commentNo = request.getParameter("commentNo");
	System.out.println(commentNo + " <-- commentNo(updateCommentForm)");
	
	// boardNo 값이 넘어오지 않을 경우 home.jsp로 이동 
	if (request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo + " <-- boardNo(updateCommentForm)"); // 게시글 번호 디버깅

	System.out.println("==========================================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updateCommentForm</title>
		<jsp:include page="/inc/link.jsp"></jsp:include>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		<div class="container mt-3">

		<br>
		<!-- 세션 아이디, member_id가 같은 경우에만 form 태그 출력 -->
		<%
			if (request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<%
			if (loginMemberID.equals(memberID)) {	
		%>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-success">이전</a><br>
				<div class="text-center">
					<h1>댓글 수정</h1>
				</div><br>
			<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=boardNo%>">
				<input type="hidden" name="commentNo" value="<%=commentNo%>">
				<input type="hidden" name="memberId" value="<%=memberID%>">
				
				<table class="table table-bordered">
					<tr>
						<th class="table-success text-center">작성자</th>
						<td><%=memberID%></td>
					</tr>
					<tr>
						<th class="table-success text-center">댓글 내용</th>
						<td><input type="text" name="commentContent" class="form-control"></td>
					</tr>
				</table>
				<button type="submit" class="btn btn-outline-success">댓글 수정</button>
			</form>
		<%
			} else {
		%>
				<h5>로그인 계정과 댓글 작성자가 일치하지 않습니다. 수정할 수 없습니다.</h5>
				<h5>현재 로그인 계정: <%=loginMemberID%></h5>
				
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-success">이전</a>
		<%
			}
		%>
		<br>
		<br>
		</div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>