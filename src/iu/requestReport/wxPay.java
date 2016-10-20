package iu.requestReport;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import iu.dbc.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import iu.utils.CurrentHospital;

public class wxPay extends HttpServlet {
	   
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DatabaseConnection dbc = null;
		Connection conn = null ;
		PreparedStatement ps = null ;
		response.setContentType("text/html;charset=utf-8");		
		PrintWriter out =response.getWriter();	
		HttpSession session = request.getSession(); 
		String openid=session.getAttribute("openid").toString();
		String out_trade_no=session.getAttribute("out_trade_no").toString();
		String NoticeReqUID=session.getAttribute("NoticeReqUID").toString();
		String AccessNumber=session.getAttribute("AccessNumber").toString();
		String RequestTime=session.getAttribute("RequestTime").toString();
		int TransactionStatus=1;
		try {
			dbc = new DatabaseConnection();
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	    conn = dbc.getConnection();
		if(!NoticeReqUID.equals("")){
		String NoticeReqUIDs[]=NoticeReqUID.split("/");
		for (int i = 0; i < NoticeReqUIDs.length; i++) {
			
			String sql="select SourceUnit,AccessNumber from IU_RequestNotice where NoticeReqUID=?";
		    try {
		    	ps = conn.prepareStatement(sql);
				ps.setString(1, NoticeReqUIDs[i]);
				ResultSet rs = ps.executeQuery();	
				String SourceUnit="";
				String AccessNumber1="";
				    if (rs.next()) {
					  SourceUnit=rs.getString("SourceUnit");
					  AccessNumber1=rs.getString("AccessNumber");
				    }
				sql="insert into IU_RequestReport (SourceUnit,AccessNumber,WxUserOpenID,TransactionNumber,TransactionStatus,RequestTime) values (?,?,?,?,?,?)"; 
				ps=conn.prepareStatement(sql);
				ps.setString(1,SourceUnit);
				ps.setString(2,AccessNumber1);
				ps.setString(3,openid);
				ps.setString(4,out_trade_no);
				ps.setInt(5,TransactionStatus);
				ps.setString(6,RequestTime);
				ps.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		   
		}}else if(!AccessNumber.equals("")){
			try{
				String[] s = AccessNumber.split(",");
				AccessNumber = s[1];
			}catch(Exception e){
				e.printStackTrace();
			}
			String SourceUnit = "";
			try{
				SourceUnit = new CurrentHospital().getHospitalName(openid);
			}catch(Exception e){
				e.printStackTrace();
			}	
			try{
				String sql="insert into IU_RequestReport (SourceUnit,AccessNumber,WxUserOpenID,TransactionNumber,TransactionStatus,RequestTime) values (?,?,?,?,?,?)"; 
				ps=conn.prepareStatement(sql);
				ps.setString(1,SourceUnit);
				ps.setString(2,AccessNumber);
				ps.setString(3,openid);
				ps.setString(4,out_trade_no);
				ps.setInt(5,TransactionStatus);
				ps.setString(6,RequestTime);
				ps.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.sendRedirect("requestReportSuccess.jsp");
	
	}
}
