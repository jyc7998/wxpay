package iu.requestReport;

import iu.dbc.DatabaseConnection;
import iu.utils.CurrentHospital;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class VerifyReportPay123 {

	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
	public String byAccessNumber(String AccessNumber,String openid){
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
		return data;
		
	}
	
}
