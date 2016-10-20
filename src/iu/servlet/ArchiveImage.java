package iu.servlet;


import iu.dbc.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ArchiveImage extends HttpServlet {

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

		String flag = request.getParameter("flag");
		String PhrUID = request.getParameter("PhrUID");
		String PicUID = request.getParameter("PicUID");
		String[] Pic_uids=PicUID.split("/");	
		System.out.println(Pic_uids.length);
		if("1".equals(flag)){
			String PicKind="影像学检查";
			try{
				dbc=new DatabaseConnection();
				conn = dbc.getConnection();
				int result=0;
				for(int i=0;i<Pic_uids.length;i++){
				System.out.println(Pic_uids[i]);
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");//可以方便地修改日期格式 
				String uploadtime= dateFormat.format(new Date());
				String sql="insert into IU_PhrOwnerPicData (PhrOwnerUID,PicStudyUID,PicDataKind,UploadTime) values(?,?,?,?)";
				ps=conn.prepareStatement(sql);
				ps.setString(1,PhrUID);
				ps.setString(2,Pic_uids[i]);
				ps.setString(3,PicKind);
				ps.setString(4,uploadtime);
				result+=ps.executeUpdate();
				}
				out.print(result);
				conn.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		if("2".equals(flag)){
			String PicKind="影像学检查";
			try{
				dbc=new DatabaseConnection();
				conn = dbc.getConnection();
				String sql="insert into IU_PhrOwnerPicData (PhrOwnerUID,PicStudyUID,PicDataKind) values(?,?,?)";
				ps=conn.prepareStatement(sql);
				ps.setString(1,PhrUID);
				ps.setString(2,PicUID);
				ps.setString(3, PicKind);
				int result=ps.executeUpdate();
				if(result!=0){
					
				}
				conn.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
}
