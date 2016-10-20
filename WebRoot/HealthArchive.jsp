<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page import="iu.utils.JsSignUtil"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="java.sql.*"%>
<%@ page import="iu.dbc.DatabaseConnection"%>
<%
	String openid=(String)session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	//String username="admin";
	String UID=request.getParameter("UID");
	//System.out.println(UID);
	String pharchive="",userrealname="",sex="",birthday="", birthAddress="", currentAddress="",mobilephone="",usermail="",userqq="";
	String occupation="",AllergicDescription="",PastHistory="";
	String archives="", userbirthprovince = "", userbirthcity = "", userworkprovince = "", userworkcity = "";
	DatabaseConnection dbc = null;
 	Connection conn = null;
 	PreparedStatement ps = null;
 	ResultSet rs = null;
 	try {
 		dbc = new DatabaseConnection();
 		conn = dbc.getConnection();
 		String sql = "select distinct Relationship from IU_PhrCreatorData where CreatorOpenID=?";
 		ps = conn.prepareStatement(sql);
 		ps.setString(1, openid);
 		rs = ps.executeQuery();
 		while (rs.next()) {
 			archives += rs.getString("Relationship") + "/";
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no,target-densitydpi=device-dpi">
<title>健康档案</title>
<link rel="icon" type="image/png" href="images/favicon.png" />
<link rel="stylesheet" href="css/weui.css">
<script src="js/jquery-2.1.4.min.js" type="text/javascript" charset="utf-8"></script>
<script src="js/jquery.cookie.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
function validate(){
	if (document.HealthForm.HealthArchives.value==""){
		alert("档案分类不能为空.");
		document.HealthForm.HealthArchives.focus();
		return false ;
	}if (document.HealthForm.userrealname.value==""){
		alert("姓名不能为空.");
		document.HealthForm.userrealname.focus();
		return false ;
	}
		return true;
}
		
	$(function(){
                var HealthArchives=[];                 
                HealthArchives="<%=archives%>".split("/");
                var Category=document.getElementById('Category');  
                for(var i=0;i<HealthArchives.length-1;i++){
                Category.options.add(new Option(HealthArchives[i],HealthArchives[i]));                 
                }                   
            });
                    
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
<body ontouchstart>
<div class="container js_container">
		<div class="page">

	<form name="HealthForm" id="HealthForm" action="HealthArchiveServlet" method="post" onsubmit="return validate()">
	<div class="weui_cells">
		<div class="weui_cell weui_cell_select weui_select_after">
			<div class="weui_label">档案归类</div>
				<div style="position:relative;">
					<select id="Category" name='Category' style="width:170px;height:30px;" onchange="document.getElementById('HealthArchives').value=this.value"> 			 
					</select> 
					<input id="HealthArchives" name="HealthArchives" value="" placeholder="自定义" style="position:absolute;width:149px;height:27px;left:1px;top:2px;border-bottom:0px;border-right:0px;border-left:0px;border-top:0px;color:#FF0000;"> 
				</div>  
				
	</div>
	</div>
		
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">姓名</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input" name="userrealname"  id="userrealname" value="" placeholder="请输入姓名"/>
			<input type="hidden" name="flag" id="flag" value="1">
			<input type="hidden" name="level" id="level" value=<%=UID %>>
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
			<input class="weui_input" type="date" name="birthday" id="birthday" value=""  />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">手机</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input" type="number" pattern="[0-9]*" name="usermobilephone" id="usermobilephone" value="" placeholder="请输入号码" />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">出生地</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input"  name="birthplace" id="birthplace" value=""   />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">工作地</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input"  name="workplace" id="workplace" value=""   />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">邮箱</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input"  name="useremail" id="useremail" value="" placeholder="请输入邮箱" />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">qq</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input" type="number" name="userqq" id="userqq" pattern="[0-9]*" value="" placeholder="请输入qq号" />
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">职业</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<input class="weui_input" name="useroccupation" id="useroccupation" value="" placeholder="请输入职业" />
		</div>
	</div>
	<div class="title">过敏史</div>
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
				<textarea name='AllergicDescription' id='AllergicDescription' class="weui_textarea" value="" rows="3"></textarea>
			</div>
		</div>
	</div>
	<div class="title">既往病史</div>
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
				<textarea  name='PastHistory' id='PastHistory' class="weui_textarea" value="" rows="3"></textarea>
			</div>
		</div>
	</div>
	<div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="submit" name="submit" id="submit" value="提交"/>
	</div>	
	</form>
	</div>
</div>
</body>
<script type="text/javascript">

	var flag1;
	flag1=$.cookie("flag");
	if(flag1=="true"){
		var a='<%=UID%>';
		$.ajax({
					type : "post",
					url :"HealthArchiveServlet",
					data : "flag="+4+"&level="+a,
					success : function(data) {
						var obj=eval(data); //解析json对象  
						$("#userrealname").val(obj[0]);
						if(obj[1]=='男'){
							$("input[name='Sex'][value='男']").attr("checked",true);
							}else{
							$("input[name='Sex'][value='女']").attr("checked",true);
						}
						$("#birthday").val(obj[2]);//出生日期
						$("#useroccupation").val(obj[3]);// occupation						
	    				$("#birthplace").val(obj[4]);//birthA
						$("#workplace").val(obj[5]);	//workA
						$("#usermobilephone").val(obj[6]);
						$("#userqq").val(obj[7]);
						$("#useremail").val(obj[8]);
						$("#AllergicDescription").val(obj[9]);
						$("#PastHistory").val(obj[10]);
					 	$("#HealthArchives").val(obj[11]);
					 	$("#flag").val(5);
						
					}
				});
		
		$.cookie("flag",null);
	}
	


</script>
</html>
