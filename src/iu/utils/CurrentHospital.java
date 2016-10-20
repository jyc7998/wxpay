package iu.utils;

import iu.dbc.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CurrentHospital {
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
	public String getHospitalName(String openID){
		String hospitalName = "";
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
		}catch(Exception e){
			e.printStackTrace();
		}
		return hospitalName;
	}
}
