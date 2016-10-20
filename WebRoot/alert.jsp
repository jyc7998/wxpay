<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import  ="com.utils.CommonUtil" %>
<%@ page import  ="java.io.IOException"%>
<%@ page import  ="net.sf.json.JSONObject"%>
<%@ page import="java.sql.Connection"%>
<%@ page import=" java.sql.PreparedStatement"%>
<%@ page import=" java.sql.ResultSet"%>
<%@ page import=" java.sql.SQLException"%>
<%@ page import= "java.text.ParseException"%>
<%@ page import= "java.text.SimpleDateFormat"%>
<%@ page import="iu.utils.JsSignUtil"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="iu.dbc.DatabaseConnection"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;  charset=utf-8">
<title>过往报告通知</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=0">
<meta name="format-detection" content="telephone=no">
<script src="js/zepto.min.js"></script>
<script src="js/jquery-2.14.min.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<link rel="stylesheet"
	href="http://cdn.bootcss.com/weui/0.3.0/style/weui.css">
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

<div class="page">
    <div class="bd spacing">
        <a  class="weui_btn weui_btn_primary" id="showDialog2">点击弹出Dialog样式二</a>
    </div>
    <!--BEGIN dialog2-->
    <div class="weui_dialog_alert" id="dialog2" style="display: none;">
        <div class="weui_mask"></div>
        <div class="weui_dialog">
            <div class="weui_dialog_hd"><strong class="weui_dialog_title">弹窗标题</strong></div>
            <div class="weui_dialog_bd">弹窗内容，告知当前页面信息等</div>
            <div class="weui_dialog_ft">
                <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
            </div>
        </div>
    </div>
    <!--END dialog2-->
</div>


</body>
<script type="text/javascript">
 $("#showDialog2").click(function(){
     var $dialog = $('#dialog2');
     $dialog.show();
     $dialog.find('.weui_btn_dialog').one('click', function () {
         $dialog.hide();
         });  
});
</script>	
</html>