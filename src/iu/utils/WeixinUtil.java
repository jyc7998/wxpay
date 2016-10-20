package iu.utils;

import iu.config.WXConfig;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SecureRandom;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.utils.CommonUtil;


public class WeixinUtil {
	private static Logger log = Logger.getLogger(WeixinUtil.class);
	public final static String APPID = WXConfig.APPID;
	public final static String APP_SECRET = WXConfig.APPSECRET;
	public final static String access_token_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET";
	public final static Map<String, Object> accessTokenMap = new HashMap<String, Object>();

	public static String getAppid() {
		return APPID;
	}


	public static AccessToken getAccessToken(String appid, String appSecret) {
		AccessToken at = new AccessToken();

		if (!accessTokenMap.isEmpty()) {
			Date getTokenTime = (Date) accessTokenMap.get("getTokenTime");
			Calendar c = Calendar.getInstance();
			c.setTime(getTokenTime);
			c.add(Calendar.HOUR_OF_DAY, 2);

			getTokenTime = c.getTime();
			if (getTokenTime.after(new Date())) {

				String token = (String) accessTokenMap.get("token");
				Integer expire = (Integer) accessTokenMap.get("expire");
				at.setToken(token);
				at.setExpiresIn(expire);
				return at;
			}
		}
		String requestUrl = access_token_url.replace("APPID", APPID).replace("APPSECRET", APP_SECRET);

		JSONObject object = handleRequest(requestUrl, "GET", null);
		String access_token = object.getString("access_token");
		int expires_in = object.getInt("expires_in");

		log.info("\naccess_token:" + access_token);
		log.info("\nexpires_in:" + expires_in);

		at.setToken(access_token);
		at.setExpiresIn(expires_in);


		accessTokenMap.put("getTokenTime", new Date());
		accessTokenMap.put("token", access_token);
		accessTokenMap.put("expire", expires_in);

		return at;
	}


	public static String getJsApiTicket(String access_token) {
		String url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi";

		String requestUrl = url.replace("ACCESS_TOKEN", access_token);		
		JSONObject jsonObject = handleRequest(requestUrl, "GET", null);
		String ticket = null;
		if (null != jsonObject) {
			try {
				ticket = jsonObject.getString("ticket");
			} catch (JSONException e) {
				ticket = null;
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return ticket;
	}
	public static void requestOpenId(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String host = request.getRequestURL().toString();
		String fromUrl = request.getServletPath().substring(1);
		host = host.replaceAll(request.getServletPath(), "/OpenIdHandler?fromUrl="+fromUrl);
		String redirect_uri = URLEncoder.encode(host, "UTF-8");
		String url = "https://open.weixin.qq.com/connect/oauth2/authorize?";
		url += "appid=" + WXConfig.APPID;
		url += "&redirect_uri=" + redirect_uri;
		url += "&response_type=code&scope=snsapi_userinfo&state=123#wechat_redirect";
		response.sendRedirect(url);
	}
	
	public static String getOpenId(String code) throws Exception {
		String url = "https://api.weixin.qq.com/sns/oauth2/access_token?";
		url += "appid=" + WXConfig.APPID;
		url += "&secret=" + WXConfig.APPSECRET;
		url += "&code=" + code;
		url += "&grant_type=authorization_code";
		// 请求url以获取数据
		String openid = null;
		JSONObject jsonObject = CommonUtil.httpsRequest(url, "GET", null);
		if (null != jsonObject) {
			openid = jsonObject.getString("openid");
		}
		return openid;
	}

	public static JSONObject handleRequest(String requestUrl, String requestMethod, String outputStr) {
		JSONObject jsonObject = null;

		try {
			URL url = new URL(requestUrl);
			HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
			SSLContext ctx = SSLContext.getInstance("SSL", "SunJSSE");
			TrustManager[] tm = { new MyX509TrustManager() };
			ctx.init(null, tm, new SecureRandom());
			SSLSocketFactory sf = ctx.getSocketFactory();
			conn.setSSLSocketFactory(sf);
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setRequestMethod(requestMethod);
			conn.setUseCaches(false);

			if ("GET".equalsIgnoreCase(requestMethod)) {
				conn.connect();
			}

			if (StringUtils.isNotEmpty(outputStr)) {
				OutputStream out = conn.getOutputStream();
				out.write(outputStr.getBytes("utf-8"));
				out.close();
			}

			InputStream in = conn.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(in, "utf-8"));
			StringBuffer buffer = new StringBuffer();
			String line = null;

			while ((line = br.readLine()) != null) {
				buffer.append(line);
			}

			in.close();
			conn.disconnect();

			jsonObject = JSONObject.fromObject(buffer.toString());
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (NoSuchProviderException e) {
			e.printStackTrace();
		} catch (KeyManagementException e) {
			e.printStackTrace();
		}
		return jsonObject;
	}

}
