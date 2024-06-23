<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Set, java.util.HashSet" %>

<%
    String selectedDate = request.getParameter("date");
    String selectedTime = request.getParameter("time");
	
    
    
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Set<String> availableCourts = new HashSet<>();
    
    String[] Courts = {"Court 1", "Court 2"};

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver"); // Load JDBC driver
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "Krishna"); // Database connection details

        if (selectedDate != null && selectedTime != null) {
        	String date = selectedDate.substring(5).replace("-", ""); // Ensure correct date format

            String query = "SELECT court FROM project WHERE day = ? AND play = ? AND availability = 'yes'";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, date);
            pstmt.setString(2, selectedTime);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                // Collect available times and courts from the database
                do {
                    availableCourts.add(rs.getString("court"));
                } while (rs.next());
            } 
            else{
            	for (String court : Courts) {
                    availableCourts.add(court);
                }
            }

            // Remove the booked courts from the total list of courts
            
            if (!availableCourts.isEmpty()) {
                    for (String court : availableCourts) {
                        out.println("<option value='" + court + "' class='opt'" + (court.equals(selectedTime) ? " selected" : "") + ">" + court + "</option>");
                    }
            } else {
                out.println("<option value='' class='opt'>No available times</option>");
            }
            
        } else {
            out.println("<option value=''>Invalid date or time</option>");
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
