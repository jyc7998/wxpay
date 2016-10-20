package iu.servlet;

import iu.dbc.DatabaseConnection;
import iu.utils.WeixinUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

public class HealthArchiveServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement ps = null ;
	ResultSet rs=null;


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}

	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
	
		String OpenID=(String)request.getSession().getAttribute("openid");
		if (OpenID == null) {
			// redirect to get openid
			try {
				WeixinUtil.requestOpenId(request, response);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			OpenID = (String) request.getSession().getAttribute("openid");
		}
	 
		String flag = request.getParameter("flag");
		String relationship = request.getParameter("HealthArchives");
		String userrealname = request.getParameter("userrealname");
		String usersex = request.getParameter("Sex");
		String birthday= request.getParameter("birthday");
		String birthplace=request.getParameter("birthplace");
		String workplace=request.getParameter("workplace");
		String usermobilephone=request.getParameter("usermobilephone");
		String useremail = request.getParameter("useremail");
		String userqq = request.getParameter("userqq");
		String useroccupation = request.getParameter("useroccupation");
		String allergicDescription = request.getParameter("AllergicDescription");
		String pastHistory = request.getParameter("PastHistory");
		String UID="";
		//
		if("8".equals(flag)){
			try{
				dbc=new DatabaseConnection();
				conn = dbc.getConnection();
				String sql="Update IU_PhrCreatorInfo set Name=?,Sex=?,DateOfBirth=?,Occupation=?,Telephone=?,QqNumber=?,Email=? where CreatorOpenID=?"; 
				
	
				ps=conn.prepareStatement(sql);
				ps.setString(1,userrealname);
				ps.setString(2,usersex);
				ps.setString(3, birthday);
				ps.setString(4, useroccupation);
				ps.setString(5, usermobilephone);
				ps.setString(6, userqq);
				ps.setString(7,useremail);
				ps.setString(8,OpenID);
				int result=ps.executeUpdate();
				if(result!=0){
					out.print("<script>alert('个人信息修改成功');window.location='ShowCreatorInfo.jsp';</script>");
				}else{
					out.print("<script>alert('个人信息输入失败，回到个人信息输入页面');window.location='CreatorInfo.jsp';</script>");
				}
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
			
		}
	//
		if("7".equals(flag)){
			JSONArray jsonArray = new JSONArray();
			try{
				dbc=new DatabaseConnection();
				conn = dbc.getConnection();
				String sql = "select Name,Sex ,DateOfBirth,Occupation,Telephone,QqNumber,Email from IU_PhrCreatorInfo where CreatorOpenID=? ";
		 		ps = conn.prepareStatement(sql);
		 		ps.setString(1, OpenID);
		 		rs = ps.executeQuery();
		 		while (rs.next()) {
		 			String creatorname= rs.getString(1);
		 			String creatorsex=rs.getString(2);
		 			String creatorbirthday= rs.getString(3);
		 			String creatoroccupation = rs.getString(4);
		 			String creatortelephone = rs.getString(5);
		 			String creatorqq = rs.getString(6);
		 			String creatoremail = rs.getString(7);
		 			jsonArray.put(creatorname);
		 			jsonArray.put(creatorsex);
		 			jsonArray.put(creatorbirthday);
		 			jsonArray.put(creatoroccupation);
		 			jsonArray.put(creatortelephone);
		 			jsonArray.put(creatorqq);
		 			jsonArray.put(creatoremail);
		 			conn.close();
		 		}
			}catch(Exception e){
				e.printStackTrace();
			}
			out.print(jsonArray);
		}
	//个人信息
	if("6".equals(flag)){
		try{
			dbc=new DatabaseConnection();
			conn = dbc.getConnection();
			String sql="insert into IU_PhrCreatorInfo(CreatorOpenID,Name,Sex,DateOfBirth,Occupation,Telephone,QqNumber,Email) values"
					+ "(?,?,?,?,?,?,?,?)";
			ps=conn.prepareStatement(sql);
			ps.setString(1,OpenID);
			ps.setString(2,userrealname);
			ps.setString(3, usersex);
			ps.setString(4, birthday);
			ps.setString(5, useroccupation);
			ps.setString(6, usermobilephone);
			ps.setString(7,userqq);
			ps.setString(8,useremail);
			int result=ps.executeUpdate();
			if(result!=0){
				out.print("<script>alert('个人信息输入成功,跳转到创建档案页面');window.location='HealthArchive.jsp';</script>");
			}else{
				out.print("<script>alert('个人信息输入失败，回到个人信息输入页面');window.location='CreatorInfo.jsp';</script>");
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}	
	//修改档案
	if("5".equals(flag)){
		String level=request.getParameter("level");		
		 try {
		 		dbc = new DatabaseConnection();
		 		conn = dbc.getConnection();
		 		String sql = "update IU_PhrOwnerInfo set Name=?,Sex=? ,DateOfBirth=?,Occupation=?,BirthAddress=?,CurrentAddress=?,Telephone=?,"
		 				+ "QqNumber=?,Email=?,AllergicHistory=?,PastHistory=? where PhrOwnerUID=? ";
		 		ps = conn.prepareStatement(sql);
		 		ps.setString(1, userrealname);
				ps.setString(2, usersex);
				ps.setString(3, birthday);
				ps.setString(4, useroccupation);
				ps.setString(5, birthplace);
				ps.setString(6, workplace);
				ps.setString(7, usermobilephone);
				ps.setString(8, userqq);
				ps.setString(9, useremail);
				ps.setString(10, allergicDescription);
				ps.setString(11,pastHistory);
				ps.setString(12,level);
		 		ps.executeUpdate();
		 		
		 		String sql1="Update IU_PhrCreatorData set Relationship=?  where PhrOwnerUID=?";
		 		ps=conn.prepareStatement(sql1);
		 		ps.setString(1, relationship);
		 		ps.setString(2,level);
		 		int result=ps.executeUpdate();
		 		if(result!=0){
		 			System.out.println("修改成功");
		 			out.print("<script>alert('修改成功,跳转到档案列表');window.location='ArchiveCategory.jsp';</script>");
				} else {
					out.print("修改失败");
				}		
		 		
		 		//System.out.print(archives);
		 		conn.close();
		 	} catch (Exception e) {
		 		e.printStackTrace();
		 	}
		 	//out.print(1);
	}
	//	
	if("4".equals(flag)){
		JSONArray jsonArray = new JSONArray();
		String level=request.getParameter("level");
		System.out.println(level);
		
		 try {
		 		dbc = new DatabaseConnection();
		 		conn = dbc.getConnection();
		 		String sql = "select Name,Sex ,DateOfBirth,Occupation,BirthAddress,CurrentAddress,Telephone,QqNumber,Email,AllergicHistory,PastHistory from IU_PhrOwnerInfo where PhrOwnerUID=? ";
		 		ps = conn.prepareStatement(sql);
		 		ps.setString(1, level);
		 		rs = ps.executeQuery();
		 		while (rs.next()) {
		 			String username= rs.getString(1);
		 			String sex=rs.getString(2);
		 			String birthday1= rs.getString(3);
		 			String occupation = rs.getString(4);
		 			String birthAddress = rs.getString(5);
		 			String currentAddress = rs.getString(6);
		 			String mobilephone = rs.getString(7);
		 			String qq = rs.getString(8);
		 			String usermail = rs.getString(9);
		 			String AllergicDescription = rs.getString(10);
		 			String PastHistory = rs.getString(11);
		 			jsonArray.put(username);
		 			jsonArray.put(sex);
		 			jsonArray.put(birthday1);
		 			jsonArray.put(occupation);
		 			jsonArray.put(birthAddress);
		 			jsonArray.put(currentAddress);
		 			jsonArray.put(mobilephone);
		 			jsonArray.put(qq);
		 			jsonArray.put(usermail);
		 			jsonArray.put(AllergicDescription);
		 			jsonArray.put(PastHistory);			
		 		}
		 		String sql1="select Relationship from IU_PhrCreatorData where PhrOwnerUID=?";
		 		ps=conn.prepareStatement(sql1);
		 		ps.setString(1, level);
		 		rs=ps.executeQuery();
		 		while(rs.next()){
		 			String pharchive=rs.getString(1);
		 			jsonArray.put(pharchive);
		 		}
		 		conn.close();
		 	} catch (Exception e) {
		 		e.printStackTrace();
		 	}
		 	out.print(jsonArray);
	}
		
	if("3".equals(flag)){
		String level=request.getParameter("level");
		System.out.println(level);
		String PhrOwnerUID="";
		String sql="select PhrOwnerUID from IU_PhrCreatorData where CreatorOpenID=? and PhrOwnerName=?";
		try {
				dbc= new DatabaseConnection();
				conn=dbc.getConnection();
				ps=conn.prepareStatement(sql);
				ps.setString(1,OpenID);
				ps.setString(2,level);
				rs=ps.executeQuery();
				while(rs.next()){
					PhrOwnerUID+= rs.getString(1);
				}
				out.print(PhrOwnerUID);
				conn.close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
	}
		
	if("2".equals(flag)){
		StringBuffer jSon=new StringBuffer();
		jSon.append("[");
		try{
			
			String level = request.getParameter("level");
			String name = request.getParameter("name");
			dbc=new DatabaseConnection();
			conn=dbc.getConnection();			
			if("0".equals(level)){
				String sql1="select Name from IU_PhrOwnerInfo where PhrOwnerUID in (select PhrOwnerUID from IU_PhrCreatorData where Relationship=? and CreatorOpenID=?)";
				ps=conn.prepareStatement(sql1);
				ps.setString(1,name);
				ps.setString(2,OpenID);
				rs=ps.executeQuery();
				
				while(rs.next()){
					jSon.append("{name:\""+rs.getString(1)+"\",isParent:false},");			
				}
				
			} else{
				String sql="select distinct Relationship from IU_PhrCreatorData where CreatorOpenID=?";			
				ps=conn.prepareStatement(sql);
				ps.setString(1, OpenID);
				rs=ps.executeQuery();
				/*if(!rs.next()){
					out.print("<script> alert('您还没有创建过档案，请先创建一份档案');</script>");
					RequestDispatcher dispatcher = request.getRequestDispatcher("/HealthArchive.jsp");
					dispatcher .forward(request, response);
					conn.close();
					return;
				}else{*/
					while(rs.next()){
						jSon.append("{name:\""+rs.getString(1)+"\",isParent:true},");			
					}	
				
				conn.close();
			}
			String json= jSon.substring(0,jSon.length()-1)+"]";
			out.print(json);	
			
		}catch(Exception e){
			e.printStackTrace();
		}		
		  
	}
		
		if("1".equals(flag)){
		String sql="insert into IU_PhrOwnerInfo (Name,Sex,DateOfBirth,Occupation,BirthAddress,CurrentAddress,Telephone,"
		+ "QqNumber,Email,AllergicHistory,PastHistory) values(?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
			dbc= new DatabaseConnection();
			conn=dbc.getConnection();
			ps=conn.prepareStatement(sql);
			ps.setString(1, userrealname);
			ps.setString(2, usersex);
			ps.setString(3, birthday);
			ps.setString(4, useroccupation);
			ps.setString(5, birthplace);
			ps.setString(6, workplace);
			ps.setString(7, usermobilephone);
			ps.setString(8, userqq);
			ps.setString(9, useremail);
			ps.setString(10, allergicDescription);
			ps.setString(11,pastHistory);
			ps.executeUpdate();
			//conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String sql1="select PhrOwnerUID from IU_PhrOwnerInfo where Name=? and AllergicHistory=? and PastHistory=?";
		try{
			ps=conn.prepareStatement(sql1);
			ps.setString(1, userrealname);
			ps.setString(2, allergicDescription);
			ps.setString(3, pastHistory);
			rs=ps.executeQuery();
			while(rs.next()){
				UID=rs.getString(1);
			}
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String sql2="insert into IU_PhrCreatorData(CreatorOpenID,PhrOwnerUID,PhrOwnerName,Relationship) values(?,?,?,?)";
		try{
			ps=conn.prepareStatement(sql2);
			ps.setString(1,OpenID);
			ps.setString(2,UID);
			ps.setString(3,userrealname);
			ps.setString(4,relationship);
			int result= ps.executeUpdate();
			if (result != 0) {
				System.out.println("创建成功");
				out.print("<script>alert('档案创建成功,跳转到档案列表');window.location='ArchiveCategory.jsp';</script>");
			}else{
				out.print("<script>alert('档案创建失败，回到创建档案页面');window.location='HealthArchive.jsp';</script>");
			}
				/*RequestDispatcher dispatcher = request.getRequestDispatcher("/ArchiveCategory.jsp");
				dispatcher .forward(request, response);*/
			
				
			
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
			}
			if (ps != null) {
				try {
					ps.close();
				} catch (SQLException e) {
				}
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException ex) {
				}
			}
		}	

		
	}	    
		
		
	}

	
}
