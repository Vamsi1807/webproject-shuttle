<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%
        String uname = request.getParameter("uname");
        String pwd1 = request.getParameter("pwd1");
        String pwd2 = request.getParameter("pwd2");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
       
    %>
    <%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.util.Set, java.util.HashSet" %>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String que = null;
        String ans = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "System", "Krishna");

            String query = "SELECT que, ans FROM userdetails WHERE uname=?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, uname);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                que = rs.getString("que");
                ans = rs.getString("ans");
            } else {
                out.print("<script>window.alert('No data');window.location.href = 'forgotpassword.html';</script>");
            }

            if (que != null && ans != null) {
                if (que.equals(question) && ans.equals(answer)) {
                    if (pwd1.equals(pwd2)) {
                        String updateQuery1 = "UPDATE userdetails SET con_pwd = ? WHERE uname = ?";
                        String updateQuery2 = "UPDATE userdetails SET new_pwd = ? WHERE uname = ?";
                        
                        pstmt = conn.prepareStatement(updateQuery1);
                        pstmt.setString(1, pwd2);
                        pstmt.setString(2, uname);
                        pstmt.executeUpdate();

                        pstmt = conn.prepareStatement(updateQuery2);
                        pstmt.setString(1, pwd2);
                        pstmt.setString(2, uname);
                        pstmt.executeUpdate();

                        out.print("<script>window.alert('Password Updated..');window.location.href = 'booking.jsp';</script>");
                    } else {
                        out.print("<script>window.alert('Check the passwords..');window.location.href = 'forgotpassword.html';</script>");
                    }
                } else {
                    out.print("<script>window.alert('Invalid question/answer..');window.location.href = 'forgotpassword.html';</script>");
                }
            }

        } catch (Exception e) {
            out.print("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
