<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Badminton Court Booking</title>

<style>
	.final{
		text-align:center;
		
	}
	.confirm{
		height:50px;
		width:150px;
		background-color:tomato;
		color:white;
		font-weight:bold;
		border-radius:5px;
	}
	.confirm:hover{
		background-color:red;
	}
	.navbar {
        height: 100px;
        color: white;
        background-color: rgb(40, 187, 40);
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
    }
    .nav {
    	width:200px;
        
        height: 20px;
        padding: 5px;
        background-color: rgb(87, 130, 240);
        border-radius: 3px;
        margin-left: 5px;
        text-align:center;
    }
    .nav:hover {
        cursor: pointer;
        background-color: grey;
    }
    .nav a {
        text-decoration: none;
        color: white;
    }
    .navele {
        width: 600px;
        display: flex;
        justify-content: space-around;
        align-items:center;
      
    }
    p {
        font-size: 20px;
        font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
    }
    .booking {
        
        display: flex;
        flex-direction: column;
    }
    .book {
       
        text-align: center;
    }
    .time {
        color: white;
        background-color: blue;
        border: none;
        border-radius: 4px;
        height: 30px;
        padding: 0px 5px 0px 5px;
        font-size: 15px;
    }
    ::-webkit-calendar-picker-indicator {
        background-color: white;
        border-radius: 3px;
        padding: 4px;
        cursor: pointer;
    }
    .time:hover {
        cursor: pointer;
    }
    .start {
        
    }
    .timeslots {
        text-align: end;
        display: grid;
        grid-template-columns: repeat(4, 160px);
        grid-template-rows: repeat(3, 45px);
    }
    .hrs {
        color: white;
        background-color: rgb(102, 138, 66);
        height: 30px;
        border-radius: 3px;
        padding: 5px;
    }
    .opt {
        background-color: rgb(80, 161, 161);
        cursor: pointer;
    }
    .opt:hover {
        background-color: rgb(102, 138, 66);
    }
    .duration {
        text-align: center;
        font-size: 20px;
    }
    .start,.Courts{
        text-align: center;
    }
    .check {
        border: none;
        border-radius: 5px;
        background-color: lightgreen;
        height: 22px;
    }
    .check:hover{
    	 background-color:  #57e657;
    }
    .map {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .loc {
        text-align: center;
    }
    
    ul {
  		list-style-type: none;
  		margin: 0;
  		padding: 0;
  		overflow: hidden;
  		background-color: #333;
	}

	li {
  		float: left;
	}

	li a, .dropbtn {
  		display: inline-block;
  		color: white;
  		text-align: center;
  		padding: 14px 16px;
  		text-decoration: none;
	}

	li a:hover, .dropdown:hover .dropbtn {
  		background-color: red;
	}		

	li.dropdown {
  		display: inline-block;
	}

	.dropdown-content {
  		display: none;
  		position: absolute;
  		background-color: #f9f9f9;
  		min-width: 160px;
  		box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
 		z-index: 1;
	}

	.dropdown-content a {
  		color: black;
  		padding: 12px 16px;
  		text-decoration: none;
  		display: block;
  		text-align: left;
	}

	.dropdown-content a:hover {background-color: rgb(251, 184, 102);}

	.dropdown:hover .dropdown-content {
  		display: block;
	}
		
    
</style>
</head>
<body style="background-color: silver;">

<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.util.Set, java.util.HashSet" %>

<%    
    if(session.getAttribute("username") == null) {
        response.sendRedirect("main.html");
    }

    String selectedDate = request.getParameter("date");
    String selectedTime = request.getParameter("hiddenTime");
    String selectedCourt = request.getParameter("hiddenCourt");
    System.out.println("selected times is : " + selectedTime);
    System.out.println("selected court is : " + selectedCourt);

    Integer counter = (Integer)application.getAttribute("visits");
    if (selectedDate == null || counter == 0) {
        counter = 1;
    } else {
        counter = counter + 1;
    }
    application.setAttribute("visits", counter);
%>

<%
    // Database connection and retrieval logic
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Set<String> availableTimes = new HashSet<>();
    Set<String> availableCourts = new HashSet<>();
    String[] Times = {"09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM"};
    
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver"); // Load JDBC driver
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "Krishna"); // Database connection details

        if (selectedDate != null && !selectedDate.isEmpty()) {
            String date = selectedDate.substring(5).replace("-", "");
            System.out.println(date);

            String query = "SELECT * FROM project WHERE day = ? AND availability = 'yes'";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, date);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                // Collect available times and courts from the database
                do {
                    availableTimes.add(rs.getString("play"));
                    availableCourts.add(rs.getString("court"));
                } while (rs.next());
            } else {
                // If no available times and courts are found in the database for the selected date, use default times and courts
                for (String time : Times) {
                    availableTimes.add(time);
                    String insertQuery1 = "insert into project(day,play,availability,court) values (?,?,'yes','Court 1')";
                    pstmt = conn.prepareStatement(insertQuery1);
                    pstmt.setString(1, date);
                    pstmt.setString(2, time);
                    pstmt.executeUpdate(); 
                    
                    String insertQuery2 = "insert into project(day,play,availability,court) values (?,?,'yes','Court 2')";
                    pstmt = conn.prepareStatement(insertQuery2);
                    pstmt.setString(1, date);
                    pstmt.setString(2, time);
                    pstmt.executeUpdate();
                }
                
            }
        } else {
            System.out.println("Selected date is empty");
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

<ul>
  <li><a href="#aboutus">About Us</a></li>
  <li><a href="#location">Location</a></li>
  <li><a href="#booking">Booking</a></li>
  <li class="dropdown">
    <a href="javascript:void(0)" class="dropbtn">Contact</a>
    <div class="dropdown-content">
      <a href="#">badmintonarena@gmail.com</a>
      <a href="#">7989318424</a>
    </div>
  </li>
  <li class="dropdown">
    <a href="javascript:void(0)" class="dropbtn">Account</a>
    <div class="dropdown-content">
      <a href="myAccount.jsp">Dashboard</a>
      <a href="forgotpassword.html">Change Password</a>
      <a href="logout.jsp">Logout</a>
    </div>
  </li>
</ul>

<div class="aboutus" id="aboutus">
    <div><h1>About Us</h1></div>
    <p>Looking to unleash your inner badminton champion? Look no further! Our courts are renowned as some of the finest in town with just <span style="color: red;font-weight:bold">200 rupees per hour</span>, offering a haven for players of all skill levels. Dominate the competition on our top-tier, synthetic surfaces designed for lightning-fast rallies. Unleash powerful smashes under professional-grade lighting that illuminates every corner of the court. We take pride in maintaining spacious, well-maintained courts, ensuring a comfortable and enjoyable experience for every game. So, don't settle for average. Book your court today and experience the thrill of badminton at its finest!</p>
</div>

<div class='map'>
    <h1 id='location'>Location : </h1>
    <iframe class='loc' src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d30629.92668884861!2d80.39529817431641!3d16.3361812!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a358bc53b08df8d%3A0xe13f404bdeae763c!2sBulls%20Badminton%20Arena!5e0!3m2!1sen!2sin!4v1717570617704!5m2!1sen!2sin" width="450" height="450" style="border-radius:8px;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
</div><br>

<div class="booking" id="booking">
    <h1>Booking : </h1>
    <form method="post" action="booking.jsp">
        <div class="book">
            <label for="date">Select date:</label>
            <input type="date" name="date" id="date" class="time" min="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>" value="<%= selectedDate != null ? selectedDate : "" %>">
            <input type="hidden" name="hiddenTime" id="hiddenTime" value="<%= selectedTime != null ? selectedTime : "" %>">
            <input type="hidden" name="hiddenCourt" id="hiddenCourt" value="<%= selectedCourt != null ? selectedCourt : "" %>">
            <input type="submit" value="Check Availability" class="check">
        </div><br>
        <div class="start">
            <label for="times">Select time:</label>
            <select class="hrs" name="times" id="times" onchange="selectTime()">
                <% if (!availableTimes.isEmpty()) { 
  					int count = 0;
  					for (String time : availableTimes) {
    					count++;
    					out.println("<option value='" + time + "' class='opt'" + (count == 1 ? " selected" : "") + ">" + time + "</option>");
  					}
				} else {
  					out.println("<option value='' class='opt'>No available times</option>");
				} %>
            </select>
        </div><br>
        <div class="Courts">
            <label for="hrs">Available Courts :</label>
            <select class="hrs" name="courts" id="courts">
                <option value="">Select a time first</option>
                
            </select>
            <input type="button" value="Select" class="check" onclick="selectCourt()">
        </div>
        
    </form><br><br>
    
    <div class="final">
        <form action="final.jsp" method="post">
            <input type="hidden" name="date" id="finalDate" value="<%= selectedDate %>">
            <input type="hidden" name="time" id="finalTime" value="<%= selectedTime %>">
            <input type="hidden" name="court" id="finalCourt" value="<%= selectedCourt %>">
            <input type="submit" class="confirm" value="Confirm Booking!!!" > 
        </form>
    </div>
</div>

</body>

<script>
    function selectTime() {
        var selectedDate = document.getElementById("date").value;
        var selectedTime = document.getElementById("times").value;
        document.getElementById("hiddenTime").value = selectedTime;

        // Fetch available courts based on selected date and time
        if (selectedDate && selectedTime) {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "fetchCourts.jsp?date=" + selectedDate + "&time=" + selectedTime, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    document.getElementById("courts").innerHTML = xhr.responseText;
                }
            };
            xhr.send();
        } else {
            document.getElementById("courts").innerHTML = "<option value=''>Select a time first</option>";
        }
    }

    function selectCourt() {
    	  var selectedTime = document.getElementById("times");
    	  
    	  // Check if time dropdown is disabled (i.e., only one option available)
    	  if (selectedTime.disabled) {
    	    // Get the pre-selected time value
    	    var selectedTimeValue = selectedTime.value;
    	    document.getElementById("hiddenTime").value = selectedTimeValue;
    	    document.getElementById("finalTime").value = selectedTimeValue;
    	  } else {
    	    var selectedCourt = document.getElementById("courts").value;
    	    document.getElementById("hiddenCourt").value = selectedCourt;
    	    document.getElementById("finalCourt").value = selectedCourt;
    	  }
    	}

    // Update final form hidden fields when date or time changes
    document.getElementById("date").addEventListener("change", function() {
        document.getElementById("finalDate").value = this.value;
    });

    document.getElementById("times").addEventListener("change", function() {
        document.getElementById("finalTime").value = this.value;
    });
</script>
</html>
