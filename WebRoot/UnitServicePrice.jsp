<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import  ="com.utils.CommonUtil" %>
<%@ page import  ="java.io.IOException"%>
<%@ page import  ="net.sf.json.JSONObject"%>
<%@ page import=" iu.dbc.DatabaseConnection"%>
<%@ page import="java.sql.Connection"%>
<%@ page import=" java.sql.PreparedStatement"%>
<%@ page import=" java.sql.ResultSet"%>
<%@ page import=" java.sql.SQLException"%>
<%@ page import= "java.text.ParseException"%>
<%@ page import= "java.text.SimpleDateFormat"%>
<%

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String RelatedstudyUID = request.getParameter("RELATEDSTUDYUID");
String RequestTime = request.getParameter("REQUESTTIME");

 //session = request.getSession(); 

//session.setAttribute("RealRequestTime", RequestTime);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;  charset=utf-8">
<title>申请团队服务价格</title>
<meta name="viewport"content="width=device-width, initial-scale=1, user-scalable=0">
<meta name="format-detection" content="telephone=no">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<script src="js/zepto.min.js"></script>
<link rel="stylesheet" href="http://cdn.bootcss.com/weui/0.3.0/style/weui.css">
<style type="text/css" media="screen">
.btn-block {
	margin-top: 15px;
	padding: 0 15px;
}

.page-title {
	text-align: center;
	margin-left: auto;
	margin-right: auto;
}

.text-center {
	text-align: center;
}

.hidden {
	display: none !important;
}

.hd {
	margin-top: 15px;
}

.hd>* {
	margin-bottom: 15px;
}

.que,.que:hover,.que:active {
	color: green;
}

.err,.err:hover,.err:active {
	color: #999933;
}

.img-thumbnail {
	/*      display: inline-block;*/
	width: 100%;
	height: auto;
	line-height: 1.42857143;
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 4px;
	-webkit-transition: all .2s ease-in-out;
	-o-transition: all .2s ease-in-out;
	transition: all .2s ease-in-out;
}

.number {
	text-align: center;
	font-size: 30px;
	text-decoration-color: black;
}
</style>
</head>
<body>
<div id="Unitdiv" style="background-color:white;margin-top:10px;width:520px" >
	<form  id="Unitform"   method="post">
	<table border="0" cellspacing="10">
	<div class="weui_cells_title">请选择相应会诊团队</div>
	
    		    		
		
<% 
    DatabaseConnection dbc = null;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    dbc = new DatabaseConnection();
    conn = dbc.getConnection();
    String sql = "select Groupname,ConsultPrice,ProvideConsult from IU_Group where ConsultPrice>0 and ConsultPrice is not null";
    String ConsultPrice="";
    String Groupname="";
    int ProvideConsult=0;
    String serviceType="影像会诊";
    ps = conn.prepareStatement(sql);
    
    rs = ps.executeQuery();
    
//List<String> RelatedstudyUIDs = new ArrayList<String>();
    String study="";
    while (rs.next()) {
    	ProvideConsult=rs.getInt("ProvideConsult");
    	if(ProvideConsult==1){
    		serviceType="影像会诊";
    	}else if(ProvideConsult==2){
    		serviceType="临床会诊";
    	}
    	Groupname=rs.getString("Groupname");
    	ConsultPrice=rs.getString("ConsultPrice");
    	
	 
%>

    <div class="weui_cells weui_cells_access">	
    <a class="weui_cell" href="RemoteMainServlet?RELATEDSTUDYUID= <%=RelatedstudyUID %> &REQUESTTIME=<%=RequestTime %> &GROUPNAME=<%=Groupname %>&SERVICETYPE='<%=serviceType %>'&CONSULTPRICE=<%=ConsultPrice %>" >
        <div class="weui_cell_hd">
           <!--  <img src="" alt="icon" style="width:20px;margin-right:5px;display:block"> -->
        </div>
        <div class="weui_cell_bd weui_cell_primary">
            <p><%=Groupname %></p>
        </div>
        <div class="weui_cell_ft">
         <%=serviceType %> &nbsp <%=ConsultPrice %>
        </div>
    </a>
    </div>
           <%-- <a href="javascript:void(0)" onclick="submitForm()" class="weui_btn weui_btn_disabled weui_btn_default"><%=SourceUnit %> &nbsp <%=AccessNumber %> &nbsp <%=RequestTime %></a> --%>
			<%-- <tr><td><input id="check"   type="button" name="check" onclick="submitForm()" value="<%=SourceUnit %> &nbsp <%=AccessNumber %> &nbsp <%=RequestTime %>" ></td></tr> --%>
	
	<%
		}
    conn.close();
		 %>								
	</table>
	</form>
</div>
</body>
</html>