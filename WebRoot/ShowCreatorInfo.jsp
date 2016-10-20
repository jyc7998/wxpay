<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="java.sql.*"%>
<%@ page import="iu.dbc.DatabaseConnection"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	
	String openid=(String)session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	String creatorname="",sex="",birthday="",occupation="",telephone="",creatorqq="",email="";
	DatabaseConnection dbc = null;
 	Connection conn = null;
 	PreparedStatement ps = null;
 	ResultSet rs = null;
 	try {
 		dbc = new DatabaseConnection();
 		conn = dbc.getConnection();
 		String sql = "select Name,Sex ,DateOfBirth,Occupation,Telephone,QqNumber,Email from IU_PhrCreatorInfo where CreatorOpenID=? ";
 		ps = conn.prepareStatement(sql);
 		ps.setString(1, openid);
 		rs = ps.executeQuery();
 		if (rs.next()) {
 			creatorname= rs.getString(1);
 			sex=rs.getString(2);
 			birthday= rs.getString(3);
 			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
 			birthday = sdf.format(sdf.parse(birthday));
 			occupation = rs.getString(4);
 			telephone = rs.getString(5);
 			creatorqq = rs.getString(6);
 			email = rs.getString(7);
 		}
 		//System.out.print(archives);
 		conn.close();
 	} catch (Exception e) {
 		e.printStackTrace();
 	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    
 <title>个人信息</title>
  <link rel="stylesheet" href="css/weui.css">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no,target-densitydpi=device-dpi">
  <script src="js/jquery-2.1.4.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="js/jquery.cookie.js" type="text/javascript" charset="utf-8"></script>
  
<script type="text/javascript">
function ModifyInfo(){	
	$.cookie("flagg","true");
	/* var xuhai= $.cookie("flag");
	alert(xuhai); */
	window.location.href="CreatorInfo.jsp";
}
$(window).bind('resize load', function(){
	$("body").css("zoom", $(window).width() / 380);
	$("body").css("display" , "block");
});
</script>
<style type="text/css">
.title {
  margin-top: .77em;
  margin-bottom: .3em;
  padding-left: 15px;
  padding-right: 15px;
  color: #0BB20C ;#888
  font-size: 14px;
}
</style>	
</head>
  
<body>
	<form name="CreatorInfo" id="CreatorInfo" action="HealthArchiveServlet" method="post" onsubmit="return validate()">
		
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">姓名</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=creatorname %>
			<input type="hidden" name="flag" id="flag" value="6">
			<input type="hidden" name="level" id="level" value="">
		</div>
	</div>
	<div class="title">性别</div>
	<div class="weui_cells weui_cells_radio">
		<label class="weui_cell weui_check_label" for="Sex1">
		<div class="weui_cell_bd weui_cell_primary">
			<p>男</p>
			</div>
			<div class="weui_cell_ft">
				<input type="radio" class="weui_check" name="Sex" id="Sex1" value="男" > <span class="weui_icon_checked"></span>
			</div>
		</label>
		<label class="weui_cell weui_check_label" for="Sex2">

			<div class="weui_cell_bd weui_cell_primary">
				<p>女</p>
			</div>
			<div class="weui_cell_ft">
				<input type="radio" name="Sex" class="weui_check" id="Sex2" value="女"  > <span class="weui_icon_checked"></span>
			</div>
		</label>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label for="" class="weui_label">生日</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=birthday %>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">手机</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=telephone %>
		</div>
	</div>
	
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">邮箱</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=email %>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">qq</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=creatorqq %>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">职业</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=occupation %>
		</div>
	</div>
    <div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="button" name="modifyInfo" id="modifyInfo" value="修改个人信息" onclick="ModifyInfo()"/>
	</div>
</form>	
</body>
<script>
var username='<%=creatorname%>';
//alert(username);
if(username=null||username==""){
	alert("您还未录入过个人信息，请完善");
	window.location.href="CreatorInfo.jsp";
}
var UserSex='<%=sex%>';
if(UserSex=='男'){
	$("input[name='Sex'][value='男']").attr("checked",true);
	}else{
		$("input[name='Sex'][value='女']").attr("checked",true);
		}
</script>
</html>
