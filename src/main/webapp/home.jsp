<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*" %>
<%
	// * 요청분석(컨트롤러 계층) 후 모델 계층 생성
	
	//인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 1)) session - JSP내장(기본) 객체

	// 2)) request / response JSP내장(기본) - 객체
	int currentPage = 1;
	if (request.getParameter("currentPage") != null && !request.getParameter("currentPage").equals("")) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " <-- currenetPage(home)");
		
	// 페이지당 출력되는 행 수
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	System.out.println(startRow + " <-- startRow(home)");
	
	System.out.println(request.getParameter("localName") + " <- param localName(home)"); // 현재 설정된 지역명 디버깅
	String localName = "전체";
	if (request.getParameter("localName") != null) {
		localName = request.getParameter("localName");
	}
	System.out.println(localName + " <-- localName(home)");
	
	//DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	System.out.println("드라이버 로딩 성공(home)");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println("DB 접속 성공(home)");
	
	// 1) 서브메뉴 출력 쿼리
	// 전체 행 수, 지역별 행 수 구하는 쿼리
	/*
	SELECT '전체' localName, COUNT(local_name) cnt FROM board
	UNION ALL
	SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
	*/

	// 전체 개수와 지역명별 컬럼 개수를 구하는 쿼리
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList -> 모델 데이터
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while (subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	System.out.println(subMenuList + " <-- subMenuList(home)");
	
	// 2) 게시판 목록 결과셋(모델)
	String boardSql = "";
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	
	/*
		SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate, updatedate
		FROM board where local_name=?
		ORDER BY createdate DESC
		LIMIT ?, ?
	*/
	
	if (localName.equals("전체")) {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, startRow);
		boardStmt.setInt(2, rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board where local_name=? ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
	}
	
	boardRs = boardStmt.executeQuery(); // DB 쿼리 결과셋 포함
	// boardRs -> boardList 이동
	ArrayList<Board> boardList = new ArrayList<Board>(); // 애플리케이션에서 사용할 모델 (현재 사이즈 0)
	while (boardRs.next()) { 
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	
	System.out.println(boardList + " <--boardList(home)");
	System.out.println(boardList.size() + " <--boardList.size()(home)");
	
	// 마지막 페이지 모델링 수정 (지역별 행 수 맞추기)
	String pageSql = "";
	if (localName.equals("전체")) {
		pageSql = "SELECT COUNT(*) FROM board";
	} else {
		pageSql = "SELECT COUNT(*) FROM board WHERE local_name = ?";
	}
	
	PreparedStatement pageStmt = conn.prepareStatement(pageSql);
	if (!localName.equals("전체")) {
		pageStmt.setString(1, localName);
	}
	
	ResultSet pageRs = pageStmt.executeQuery();
	
	int totalRow = 0;
	if (pageRs.next()) {
		totalRow = pageRs.getInt("COUNT(*)");
	}
	
	int lastPage = totalRow / rowPerPage;
	if (totalRow % rowPerPage != 0) {
		lastPage += 1;
	}
	
	// 전체 게시글 수, 마지막 페이지 번호 디버깅
	System.out.println(totalRow + " <-- totalRow(home)");
	System.out.println(lastPage + " <-- lastPage(home)");
	
	System.out.println("====================================");
%>  
    
<!DOCTYPE html>
<html>
	<head>
	      <title>home</title>
	      <jsp:include page="/inc/link.jsp"></jsp:include>
		  <meta charset="utf-8">
		  <meta name="viewport" content="width=device-width, initial-scale=1">
		  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		  <script src="https://cdn.jsEdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		  <style>
		  	.fakeimg {
			    height: 200px;
			    background: #aaa;
			  }
		  
	
			.page-link {
				color: #198754; /* 부트스트랩5 success 컬러코드*/
			}
			.page-item.active .page-link {
				color: white;
				background-color: #198754;
				border-color: #198754;
			} 
		  </style>
	  <!-- ... CSS 및 JavaScript 링크 및 스타일 ... -->
	</head>
	<body>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include> <!-- mainmenu.jsp 의 결과를 현재 페이지에서 사용 가능 -->
	  <div class="container mt-5">
	    <div class="row">
	      <!-- 왼쪽 컬럼 (로그인 폼 및 서브 카테고리) -->
	      <div class="col-sm-4">
	        <!-- 로그인 폼 -->
	        <div class="container mt-3">
	          <% if (request.getParameter("msg") != null) { %>
	            <%= request.getParameter("msg") %>
	          <% 
	          	}
	          %>
	          
	          <% if (session.getAttribute("loginMemberID") == null) { %>
	            <form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post" accept-charset="UTF-8"> 
	              <table class="table table-bordered table-sm">
	                <tr>
	                  <th class="table-success text-center">ID</th>
	                  <td><input type="text" name="memberID" class="form-control" value="user1" placeholder="ID를 입력하세요."></td>
	                </tr>
	                <tr>
	                  <th class="table-success text-center">PW</th>
	                  <td><input type="password" name="memberPW" class="form-control" value="1234" placeholder="비밀번호룰 입력하세요."></td>
	                </tr>
	              </table>
	              <button type="submit" class="btn btn-outline-success">로그인</button>
	            </form>
	            <br>
	          <% 
	          	} else { 
	       	   %>
	            <p style="color: blue;"><%= session.getAttribute("loginMemberID") %>님, 반갑습니다.</p>
	          <% 
	          	} 
	       	   %>
	        </div>
	        
	        <!-- 서브 카테고리 -->
	        <div class="container mt-3">
	          <ul class="list-group">
	            <% for (HashMap<String, Object> m : subMenuList) { %>
	              <li>
	                <a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>" class="btn">
	                  <%=m.get("localName")%>(<%=m.get("cnt")%>) <!-- Object 타입이므로 형변환 -->
	                </a>
	              </li>
	            <% } %>
	          </ul>
	        </div>
	      </div>
	      
	      <!-- 오른쪽 컬럼 (테이블) -->
	      <div class="col-sm-8">
	        <table class="table table-bordered text-center">
	          <tr class="table-success">
	            <th>카테고리명</th>
	            <th>게시글 제목</th>
	            <th>작성일자</th>
	          </tr>
	          <!-- <c:foreach var="b" items="boardList"></c:foreach> -->
	          
	          <% for (Board b : boardList) { %>
	            <tr>
	              <td><%=b.getLocalName()%></td> 
	              <td>
	                <a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>" class="btn btn-outline-light text-dark">
	                  <%=b.getBoardTitle()%>
	                </a>
	              </td>
	              <td><%=b.getCreatedate().substring(0, 10)%></td>
	            </tr>	
	          <% } %>
	        </table>
	        <a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp" class="btn btn-outline-success">게시글 작성</a>
	        
			<%
				// 페이지 네비게이션 페이징
				int pagePerPage = 10; // [이전] [다음] 탭 사이 페이지 개수
				
				// minPage: [이전] [다음] 탭 사이 가장 작은 숫자
				// maxPage: [이전] [다음] 탭 사이 가장 큰 숫자
				int minPage = ((currentPage - 1) / pagePerPage) * pagePerPage + 1;
				int maxPage = minPage + (pagePerPage - 1);
				if (maxPage > lastPage) { // maxPage가 마지막 페이지(최대 currentPage) 보다 클 수 없음
					maxPage = lastPage;
				}
			%>
	        <div class="text-center mt-3">
	          <ul class="pagination justify-content-center">
	            <% if (minPage > 1) { %>
	              <li class="page-item">
	                <a class="page-link" href="./home.jsp?currentPage=<%=minPage - pagePerPage%>&localName=<%=localName%>">Previous</a>
	              </li>
	            <% 
	            	}
	            %>
	            <% for (int i = minPage; i <= maxPage; i++) { %>
	              <li class="page-item <%= i == currentPage ? "active" : "" %>">
	                <a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a>
	              </li>
	            <% } %>
	            
	            <% if (maxPage < lastPage) { %>
	              <li class="page-item">
	                <a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage + pagePerPage%>&localName=<%=localName%>">Next</a>
	              </li>
	            <% 
	            	} 
	           	%>
	          </ul>
	        </div> 
	      </div>
	      
	    </div>
	  </div>
	  
	  <jsp:include page="/inc/copyright.jsp"></jsp:include>
	</body>
</html>