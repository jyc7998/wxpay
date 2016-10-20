<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import  ="com.utils.CommonUtil" %>
<%@ page import  ="java.io.IOException"%>
<%@ page import  ="net.sf.json.JSONObject"%>
<%@ page import="iu.dbc.DatabaseConnection"%>
<%@ page import="java.sql.Connection"%>
<%@ page import=" java.sql.PreparedStatement"%>
<%@ page import=" java.sql.ResultSet"%>
<%@ page import=" java.sql.SQLException"%>
<%@ page import= "java.text.ParseException"%>
<%@ page import= "java.text.SimpleDateFormat"%>

<%@ page import= "com.utils.GetWxOrderno"%>
<%@ page import= "com.utils.RequestHandler"%>
<%@ page import= "com.utils.Sha1Util"%>
<%@ page import= "com.utils.TenpayUtil"%>
<%@ page import= "com.utils.WeixinOauth2Token"%>
<%@ page import= "com.utils.http.HttpResponse"%>



<%@ page import="iu.utils.JsSignUtil"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%

	//String openid="oJNPFwLbOKBLTOoIiogm8DdTdgjU";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;  charset=utf-8">
<title>过往手机报告</title>
<link rel="stylesheet" href="css/weui.css">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<style>
.page,body {
	background-color: #fbf9fe
}

.page_title {
	text-align: center;
	font-size: 34px;
	color: #3cc51f;
	font-weight: 400;
	margin: 0 15%
}
</style>


<%
	//网页授权后获取传递的参数
	 String userId = request.getParameter("userId");
	String orderNo = request.getParameter("orderNo");
	String money = request.getParameter("money");
	String code = request.getParameter("code");
	//商户相关资料 
	String appid = "wx2075a7c5fa000226";
	String appsecret = "9fa40cfb063d725d1f2b25b73f545a70";
	String partner = "1316177201";
	String partnerkey = "hefeiyingliankejiyouxiangongsi88";

	//String openId = "";
	String URL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + appid + "&secret=" + appsecret + "&code=" + code
			+ "&grant_type=authorization_code";//获取用户的openid
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	System.out.println("openid为："+openid); 
%>
</head>


<body>
  <body ontouchstart>
  <div class="page">
    <div class="hd">
        <h1 class="page_title" style="color:#0072E3">过往手机报告</h1>
    </div>
   </div>


	<form  id="Requestform"   method="post">

		
		
<% //String openid="oJNPFwFa6IX5tRJAPDhBTQLkDYl8";
    DatabaseConnection dbc = null;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    dbc = new DatabaseConnection();
    conn = dbc.getConnection();
    String sql = "select RelatedStudyUID,SourceUnit,AccessNumber,RequestTime from IU_RequestReport where WxUserOpenID=?";

    ps = conn.prepareStatement(sql);
    ps.setString(1, openid);
    rs = ps.executeQuery();
    String RelatedstudyUID="";
    String SourceUnit="";
    String AccessNumber="";
    String requestTime="";
    SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    

    String study="";
    while (rs.next()) {
	  RelatedstudyUID=rs.getString("RelatedStudyUID");
	  SourceUnit=rs.getString("SourceUnit");
	  AccessNumber=rs.getString("AccessNumber");
	  requestTime=rs.getString("RequestTime");
	  
	  String RequestTime = sdf.format(format1.parse(requestTime));
%>
    <a style="color:#0072E3"class="" href="UnitServicePrice.jsp?RELATEDSTUDYUID= <%=RelatedstudyUID %> &REQUESTTIME=<%=RequestTime %>">
    <div class="weui_cells">

            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>医院</p>
                </div>
                <div class="weui_cell_ft"><%=SourceUnit%></div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>取片单编号</p>
                </div>
                <div class="weui_cell_ft"><%=AccessNumber %></div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>申请时间</p>
                </div>
                <div class="weui_cell_ft"><%=RequestTime %></div>
            </div>
      
   
    </div>
     </a>
          

	<%
		}
    conn.close();
		 %>		
		
	
		
	
	</form>
		

</body>
</html>