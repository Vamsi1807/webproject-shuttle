<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking Confirmation</title>
</head>
<body>
<meta charset="UTF-8">
    
    <title>Shuttle Court Booking Bill</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .bill-container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            background-color: #fff;
        }
        .bill-title {
            text-align: center;
            font-size: 1.2em;
            margin-bottom: 10px;
            color: #333;
        }
        .bill-info {
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }
        .bill-info span:first-child {
            font-weight: bold;
            color: #666;
        }
        .company-info {
            text-align: right;
            margin-bottom: 15px;
            font-size: 0.9em;
            color: #aaa;
        }
        .qr-code {
            width: 100px;
            margin: 0 auto;
        }
        @media print {
            .company-info, .qr-code {
                display: none;
            }
        }
        body{
        	text-align : center;
        }
        
        .print{
        	
                display: inline-block;
                outline: 0;
                cursor: pointer;
                border: none;
                padding: 0 56px;
                height: 45px;
                line-height: 45px;
                border-radius: 7px;
                background-color: #0070f3;
                color: white;
                font-weight: 400;
                font-size: 16px;
                box-shadow: 0 4px 14px 0 rgb(0 118 255 / 39%);
                transition: background 0.2s ease,color 0.2s ease,box-shadow 0.2s ease;
                :hover{
                    background: rgba(0,118,255,0.9);
                    box-shadow: 0 6px 20px rgb(0 118 255 / 23%);
                }
                	
        }
        
        
     input[type="submit"] {
        border-radius: 3px;
        background-color: #0070f3;
        color: white;
        padding: 10px 20px;
        border: none;
        cursor: pointer;
    }
    input[type="submit"]:hover {
        background-color: rgba(0,118,255,0.9);
    }
    
    </style>
</head>
<body>
	
	
	<%
    String uname = (String) session.getAttribute("username");
    if (uname == null) {
        response.sendRedirect("main.html");
        return; // Prevent further execution if user is not logged in
    }
%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.util.Set, java.util.HashSet,java.util.*" %>
<%
    String selectedDate = request.getParameter("date");
    String selectedTime = request.getParameter("time");
    String selectedCourt = request.getParameter("court");

    Connection conn = null;
    PreparedStatement pstmt = null;
    
    int maxLength = 6;
    StringBuilder id = new StringBuilder();
    Random random = new Random();

    // Generate random digits (0-9)
    for (int i = 0; i < maxLength; i++) {
      id.append(random.nextInt(10));
    }
    String randomId = id.toString();
    
    
    

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver"); // Load JDBC driver
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "Krishna"); // Database connection details
        String date1 = selectedDate.substring(5).replace("-", "");
		
        // Check if the slot is already booked
        String checkQuery = "SELECT * FROM project WHERE day = ? AND play = ? AND court = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, date1);
        pstmt.setString(2, selectedTime);
        pstmt.setString(3, selectedCourt);
        ResultSet rs = pstmt.executeQuery();
        if(rs.next()){
        
            // Insert booking details
            String update = "update project set availability='no',username=?,booking_id=?,completedate=? where day=? and play=? and court=?" ;
            pstmt = conn.prepareStatement(update);
            pstmt.setString(1, uname);
            pstmt.setString(2, randomId);
            pstmt.setString(4, date1);
            pstmt.setString(5, selectedTime);
            pstmt.setString(6, selectedCourt);
            pstmt.setString(3, selectedDate);
            
            pstmt.executeUpdate();
        }else{
        	String insertQuery = "insert into project values(?,?,'no',?,?,?)" ;
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setString(4, uname);
            pstmt.setString(1, date1);
            pstmt.setString(2, selectedTime);
            pstmt.setString(3, selectedCourt);
            pstmt.setString(5, selectedDate);
            
            pstmt.executeUpdate();
        }
            
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    
    
   
%>


    <div class="bill-container">
        <h2 class="bill-title">Shuttle Court Booking Bill</h2>
        <div class="company-info">
            <strong>Bulls Badminton Arena</strong><br>
            Gorantla<br>
            7989318424
        </div>
        <div class="bill-info">
            <span>Booking id:</span>
            <span id="username"><%= randomId %></span>
        </div>
        <div class="bill-info">
            <span>Username:</span>
            <span id="username"><%= uname %></span>
        </div>
        <div class="bill-info">
            <span>Date:</span>
            <span id="date"><%= selectedDate %></span>
        </div>
        <div class="bill-info">
            <span>Time:</span>
            <span id="time"><%= selectedTime %></span>
        </div>
        <div class="bill-info">
            <span>Court:</span>
            <span id="time"><%= selectedCourt %></span>
        </div>
        <div class="bill-info">
            <span>Cost:</span>
            <span id="cost">200</span>
        </div>
    </div><br>
    <button onclick="window.print()" class="print">Print the bill</button><br><br>
    <form method="post" action="booking.jsp">
            <input type="submit" value="HOME">
    </form>
</body>

</html>


                    
                