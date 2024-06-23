<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details</title>
</head>
<body>
    <%@ page import="java.sql.*, java.io.*, java.util.*" %>
    <%
    String email = request.getParameter("email");
    String password = request.getParameter("pwd1");
    String conpwd = request.getParameter("pwd2");
    String username = request.getParameter("uname");
    String gender = request.getParameter("gender");
    String birthdate = request.getParameter("birthday");
    String question = request.getParameter("question");
    String answer = request.getParameter("answer");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Loading Oracle JDBC Driver
        Class.forName("oracle.jdbc.driver.OracleDriver");
        
        // Establishing connection to the database
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "System", "Krishna");
        
        // Checking if passwords match
        if(password.equals(conpwd)){
            // Preparing SQL statement
            String sql = "INSERT INTO userdetails (email, new_pwd, con_pwd, uname, gender, dob, que, ans) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // Setting parameters for SQL statement
            pstmt.setString(1, email);
            pstmt.setString(2, password); // Store password (ideally hashed in real applications)
            pstmt.setString(3, conpwd);
            pstmt.setString(4, username);
            pstmt.setString(5, gender);
            pstmt.setString(6, birthdate);
            pstmt.setString(7, question);
            pstmt.setString(8, answer);

            // Executing SQL statement
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>window.alert('Registration successfull!!'); window.location.href = 'main.html';</script>");
            } else {
                out.print("<script>window.alert('Error in user registration. Please try again.'); window.location.href = 'signup.html';</script>");
            }
        } else {
            out.print("<script>window.alert('Passwords mismatch. Please try again.'); window.location.href = 'signup.html';</script>");
        }
    } catch (SQLException e) {
        // Handle SQL errors
        
        out.print(e);
    } catch (Exception e) {
    	out.print(e);
    } finally {
        // Closing the PreparedStatement
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Closing the Connection
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>
</body>
</html>
