package iu.message;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import iu.dbc.DatabaseConnection;

public class WechatProcess {
	
	DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement pstmt = null ;
	
	/** 
     * 解析处理xml、获取智能回复结果（通过图灵机器人api接口） 
     * @param xml 接收到的微信数据 
     * @return  最终的解析结果（xml格式数据） 
     */  
    public String processWechatMag(String xml){  
        /** 解析xml数据 */  
        ReceiveXmlEntity xmlEntity = new ReceiveXmlProcess().getMsgEntity(xml);  
          
        /** 以文本消息为例，调用图灵机器人api接口，获取回复内容 */  
        String result = "";  
        String hospitalName = "";
        String eventKey = "";
        String openID = "";
        int sceneID = 0;
		if ("text".endsWith(xmlEntity.getMsgType())){  			
            //result = new TulingApiProcess().getTulingResult(xmlEntity.getContent());  
        } else if("SCAN".equals(xmlEntity.getEvent())&&xmlEntity.getEventKey()!=null){
        	eventKey = xmlEntity.getEventKey();       	
        	openID = xmlEntity.getFromUserName();
        	try{
        		sceneID = Integer.parseInt(eventKey);
        	}catch(Exception e){
        		e.printStackTrace();
        	}      
        	hospitalName = getHospitalName(sceneID);
        	if("".equals(hospitalName)){
        		result = "查询不到医院信息，请再扫描一次医院二维码";
        	} else{
        		result = "您所在医院为：" + hospitalName;
        		result += "\n<a>href='http://wx.imagingunion.com/iuwx/index.jsp'>扫一扫查询病例请点此</a>"
        				+ "\n<a>href='http://wx.imagingunion.com/iuwx/ReportList.jsp'>获取诊断报告请点此</a>"
        				+ "\n<a>href='http://wx.imagingunion.com/iuwx/Remoteindex.jsp'>申请专家远程会诊请点此</a>";
        		insertUserHospital(openID,hospitalName);
        	}
        } else if("subscribe".equals(xmlEntity.getEvent())&&xmlEntity.getEventKey()!=null){
        	eventKey = xmlEntity.getEventKey();
        	openID = xmlEntity.getFromUserName();
        	try{
        		sceneID = Integer.parseInt(eventKey.substring(8));
        	}catch(Exception e){
        		e.printStackTrace();
        	}      
        	hospitalName = getHospitalName(sceneID);
        	if("".equals(hospitalName)){
        		result = "查询不到医院信息，请再扫描一次医院二维码";
        	} else{
        		result = "您所在医院为：" + hospitalName;
        		result += "\n<a>href='http://wx.imagingunion.com/iuwx/index.jsp'>扫一扫查询病例请点此</a>"
        				+ "\n<a>href='http://wx.imagingunion.com/iuwx/ReportList.jsp'>获取诊断报告请点此</a>"
        				+ "\n<a>href='http://wx.imagingunion.com/iuwx/Remoteindex.jsp'>申请专家远程会诊请点此</a>";
        		insertUserHospital(openID,hospitalName);
        	}       	
        }else{
        	//result = "不知道你在说什么";
        }
        /** 此时，如果用户输入的是“你好”，在经过上面的过程之后，result为“你也好”类似的内容  
         *  因为最终回复给微信的也是xml格式的数据，所有需要将其封装为文本类型返回消息 
         * */  
        result = new FormatXmlProcess().formatXmlAnswer(xmlEntity.getFromUserName(), xmlEntity.getToUserName(), result);        
        return result;  
    }
    public String getHospitalName(int sceneID){
    	String hospitalName = "";
		try {
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT HospitalName FROM IU_ConnectedHospital WHERE ScenceID = ?" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setInt(1,sceneID) ;
			ResultSet rs = pstmt.executeQuery() ;	
			if(rs.next()){
				hospitalName = rs.getString("HospitalName");
			}
			conn.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return hospitalName;
    }
    public boolean insertUserHospital(String openID,String hospitalName){
    	boolean isSuccess = false;
    	try {
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT id FROM IU_WX_UserHospital WHERE openID = ?" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,openID) ;
			ResultSet rs = pstmt.executeQuery() ;	
			if(rs.next()){
				sql = "UPDATE IU_WX_UserHospital SET hospoitalName=? WHERE openID=?";
			}else{
				sql = "INSERT INTO IU_WX_UserHospital(hospitalName,openID) VALUES (?,?)";
			}
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,hospitalName) ;
			pstmt.setString(2,openID) ;
			int result = pstmt.executeUpdate() ;
			if(result > 0)
				isSuccess = true;
			conn.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return isSuccess;
    }
}
