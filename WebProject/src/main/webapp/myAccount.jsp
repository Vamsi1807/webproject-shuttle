<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Account</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background-color: #3b9b0f60;
    }
    .container {
        max-width: 600px;
        margin: 0 auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(49, 52, 231, 0.74);
        text-align:center;
    }
    h1 {
        text-align: center;
        color: #333;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background-color: #f2f2f2;
    }
    input[type="submit"] {
        border-radius: 3px;
        background-color: blue;
        color: white;
        padding: 10px 20px;
        border: none;
        cursor: pointer;
    }
    input[type="submit"]:hover {
        background-color: darkblue;
    }
    img.logo {
        max-width: 100px;
        margin-bottom: 20px;
    }
</style>
</head>
<body>
    <%@ page import="java.sql.*, java.util.*" %>
    <%
        String uname = (String) session.getAttribute("username");
        if (uname == null) {
            response.sendRedirect("main.html");
            return;
        }

        String email = "";
        String dob = "";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "System", "Krishna");

            String query = "SELECT email, dob FROM userdetails WHERE uname = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, uname);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                email = rs.getString("email");
                dob = rs.getString("dob");
            } else {
                out.print("No user details found for username: " + uname);
            }
        } catch (Exception e) {
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
    <div class="container">
        <img src="images/logo.jpeg" class="logo" alt="Logo">
        <h1>My Account</h1>
        <table>
            <tr>
                <th>Username</th>
                <td><%= uname %></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%= email %></td>
            </tr>
            <tr>
                <th>Date Of Birth</th>
                <td><%= dob %></td>
            </tr>
        </table><br>
       


        <h1>Previous bookings</h1>
        <table>
            <%
                Connection conn1 = null;
                PreparedStatement pstmt1 = null;
                ResultSet rs1 = null;

                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    conn1 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "System", "Krishna");

                    String q2 = "SELECT completedate as day,play as time,court,booking_id as Id FROM project where username = ?  order by day desc";
                    pstmt1 = conn1.prepareStatement(q2);
                    pstmt1.setString(1, uname);
                    rs1 = pstmt1.executeQuery();
					
                    ResultSetMetaData rsmd = rs1.getMetaData();
                    int columnCount = rsmd.getColumnCount();

                    out.print("<tr>");
                    for (int i = 1; i <= columnCount; i++) {
                        out.print("<th>" + rsmd.getColumnName(i) + "</th>");
                    }
                    out.print("</tr>");

                    while (rs1.next()) {
                        out.print("<tr>");
                        for (int i = 1; i <= columnCount; i++) {
                            String value = rs1.getString(i);
                            out.print("<td>" + value + "</td>");
                        }
                        out.print("</tr>");
                    }
                    
                    
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs1 != null) rs1.close();
                        if (pstmt1 != null) pstmt1.close();
                        if (conn1 != null) conn1.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </table><br>
        <form method="post" action="booking.jsp">
            <input type="submit" value="HOME">
        </form>
    </div>
</body>
</html>
