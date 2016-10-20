package iu.requestReport;

import iu.dbc.DatabaseConnection;
import iu.requestReport.RequestReportBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;

public class ReportRecord extends HttpServlet {
	List<RequestReportBean> list;
	RequestReportBean bean;
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
	public List<RequestReportBean> getReportRecord(String openid,String PhrOwnerUID){
		list = new ArrayList<RequestReportBean>();
		try{
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT SourceUnit,AccessNumber,RequestTime,HasProcessed,ProcessedTime,RelatedStudyUID FROM IU_RequestReport WHERE WxUserOpenID = ? ORDER BY RequestTime DESC" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,openid) ;
			ResultSet rs = pstmt.executeQuery() ;	
			while(rs.next()){
				bean = new RequestReportBean();
				bean.setSourceUnit(rs.getString("SourceUnit"));
				String studyUID=rs.getString("RelatedStudyUID");
				bean.setRelatedStudyUID(rs.getString("RelatedStudyUID"));
				bean.setAccessNumber(rs.getString("AccessNumber"));
				bean.setRequestTime(rs.getString("RequestTime"));
				if("true".equalsIgnoreCase(rs.getString("HasProcessed"))||"1".equalsIgnoreCase(rs.getString("HasProcessed"))){
					bean.setHasProcessed("已处理");
					bean.setProcessedTime(rs.getString("ProcessedTime"));
				}else{
					bean.setHasProcessed("未处理");
					bean.setProcessedTime("---");
				}
				String sql1="select OwnerPicDataUID from IU_PhrOwnerPicData where PicStudyUID=? and PhrOwnerUID=?";
				PreparedStatement pstmt1 = null ;
				pstmt1 = conn.prepareStatement(sql1) ;
				pstmt1.setString(1,studyUID) ;
				pstmt1.setString(2, PhrOwnerUID);
				ResultSet rs1 = pstmt1.executeQuery() ;
				if(rs1.next()){					
					bean.setIsAvailable(false);				
				}else{
					bean.setIsAvailable(true);		
				};
				list.add(bean);
			}
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
}

