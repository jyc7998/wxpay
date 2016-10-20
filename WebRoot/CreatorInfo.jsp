<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="iu.dbc.DatabaseConnection"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    
 <title>个人信息</title>
  <link rel="stylesheet" href="css/weui.css">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no,target-densitydpi=device-dpi">
  <script src="js/jquery-2.1.4.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="js/jquery.cookie.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
function validate(){
	if (document.CreatorInfo.userrealname.value==""){
		alert("姓名不能为空.");
		document.CreatorInfo.userrealname.focus();
		return false ;
	}
		return true;
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
			<input class="weui_input" name="userrealname"  id="userrealname" value="" placeholder="请输入姓名"/>
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
    <div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="submit" name="submit" id="submit" value="提交"/>
	</div>
</form>	
</body>
<script>
	var flag2;
	flag2=$.cookie("flagg");
	if(flag2=="true"){
		$.ajax({
			type : "post",
			url :"HealthArchiveServlet",
			data : "flag="+7,
			success : function(data) {
				var obj=eval(data); //解析json对象
				/* jsonArray.put(creatorname);
 				jsonArray.put(creatorsex);
 			jsonArray.put(creatorbirthday);
 			jsonArray.put(creatoroccupation);
 			jsonArray.put(creatortelephone);
 			jsonArray.put(creatorqq);
 			jsonArray.put(creatoremail); */
 				$("#userrealname").val(obj[0]);
				if(obj[1]=='男'){
					$("input[name='Sex'][value='男']").attr("checked",true);
					}else{
					$("input[name='Sex'][value='女']").attr("checked",true);
				}
				$("#birthday").val(obj[2]);//出生日期
				$("#useroccupation").val(obj[3]);// occupation						
   				
				$("#usermobilephone").val(obj[4]);
				$("#userqq").val(obj[5]);
				$("#useremail").val(obj[6]);
				$("#flag").val(8);
				}
				}); 
				
				$.cookie("flag",null); 
			}
		
</script>
</html>
