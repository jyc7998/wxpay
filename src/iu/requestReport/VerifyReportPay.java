package iu.requestReport;

import iu.dbc.DatabaseConnection;
import iu.utils.CurrentHospital;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VerifyReportPay extends HttpServlet {
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");		
		PrintWriter out =response.getWriter();	
		DatabaseConnection dbc = null;
		Connection conn = null ;
		PreparedStatement pstmt = null ;
		String openid=request.getParameter("openid");
		String AccessNumber=request.getParameter("AccessNumber");
		String data="2";
		try{
			dbc=new DatabaseConnection();
			conn=dbc.getConnection();
			String SourceUnit = "";
			try{
				SourceUnit = new CurrentHospital().getHospitalName(openid);
			}catch(Exception e){
				e.printStackTrace();
			}	
			String sql="select * from IU_RequestReport where WxUserOpenID = ? and SourceUnit=? and AccessNumber=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, openid);
			pstmt.setString(2, SourceUnit);
			pstmt.setString(3, AccessNumber);
			ResultSet rs=pstmt.executeQuery();
			if(rs.next()){
				data="1";
			}else{
				data="0";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			
		}
		out.println(data);
	}
}
