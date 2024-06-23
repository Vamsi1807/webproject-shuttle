

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class userDetails
 */
@WebServlet("/userDetails")
public class userDetails extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter pw=response.getWriter();
		String email=request.getParameter("email");
		String pwd1=request.getParameter("pwd1");
		String pwd2=request.getParameter("pwd2");
		String uname=request.getParameter("uname");
		String gender=request.getParameter("gender");
		String dob=request.getParameter("birthday");
		String question=request.getParameter("question");
		String answer=request.getParameter("answer");
		pw.print(email+" "+pwd1+" "+pwd2+" "+uname+" "+gender+" "+dob+" "+question+" "+answer);
	}
}
