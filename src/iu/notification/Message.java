package iu.notification;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.InputStream;

import iu.config.WXConfig;
import iu.dbc.DatabaseConnection;
import iu.utils.AccessToken;
import iu.utils.WeixinUtil;

public class Message extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public final static String APPID = WXConfig.APPID;
	public final static String APP_SECRET = WXConfig.APPSECRET;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		this.doPost(request, response);
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String openid = request.getParameter("openid");
		String contentID = new String(request.getParameter("contentID").getBytes("ISO-8859-1"), "UTF-8");
		String content = getNoticeContent(contentID);
		AccessToken accesstoken = WeixinUtil.getAccessToken(APPID, APP_SECRET);
		String ACCESSTOKEN = accesstoken.getToken();
		String url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=" + ACCESSTOKEN;
		String params = "{\"touser\":\"" + openid + "\",\"msgtype\":\"text\",\"text\":{\"content\":\"" + content + "\"}}";
		String result = post(url, params);
		out.print(result);
		out.close();
	}
	
	public String getNoticeContent(String contentID){
		String content = "";
		try {
			DatabaseConnection dbc = null;
			Connection conn = null ;
			PreparedStatement pstmt = null ;
			dbc = new DatabaseConnection();
			conn = dbc.getConnection();
			String sql = "SELECT MessageText FROM IU_WxMessages WHERE MessageUID = ?" ;
			pstmt = conn.prepareStatement(sql) ;
			pstmt.setString(1,contentID) ;
			ResultSet rs = pstmt.executeQuery() ;	
			if(rs.next()){
				content = rs.getString("MessageText");
			}
			conn.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return content;
	}

	public static String post(String strURL, String params) {
		try {
			URL url = new URL(strURL);// 创建连接
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setUseCaches(false);
			connection.setInstanceFollowRedirects(true);
			connection.setRequestMethod("POST"); // 设置请求方式
			connection.setRequestProperty("Accept", "application/json"); // 设置接收数据的格式
			connection.setRequestProperty("Content-Type", "application/json"); // 设置发送数据的格式
			connection.connect();
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream(), "UTF-8"); // utf-8编码
			out.append(params);
			out.flush();
			out.close();
			// 读取响应
			int length = (int) connection.getContentLength();// 获取长度
			InputStream is = connection.getInputStream();
			if (length != -1) {
				byte[] data = new byte[length];
				byte[] temp = new byte[512];
				int readLen = 0;
				int destPos = 0;
				while ((readLen = is.read(temp)) > 0) {
					System.arraycopy(temp, 0, data, destPos, readLen);
					destPos += readLen;
				}
				String result = new String(data, "UTF-8"); // utf-8编码
				return result;
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "error"; // 自定义错误信息
	}

}
