<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ page import="java.sql.*,javax.servlet.*" %>
	<%
		String uname=request.getParameter("uname");
		String pwd=request.getParameter("pwd");
		
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","Krishna");
		Statement smt=conn.createStatement();
		PreparedStatement stmt = conn.prepareStatement("SELECT uname, con_pwd FROM userdetails WHERE uname = ?");
		stmt.setString(1, uname); // Set username parameter
		ResultSet rs = stmt.executeQuery();
		
		
		if (!rs.next() || !pwd.equals(rs.getString("con_pwd"))) {
		    out.print("<script>window.alert('Wrong credentials...'); window.location.href = 'main.html';</script>");
		} else {
		    // Successful login (redirect to signup.html using server-side redirection)
		    HttpSession ses = request.getSession();
		    ses.setAttribute("username", uname);
		    ses.setAttribute("password", pwd);
		    response.sendRedirect("booking.jsp");
		}
		

		
	%>
</body>
</html>