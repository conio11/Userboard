# Userboard
카테고리별 게시판(카테고리/게시글/댓글 CRUD) 프로젝트
- 프로젝트 기능: 게시판 - 로그인 기능, 회원가입 및 탈퇴, 카테고리/게시글/댓글 CRUD
- 기간: 2023.05.02 - 2023.05.21
- 개발환경: Eclipse, HeidiSQL DB(MariaDB 3.1.3), WAS-Tomcat(9.0.75)
- 사용 언어: Java17(JSP), SQL 
- 현재 문제점:
    - 카테고리명 수정/삭제 안되는 현상(카테고리명 한글 깨짐) → form의 methood를 post에서 get 방식으로 변경하면 해결 (post 방식에서는 어떻게 해결할지)
    - 게시글 입력, 수정 시 제약조건 오류로 실행 안되는 현상 → form의 methood를 post에서 get 방식으로 변경하면 해결 (post 방식에서는 어떻게 해결할지)
    - 댓글 수정 시 한글 깨진 채로 저장되는 현상 → form의 methood를 post에서 get 방식으로 변경하면 해결 (post 방식에서는 어떻게 해결할지)
    - CSS 요소
