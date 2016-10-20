package iu.RemoteRequest;

import iu.dbc.DatabaseConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;






import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



/**
 * Servlet implementation class SavaDataServlet
 */
public class SavaDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	DatabaseConnection dbc = null; 
	Connection conn = null ;
	PreparedStatement ps=null;	
	ResultSet rs=null;
	

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		HttpSession session = request.getSession(); 
		String RelatedstudyUID=(String)session.getAttribute("RELATEDSTUDYUID");//该申请对应的StudyUID 
		String RequestTime=(String)session.getAttribute("REQUESTTIME");//申请获得手机报告的日期时间
		String Groupname=(String)session.getAttribute("GROUPNAME");//用户申请的会诊团队名称 
		Groupname = new String(Groupname.getBytes("ISO-8859-1"),"UTF-8");
		String orderNo=(String)session.getAttribute("ORDERNO");//微信支付交易编号
		String OpenID= (String) session.getAttribute("openid");//微信用户的OpenID
		
		         
		 
		/*String RelatedstudyUID="123456789";
		String RequestTime="2046-03-07 18:33";
		String Groupname="安徽合肥影联科技有限公司";
		String orderNo="0110";
		String OpenID="333222111";*/
		
		String sql="insert into IU_RequestImagConsult(WxUserOpenID,RequestTime,TransactionNumber,RelatedStudyUID,ReqGroupName,TransactionStatus,TransactionTime,SubmittedTime) values(?,?,?,?,?,1,getdate(),getdate())";
		String sql2 = "insert into IU_ClinicalData(UserLoginID,StudyUID,CustomArchive) values(?,?,?)";
		
		try {
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			SimpleDateFormat   df = new   SimpleDateFormat("yyyy-MM-dd HH:mm:ss");   
			java.util.Date  Date = df.parse(RequestTime);   
			//java.sql.Date   formatDate=   new   java.sql.Date(Date.getTime());
			
			ps = conn.prepareStatement(sql); 
			ps.setString(1, OpenID);
			ps.setTimestamp(2,  new java.sql.Timestamp(Date.getTime()));
			ps.setString(3, orderNo);
			ps.setString(4, RelatedstudyUID);
			ps.setString(5, Groupname);
			ps.executeUpdate();
			
			ps = conn.prepareStatement(sql2); 
			ps.setString(1, "影联远程会诊");
			ps.setString(2, RelatedstudyUID);
			ps.setString(3, Groupname);
			
			ps.executeUpdate();
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		response.sendRedirect("RemotePaySuccess.jsp");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
