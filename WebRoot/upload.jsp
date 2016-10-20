<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,user-scalable=0">
<title>WeUI</title>
<link rel="stylesheet" href="css/weui.css" />
<script src="js/jquery-2.1.4.min.js"> </script>
<script src="js/dist/lrz.bundle.js"> </script>
<style>
.page,body {
	background-color: #fbf9fe
}

.page_title {
	text-align: center;
	font-size: 34px;
	color: #225fba;
	font-weight: 400;
	margin: 0 15%
}
</style>
</head>
<body>
	<div class="hd">
        <h1 class="page_title">上传图片</h1>
    </div>
	

	
	<a href="javascript:void(0);" class="weui_media_box weui_media_appmsg">
		<div class="weui_uploader">
			<div class="weui_uploader_input_wrp">
				<input id="upload" class="weui_uploader_input" type="file"
					accept="image/jpg,image/jpeg,image/png" multiple="">
			</div>
		</div>		
	</a>
	
	<script type="text/javascript">
		var tmpimg = new Image();
		var imgNum;
    	$("input:file").change(function() {
    	showToast('loadingToast', '图片上传中'); 
 		lrz(this.files[0],{width: 256},{height: 256})
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
        	var checkNum = value.id;
        }
        
        function infoProcess(){
        	showToast('loadingToast', '正在处理您的请求...');
        	$.ajax({
					type: "post",
					url: "uploadInfoProcess",
					data:"imageNum=" + imgNum,
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
</body>
</html>

