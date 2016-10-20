<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="iu.dbc.DatabaseConnection"%>
<%@ page import="iu.utils.AsyCryptography"%>

<%
	request.setCharacterEncoding("UTF-8");
	String UID=request.getParameter("UID");
	System.out.println(UID);
	String pharchive="",userrealname="",sex="",birthday="", birthAddress="", currentAddress="",mobilephone="",usermail="",userqq="";
	String occupation="",AllergicDescription="",PastHistory="";
	DatabaseConnection dbc = null;
 	Connection conn = null;
 	PreparedStatement ps = null;
 	ResultSet rs = null;
 	try {
 		dbc = new DatabaseConnection();
 		conn = dbc.getConnection();
 		String sql = "select Name,Sex ,DateOfBirth,Occupation,BirthAddress,CurrentAddress,Telephone,QqNumber,Email,AllergicHistory,PastHistory from IU_PhrOwnerInfo where PhrOwnerUID=? ";
 		ps = conn.prepareStatement(sql);
 		ps.setString(1, UID);
 		rs = ps.executeQuery();
 		while (rs.next()) {
 			userrealname= rs.getString(1);
 			sex=rs.getString(2);
 			birthday= rs.getString(3);
 			occupation = rs.getString(4);
 			birthAddress = rs.getString(5);
 			currentAddress = rs.getString(6);
 			mobilephone = rs.getString(7);
 			userqq = rs.getString(8);
 			usermail = rs.getString(9);
 			AllergicDescription = rs.getString(10);
 			PastHistory = rs.getString(11);
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
<script src="js/dist/lrz.bundle.js"> </script>
<style type="text/css">
.hello a{text-decoration:underline;}
.title {
  margin-top: .77em;
  margin-bottom: .3em;
  padding-left: 15px;
  padding-right: 15px;
  color: #0BB20C ;#888
  font-size: 14px;
}
</style>
<script language="JavaScript" type="text/javascript">
var a;
function Modify_Phr(a){
		$.cookie("flag","true");
	/* 	var xuhai= $.cookie("flag");
		alert(xuhai); */
		window.location.href="HealthArchive.jsp?UID="+a;
}
function Add_Image(a){
	window.location.href="reportRecord.jsp?UID="+a;
}
$(window).bind('resize load', function(){
	$("body").css("zoom", $(window).width() / 380);
	$("body").css("display" , "block");
	});
</script>

</head>	
<body>
	<form name="HealthForm" id="HealthForm" action="HealthArchiveServlet" method="post">
	<!-- <div class="weui_cells">
		<div class="weui_cell weui_cell_select weui_select_after">
			<div class="weui_label">档案归类</div>
				<div style="position:relative;">
					
				</div>  
				
	</div>
	</div> -->
		 
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">姓名</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=userrealname%>
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
			<%=mobilephone%>	
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">出生地</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=birthAddress%>	
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">工作地</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=currentAddress%>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">邮箱</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=usermail%>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">qq</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=userqq%>
		</div>
	</div>
	<div class="weui_cell">
		<div class="weui_cell_hd">
			<label class="weui_label">职业</label>
		</div>
		<div class="weui_cell_bd weui_cell_primary">
			<%=occupation%>
		</div>
	</div>
	<div class="title">过敏史</div>
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
				<%=AllergicDescription%>
			</div>
		</div>
	</div>
	<div class="title">既往病史</div>
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
				<%=PastHistory %>
			</div>
		</div>
	</div>
	<div class="title">病例资料</div>
	<div class="weui_cells weui_cells_form">
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
		
	
	<% 
	 	try {
	 		dbc = new DatabaseConnection();
	 		conn = dbc.getConnection();
	 		String sql = "select PicStudyUID,UploadTime,PicDataKind from IU_PhrOwnerPicData where PhrOwnerUID=? order by UploadTime desc";
	 		ps = conn.prepareStatement(sql);
	 		ps.setString(1, UID);
	 		rs = ps.executeQuery();
	 		int num=0;
	 		while (rs.next()) {
	 		num++; 
	 		AsyCryptography asy = new AsyCryptography();
	 		String link = "";  	
    		link = "http://wx.imagingunion.com" + "/MobilePhone/SendBrowseAddress.jsp?";
    		link += asy.getEncrypt(rs.getString(1));
    		link += "&imgFile=" + rs.getString(1).hashCode();
    		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	 			%>
	 <div class="hello">
			<a href="<%=link%>"><%=num %>、<%=sdf.format(format1.parse(rs.getString(2)))%>上传了图像资料(<%=rs.getString(3) %>)</a>
	 </div>
	 			
	 <%	}
	 		conn.close();
	 	} catch (Exception e) {
	 		e.printStackTrace();
 		}
	%>
			
			</div>
		</div>
	</div>
	<div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="button" name="modifyPhr" id="modifyPhr" value="修改资料"   onclick="Modify_Phr('<%=UID%>')"/>
	</div>	
	<div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="button" name="AddImage" id="AddImage" value="关联影像检查"   onclick="Add_Image('<%=UID%>')"/>
	</div>
	<div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="button" name="AddPhoto" id="AddPhoto" value="拍照上传"   onclick="upload()"/>
	</div>
	</form>
	
</body>

<input id="upload" class="weui_uploader_input" type="file"
		accept="image/jpg,image/jpeg,image/png" multiple="" style='display:none'>
<script type="text/javascript">
	var gender='<%=sex%>';
	if(gender=='男'){
		$("input[name='Sex'][value='男']").attr("checked",true);
		}else{
		$("input[name='Sex'][value='女']").attr("checked",true);
	}
</script>

<!-- 上传部分 -->
<script type="text/javascript">
		function upload(){
			$("#upload").click()
		}
		var tmpimg = new Image();
		var imgNum;
    	$("input:file").change(function() {
    	showToast('loadingToast', '图片上传中'); 
 		lrz(this.files[0],{width: 128},{height: 128})
        	.then(function (rst) {           				
				tmpimg.src = rst.base64;				
       		 })           		       		       		 
       	lrz(this.files[0],{width: 1024},{height: 1024})
        	.then(function (rst) {           				
       	     $.ajax({
					type: "post",
					url: "ImgUpload",
					data:"image="+rst.base64,
					dataType: "HTML",
					timeout: 60000,
					error: function(result){
						alert("请求超时..");
					},
					 success: function(result){
					 	document.getElementById("viewImg").src = tmpimg.src;
						hideToast('loadingToast');
						imgNum = result;
						showDialog();						
					}
				}); 
			})
		});		 
	</script>
	
	<div id="loadingToast" class="weui_loading_toast" style="display:none;">
        <div class="weui_mask_transparent"></div>
        <div class="weui_toast">
            <div class="weui_loading">
                <div class="weui_loading_leaf weui_loading_leaf_0"></div>
                <div class="weui_loading_leaf weui_loading_leaf_1"></div>
                <div class="weui_loading_leaf weui_loading_leaf_2"></div>
                <div class="weui_loading_leaf weui_loading_leaf_3"></div>
                <div class="weui_loading_leaf weui_loading_leaf_4"></div>
                <div class="weui_loading_leaf weui_loading_leaf_5"></div>
                <div class="weui_loading_leaf weui_loading_leaf_6"></div>
                <div class="weui_loading_leaf weui_loading_leaf_7"></div>
                <div class="weui_loading_leaf weui_loading_leaf_8"></div>
                <div class="weui_loading_leaf weui_loading_leaf_9"></div>
                <div class="weui_loading_leaf weui_loading_leaf_10"></div>
                <div class="weui_loading_leaf weui_loading_leaf_11"></div>
            </div>
            <p class="weui_toast_content" id="tip">图片上传中</p>
        </div>
    </div>
    
    <div id="toast" style="display: none;">
        <div class="weui_mask_transparent"></div>
        <div class="weui_toast">
            <i class="weui_icon_toast"></i>
            <p class="weui_toast_content">已完成</p>
        </div>
    </div>
    
    <!--BEGIN dialog2-->
    <div class="weui_dialog_alert" id="dialog" style="display: none;">
        <div class="weui_mask"></div>
        <div class="weui_dialog">
            <div class="weui_dialog_hd"><strong class="weui_dialog_title">选择上传图像类别</strong></div>
            <div class="weui_dialog_bd">
            <div class="weui_icon_area">
            <img id="viewImg" src="" >
            </div>
        <div class="weui_cells weui_cells_radio">
            <label class="weui_cell weui_check_label" for="Type0">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>化验单</p>
                </div>
                <div class="weui_cell_ft">
                    <input type="radio" class="weui_check" name="radio" id="Type0" onclick="getValue(this)">
                    <span class="weui_icon_checked"></span>
                </div>
            </label>
            <label class="weui_cell weui_check_label" for="Type1">

                <div class="weui_cell_bd weui_cell_primary">
                    <p>检查报告</p>
                </div>
                <div class="weui_cell_ft">
                    <input type="radio" name="radio" class="weui_check" id="Type1" checked="checked" onclick="getValue(this)">
                    <span class="weui_icon_checked"></span>
                </div>
            </label>
        </div>
            </div>
            <div class="weui_dialog_ft">
                <a class="weui_btn_dialog primary" onclick="infoProcess()">确定</a>
            </div>
        </div>
    </div>
    <!--END dialog2-->
    
    <script>
    	var checkNum = '1';
    	function showToast(toast, tipInfo)
    	{
    		  if(toast == "loadingToast")
    		  		document.getElementById("tip").innerHTML = tipInfo;
              var $loadingToast = $('#' + toast);
              if ($loadingToast.css('display') != 'none') {
                      return;
                  }
              $loadingToast.show();
    	}
    	function hideToast(toast){
			var $loadingToast = $('#' + toast);
    	    	$loadingToast.hide();
    	}
		
		function showDialog(){
		
				var $dialog = $('#dialog');
                $dialog.show();
                $dialog.find('.weui_btn_dialog').one('click', function () {
                      $dialog.hide();
                    });
        }
        
        function getValue(value){
        	checkNum = value.id;
        	checkNum.replace('Type','');
        }
        
        function infoProcess(){
        	showToast('loadingToast', '正在处理您的请求...');
        	$.ajax({
					type: "post",
					url: "uploadInfoProcess",
					data:"imageNum=" + imgNum + "&imageType=" + 
							checkNum + "&uid=" + "<%=UID%>",
					dataType: "HTML",
					timeout: 10000,
					error: function(result){
						hideToast('loadingToast');
						alert("上传失败！");
					},
					 success: function(result){
						hideToast('loadingToast');	
						
						showToast('toast', '');
						setTimeout(function () {
                        	hideToast('toast');
                    	}, 2000);					
					}
				}); 
        }
    </script>

</html>
