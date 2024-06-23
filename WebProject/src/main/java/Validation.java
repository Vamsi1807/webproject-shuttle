

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/Validation")
public class Validation extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter pw=response.getWriter();
		

		String username = request.getParameter("uname");
		String password = request.getParameter("pwd");
		
		RequestDispatcher rd;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","Krishna");
			Statement smt=conn.createStatement();
			try {
				  PreparedStatement stmt = conn.prepareStatement("SELECT username, password FROM login WHERE username = ?");
				  stmt.setString(1, username); // Set username parameter
				  ResultSet rs = stmt.executeQuery();
				  String username1 = null;
				  String password1 = null;
				  int flag=0;
				  try{
					  // Check if there's a result
					  if(rs.next()) {
						  username1 = rs.getString("username");
						  password1 = rs.getString("password");
					  }
					/*  else {
						  flag=1;
						  rd=request.getRequestDispatcher("/index.html");
						  pw.print("<h1>Credentials not found in the database....</h1>");
						  rd.include(request, response);
					  }*/
				      
					  if(username.equals(username1) && password.equals(password1)) {
						  pw.print("<h1>Login succesful");
						  rd=request.getRequestDispatcher("/signup.html");
						  rd.forward(request, response);
				      }
				      else {
				    	  rd=request.getRequestDispatcher("/main.html");
						  pw.print("<h1>Wrong username/password</h1>");
						  rd.include(request, response);
				      }
				  } catch(Exception e) {
				    // Username not found
				  }

			}catch(Exception e) {
				
			}
		}
		catch(Exception e) {}
	}
}
