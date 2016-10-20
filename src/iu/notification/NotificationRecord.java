package iu.notification;

import iu.dbc.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class NotificationRecord {
	List<RequestNoticeBean> list;
	RequestNoticeBean bean;
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
	public List<RequestNoticeBean> getNotificationRecord(String openid){
		list = new ArrayList<RequestNoticeBean>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String requestTime = "";
		String processedTime = "";
		
		try{
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT  NoticeReqUID,SourceUnit,AccessNumber,RequestTime,HasProcessed,ProcessedTime FROM IU_RequestNotice WHERE WxUserOpenID = ? ORDER BY RequestTime DESC" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,openid) ;
			ResultSet rs = pstmt.executeQuery() ;	
			while(rs.next()){
				bean = new RequestNoticeBean();
				bean.setSourceUnit(rs.getString("SourceUnit"));
				bean.setAccessNumber(rs.getString("AccessNumber"));
				bean.setNoticeReqUID(rs.getString("NoticeReqUID"));
				//bean.setRelatedStudyUID(rs.getString("RelatedStudyUID"));
				String sql1="select * from IU_RequestReport where WxUserOpenID = ? and SourceUnit=? and AccessNumber=?";
				pstmt=conn.prepareStatement(sql1);
				pstmt.setString(1, openid);
				pstmt.setString(2, rs.getString("SourceUnit"));
				pstmt.setString(3, rs.getString("AccessNumber"));
				ResultSet rs1=pstmt.executeQuery();
				if(rs1.next()){
					bean.setRequestImagConsult("1");
				}else{
					bean.setRequestImagConsult("0");
				}
				requestTime = rs.getString("RequestTime");			
				requestTime = sdf.format(sdf.parse(requestTime));
				bean.setRequestTime(requestTime);
				if("1".equalsIgnoreCase(rs.getString("HasProcessed"))){
					bean.setHasProcessed("已处理");		
					processedTime = rs.getString("ProcessedTime");			
					processedTime = sdf.format(sdf.parse(processedTime));
					bean.setProcessedTime(processedTime);
				}else{
					bean.setHasProcessed("未处理");
					bean.setProcessedTime("---");
				}
				list.add(bean);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
	
}
