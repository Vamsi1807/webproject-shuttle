

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class booking
 */
@WebServlet("/booking")
public class booking extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out=response.getWriter();
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","Krishna");
			Statement stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rs=stmt.executeQuery("select * from court where play="+request.getParameter("date")+";");
			ResultSetMetaData rsmd=rs.getMetaData();
			 boolean[] availableTimes = new boolean[12]; // Initialize an array for 12 time slots
	            while (rs.next()) {
	                String time = rs.getString("time");
	                switch (time) {
	                    case "08:00 AM": availableTimes[0] = true; break;
	                    case "09:00 AM": availableTimes[1] = true; break;
	                    case "10:00 AM": availableTimes[2] = true; break;
	                    case "11:00 AM": availableTimes[3] = true; break;
	                    case "01:00 PM": availableTimes[4] = true; break;
	                    case "02:00 PM": availableTimes[5] = true; break;
	                    case "03:00 PM": availableTimes[6] = true; break;
	                    case "04:00 PM": availableTimes[7] = true; break;
	                    case "06:00 PM": availableTimes[8] = true; break;
	                    case "07:00 PM": availableTimes[9] = true; break;
	                    case "08:00 PM": availableTimes[10] = true; break;
	                    case "09:00 PM": availableTimes[11] = true; break;
	                }
	            }
	            out.println("<!DOCTYPE html>");
	            out.println("<html>");
	            out.println("<head>");
	            out.println("<meta charset='UTF-8'>");
	            out.println("<title>Insert title here</title>");
	            out.println("<style>");
	            out.println("/* Add your CSS styles here */");
	            out.print("\r\n"
	            		+ "  	.navbar{\r\n"
	            		+ "		height:100px;\r\n"
	            		+ "		color:white;\r\n"
	            		+ "		background-color:rgb(40, 187, 40);\r\n"
	            		+ "		display:flex;\r\n"
	            		+ "		flex-direction:row;\r\n"
	            		+ "		justify-content:space-between;\r\n"
	            		+ "		align-items:center;\r\n"
	            		+ "	}\r\n"
	            		+ "	.nav{\r\n"
	            		+ "		border:1px solid black;\r\n"
	            		+ "		height:20px;\r\n"
	            		+ "		padding:5px;\r\n"
	            		+ "		background-color:rgb(87, 130, 240);\r\n"
	            		+ "		border-radius:3px;\r\n"
	            		+ "		margin-left:5px;\r\n"
	            		+ "	}\r\n"
	            		+ "	.nav:hover{\r\n"
	            		+ "		cursor:pointer;\r\n"
	            		+ "		background-color:grey;\r\n"
	            		+ "	}\r\n"
	            		+ "	.nav a{\r\n"
	            		+ "		text-decoration:none;\r\n"
	            		+ "		color:white;\r\n"
	            		+ "	}\r\n"
	            		+ "	.navele{\r\n"
	            		+ "		width:340px;\r\n"
	            		+ "		display:flex;\r\n"
	            		+ "		justify-content:space-around;\r\n"
	            		+ "	}\r\n"
	            		+ "	p{\r\n"
	            		+ "		font-size:20px;\r\n"
	            		+ "		font-family :Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;\r\n"
	            		+ "	}\r\n"
	            		+ "	.booking{\r\n"
	            		+ "		\r\n"
	            		+ "		border:1px solid black;\r\n"
	            		+ "		display:flex;\r\n"
	            		+ "		flex-direction:column;;\r\n"
	            		+ "	}\r\n"
	            		+ "	.book{\r\n"
	            		+ "		border:1px solid black;\r\n"
	            		+ "        text-align: center;\r\n"
	            		+ "	}\r\n"
	            		+ "	.time{\r\n"
	            		+ "		color:white;\r\n"
	            		+ "		background-color:blue;\r\n"
	            		+ "		border:none;\r\n"
	            		+ "		border-radius:4px;\r\n"
	            		+ "		height:30px;\r\n"
	            		+ "		padding:0px 5px 0px 5px;\r\n"
	            		+ "		font-size:15px;\r\n"
	            		+ "	}\r\n"
	            		+ "	::-webkit-calendar-picker-indicator{\r\n"
	            		+ "		background-color:white;\r\n"
	            		+ "		border-radius:3px;\r\n"
	            		+ "		padding:4px;\r\n"
	            		+ "		cursor:pointer;\r\n"
	            		+ "	}\r\n"
	            		+ "	.time:hover{\r\n"
	            		+ "		cursor:pointer;\r\n"
	            		+ "	}\r\n"
	            		+ "	.start{\r\n"
	            		+ "        border:1px solid black;\r\n"
	            		+ "    }\r\n"
	            		+ "\r\n"
	            		+ "    .timeslots{\r\n"
	            		+ "        text-align:end;\r\n"
	            		+ "        display: grid;\r\n"
	            		+ "        grid-template-columns: repeat(4,160px);\r\n"
	            		+ "        grid-template-rows: repeat(3,45px);\r\n"
	            		+ "        \r\n"
	            		+ "    }\r\n"
	            		+ "\r\n"
	            		+ "    .hrs{\r\n"
	            		+ "        color:white;\r\n"
	            		+ "        background-color: rgb(102, 138, 66);\r\n"
	            		+ "        height:30px;\r\n"
	            		+ "        border-radius:3px;\r\n"
	            		+ "        padding:5px;\r\n"
	            		+ "    }\r\n"
	            		+ "\r\n"
	            		+ "    .opt{\r\n"
	            		+ "        background-color: rgb(80, 161, 161);\r\n"
	            		+ "        cursor:pointer;\r\n"
	            		+ "    }\r\n"
	            		+ "    .opt:hover{\r\n"
	            		+ "        background-color:  rgb(102, 138, 66);\r\n"
	            		+ "    }\r\n"
	            		+ "    .duration{\r\n"
	            		+ "        text-align: center;\r\n"
	            		+ "        font-size:20px;\r\n"
	            		+ "    }\r\n"
	            		+ "    .start{\r\n"
	            		+ "        text-align: center;\r\n"
	            		+ "    }\r\n"
	            		+ "    .check{\r\n"
	            		+ "        border:none;\r\n"
	            		+ "        border-radius:5px;\r\n"
	            		+ "        background-color:lightgreen;\r\n"
	            		+ "        height:22px;\r\n"
	            		+ "    }\r\n"
	            		+ "\r\n");
	            out.println("</style>");
	            out.println("</head>");
	            out.println("<body style='background-color:silver'>");
	            out.print("<div class=\"navbar\">\r\n"
	            		+ "    <div class=\"nav\">\r\n"
	            		+ "      <a href=\"#aboutus\">About Us</a>\r\n"
	            		+ "    </div>\r\n"
	            		+ "    <div class=\"navele\">\r\n"
	            		+ "      <div class=\"nav\">\r\n"
	            		+ "        <a href=\"#location\">Location</a>\r\n"
	            		+ "      </div>\r\n"
	            		+ "      <div class=\"nav\">\r\n"
	            		+ "        <a href=\"#booking\">Booking</a>\r\n"
	            		+ "      </div>\r\n"
	            		+ "      <div class=\"nav\">Contact Us</div>\r\n"
	            		+ "      <div class=\"nav\">Account</div>\r\n"
	            		+ "    </div>\r\n"
	            		+ "  </div>\r\n"
	            		+ "  <div class=\"aboutus\" id=\"aboutus\">\r\n"
	            		+ "    <h1>About us :</h1>\r\n"
	            		+ "    <p>Looking to unleash your inner badminton champion? Look no further! Our courts are renowned as some of the finest in town, offering a haven for players of all skill levels. Dominate the competition on our top-tier, synthetic surfaces designed for lightning-fast rallies. Unleash powerful smashes under professional-grade lighting that illuminates every corner of the court. We take pride in maintaining spacious, well-maintained courts, ensuring a comfortable and enjoyable experience for every game.  So, don't settle for average. Book your court today and experience the thrill of badminton at its finest!</p>\r\n"
	            		+ "  </div>\r\n"
	            		+ "  <div class=\"booking\" id=\"booking\">\r\n"
	            		+ "    <h1>Booking : </h1>");
	            out.println("<form method='post' action='booking.java' id='bookingForm'>");
	            // ... (Other form fields)
	            out.print("<div class=\"book\">\r\n"
	            		+ "            <label for=\"date\">Select date : </label>\r\n"
	            		+ "            <input type=\"date\" name=\"date\" class=\"time\" min=\"<?php echo date('Y-m-d'); ?>\">\r\n"
	            		+ "            <input type=\"submit\" value=\"Check Availability\" class=\"check\">\r\n"
	            		+ "        </div><br>\r\n"
	            		+ "");
	            out.println("<div class='start'>");
	            out.println("<label for='times'>Select time : </label>");
	            out.println("<select class='hrs' name='times'>");
	            String[] timeOptions = {
	                "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM",
	                "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM",
	                "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM"
	            };
	            for (int i = 0; i < timeOptions.length; i++) {
	                String color = availableTimes[i] ? "green" : "red";
	                out.println("<option value='" + timeOptions[i] + "' style='background-color:" + color + ";'>" + timeOptions[i] + "</option>");
	            }
	            out.println("</select>");
	            out.println("</div>");
	            // ... (Other form fields and closing tags)
	            out.print("<br>\r\n"
	            		+ "        <div class=\"duration\">\r\n"
	            		+ "            <label for=\"hrs\">Duration : </label>\r\n"
	            		+ "            <select name=\"hrs\" class=\"hrs\">\r\n"
	            		+ "                <option value=\"0\" class=\"opt\">0 Hr</option>\r\n"
	            		+ "                <option value=\"1\" class=\"opt\">1 Hr</option>\r\n"
	            		+ "                <option value=\"2\" class=\"opt\">2 Hrs</option>\r\n"
	            		+ "                <option value=\"3\" class=\"opt\">3 Hrs</option>\r\n"
	            		+ "                <option value=\"4\" class=\"opt\">4 Hrs</option>\r\n"
	            		+ "            </select>\r\n"
	            		+ "        </div>\r\n"
	            		+ "        <div class=\"courts\">\r\n"
	            		+ "            <label>Available courts : </label>\r\n"
	            		+ "        </div>\r\n"
	            		+ "    <button type=\"submit\">Book Court</button>  ");
	            out.println("</form>");
	            out.println("</body>");
	            out.println("</html>");

		}
		catch(SQLException e) {}
		catch(Exception e) {}
	}
}
