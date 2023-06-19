<%@ page import="kr.ezen.model.MemberDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%	
	ArrayList<MemberDTO> memberList= (ArrayList<MemberDTO>)request.getAttribute("list");
%>    
<!DOCTYPE html>
<html lang='en'>                                                                                            
<head>                                                                                                      
  <title>Bootstrap Example</title>                                                                          
  <meta charset='utf-8'>                                                                                    
  <meta name='viewport' content='width=device-width, initial-scale=1'>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>                                      
  <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css' rel='stylesheet'>    
  <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js'></script>      
</head>                                                                                                     
<body>                                                                                                      
<div class='container mt-3'>                                                                                
  <h2>회원 리스트</h2>                                                                                      
  <table class='table'>                                                                                     
    <thead class='table-dark'>                                                                              
      <tr>                                                                                                  
        <th>번호</th>                                                                                       
        <th>아이디</th>                                                                                     
        <th>비밀번호</th>                                                                                   
        <th>이름</th>                                                                                       
        <th>나이</th>                                                                                       
        <th>이메일</th>                                                                                     
        <th>전화번호</th>                                                                                   
        <th>삭제</th>                                                                                       
      </tr>                                                                                                 
    </thead>                                                                                                
    <tbody>                                                                                                 

<% for(MemberDTO dto : memberList) { %>
	<tr>                                                                                                 
	  <td><%=dto.getNo() %></td>                                                                           
	  <td><a href='memberInfo.do?no=<%=dto.getNo()%>'><%=dto.getId()%></a></td>                          
	  <td><%=dto.getPw()%></td>                                                                           
	  <td><%=dto.getName()%></td>                                                                         
	  <td><%=dto.getAge()%></td>                                                                          
	  <td><%=dto.getEmail()%></td>                                                                        
	  <td><%=dto.getTel()%></td>                                                                          
	  <td><input type="button" class='btn btn-danger btn-sm' value="삭제" onclick="delMember(<%=dto.getNo() %>)"/></td>                                                                 
	</tr>                                                                                                
<%}%>
<!-- Ajax 리스트 -->
	<tr>
		<td colspan="7">
			<input type="button" value="Ajax회원리스트" class="btn btn-secondary" 
				onclick="showList()"/>
		</td>
	</tr>
	<tr>
		<td colspan="7" id="ajaxList"></td>
	</tr>
<!-- Ajax End -->

      <tr>                                                                                                    
      	<td colspan='8' class='text-center'><a href='memberRegister.do' class='btn btn-primary'>회원가입</a></td>
      </tr>                                                                                               
    </tbody>                                                                                              
  </table>                                                                                                
</div>   
<script>
	function showList(){
		$.ajax({
			url:"<c:url value='/memberAjaxList.do'/>",
			type : "get", // 서버에 전송하기 위한 전송방식
			dataType:"json", // 서버에서 응답하는 데이터 형식
			success: resultList, // 서버에서 성공적으로 요청이 수행되었을 때 resultList 콜백함수 호출
			erorr: function(){alert("error")} // 서버에서 요청처리가 실패됬을때 
		});
	}
	
	function resultList(data){
		console.log(data);
		
	let html= "<table class='table'>";                                                                                     
	 html+="   <thead class='table-dark'>  ";                                                                            
	 html+="     <tr>                      ";                                                                            
	 html+="       <th>번호</th>           ";                                                                            
	 html+="       <th>아이디</th>         ";                                                                            
	 html+="       <th>비밀번호</th>       ";                                                                            
	 html+="       <th>이름</th>           ";                                                                            
	 html+="       <th>나이</th>           ";                                                                            
	 html+="       <th>이메일</th>         ";                                                                            
	 html+="       <th>전화번호</th>       ";                                
	 html+="     </tr>                     ";                                                                            
	 html+="   </thead>                    ";                                                                            
	 html+="   <tbody>                     ";
	
	$.each(data, function(index, obj){
		html+="<tr>";
		html+="<td>"+obj.no+"</td>";	
		html+="<td>"+obj.id+"</td>";	
		html+="<td>"+obj.pw+"</td>";	
		html+="<td>"+obj.name+"</td>";	
		html+="<td>"+obj.age+"</td>";	
		html+="<td>"+obj.email+"</td>";	
		html+="<td>"+obj.tel+"</td>";
		html+="</tr>";
	}); 
		html+="</tbody>";
		html+="</table>";
	
		$("#ajaxList").html(html);
	} // End function 
	
	function delMember(no){
		location.href="memberDelete.do?no="+no;
	}
</script>

                                                                                                 
</body>                                                                                                   
</html>																									  