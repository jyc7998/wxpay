package iu.notification;

import iu.dbc.DatabaseConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestNotification extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
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
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
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
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String scanResult = request.getParameter("scanResult");		
		String openID = (String) request.getSession().getAttribute("openid");
		String hospitalName = "";
		int result = 0;
		try{
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT hospitalName FROM IU_WX_UserHospital WHERE openID = ?" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,openID) ;
			ResultSet rs = pstmt.executeQuery() ;	
			if(rs.next()){
				hospitalName = rs.getString("hospitalName");
			}
			sql = "SELECT * FROM IU_RequestNotice WHERE SourceUnit=? AND AccessNumber=? AND WxUserOpenID=?";
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,hospitalName) ;
			pstmt.setString(2,scanResult) ;
			pstmt.setString(3,openID) ;
			rs = pstmt.executeQuery() ;
			if(rs.next()){
				result = 2;//表示重复获取某个病例的通知
			}else{
				sql = "INSERT INTO IU_RequestNotice(SourceUnit,AccessNumber,WxUserOpenID) VALUES(?,?,?)";
				pstmt = conn.prepareStatement(sql) ;
				pstmt.setString(1,hospitalName) ;
				pstmt.setString(2,scanResult) ;
				pstmt.setString(3,openID) ;
				result = pstmt.executeUpdate() ;
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		out.print(result);
		out.close();		
	}

}
