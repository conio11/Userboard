<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    


<%-- <div class="btn-group">
		<a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-outline-primary">홈으로</a>
		<!--
		로그인 전: 회원가입 링크	
		로그인 후: 회원정보 / 로그아웃 (로그인 정보 세션: loginMemberID) 링크
		-->
		<%
			if (session.getAttribute("loginMemberID") == null) {
		%>
				<a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp" class="btn btn-outline-primary">회원가입</a>
		<% 
			} else { // 로그인 후 
		%>	
				<a href="<%=request.getContextPath()%>/member/memberInfo.jsp" class="btn btn-outline-primary">회원정보</a>
				<a href="<%=request.getContextPath()%>/local/localOne.jsp" class="btn btn-outline-primary">카테고리 정보</a>
				<a href="<%=request.getContextPath()%>/member/logoutAction.jsp" class="btn btn-outline-primary">로그아웃</a>
		<%
			}
		%>
</div> --%>


	<div class="p-5 bg-success text-white text-center">
	  <h1>Userboard</h1>
	  <p>카테고리(지역)별 게시판</p> 
	</div>
	
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
	  <div class="container-fluid">
	    <ul class="navbar-nav">
	      <li class="nav-item">
	        <a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a>
	      </li>
	      
   		<!--
		로그인 전: 회원가입 링크	
		로그인 후: 회원정보 / 로그아웃 (로그인 정보 세션: loginMemberID) 링크
		-->
   		<%
			if (session.getAttribute("loginMemberID") == null) {
		%>
	      	<li class="nav-item">
	          <a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a>
	        </li>
           </ul>
		<%
			} else { // 로그인 후
		%>
	      
	      
	      <li class="nav-item">
	        <a class="nav-link" href="<%=request.getContextPath()%>/member/memberInfo.jsp">회원정보</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="<%=request.getContextPath()%>/local/localOne.jsp">카테고리 정보</a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
	      </li>
	      <li class="float-end nav-item active">
	      	<p><%=(String) session.getAttribute("loginMemberID")%>님 접속</p>
	      </li>
	    </ul>
	    <%
			}
	    %>
	  </div>
	</nav>