package iu.RemoteRequest;

import iu.dbc.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class RemoteRequestRecord {
	public List<RemoteRequestRecordBean> list;
	DatabaseConnection dbc = null;
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public List<RemoteRequestRecordBean> getRemoteRequestRecord(String openid) {
		list = new ArrayList<RemoteRequestRecordBean>();
		try {		
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "select top 20 TransactionNumber,ReqGroupName,TransactionTime,RequestTime,TransactionStatus,RelatedStudyUID from IU_RequestImagConsult where WxUserOpenID=? and TransactionTime is not null and RequestTime is not null order by TransactionTime desc";
			ps = conn.prepareStatement(sql);
			ps.setString(1, openid);		
			rs = ps.executeQuery();
			while (rs.next()) {
				RemoteRequestRecordBean bean = new RemoteRequestRecordBean();
				bean.setReqGroupName(rs.getString("ReqGroupName"));
				String requestTime = sdf.format(sdf.parse(rs.getString("RequestTime")));
				bean.setRequestTime(requestTime);
				bean.setTransactionNumber(rs.getString("TransactionNumber"));
				bean.setTransactionStatus(rs.getString("TransactionStatus"));
				String transactionTime = sdf.format(sdf.parse(rs.getString("TransactionTime")));
				bean.setTransactionTime(transactionTime);		
				bean.setRelatedStudyUID(rs.getString("RelatedStudyUID"));
				list.add(bean);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
}
