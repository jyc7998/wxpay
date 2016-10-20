package iu.notification;

import iu.dbc.DatabaseConnection;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ScanDemoPic extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/html");
		//PrintWriter out = response.getWriter();
		String hospitalName = request.getParameter("hospitalName");
		if(hospitalName!=null){
			hospitalName = new String(hospitalName.getBytes("ISO-8859-1"),"UTF-8");
		}
		//hospitalName = "安徽省中医院影像中心";
		DatabaseConnection dbc = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		InputStream in = null;
		OutputStream os = null;
		try{
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			os = response.getOutputStream();
			String sql = "SELECT ScanDemoPic FROM IU_ConnectedHospital WHERE HospitalName = ?" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,hospitalName) ;
			ResultSet rs = pstmt.executeQuery() ;	
			if(rs.next()){
				in = rs.getBinaryStream("ScanDemoPic");
				int num;
				byte buf[] = new byte[1024];
				while ((num = in.read(buf)) != -1) {
					os.write(buf, 0, num);
				}
				in.close();
			}	
			
			os.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//out.flush();
		//out.close();
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		this.doGet(request, response);
	}

}
