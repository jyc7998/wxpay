<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta charset="utf-8">
    <title>影联网影像报告系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
    <meta name="format-detection" content="telephone=no">
    <script src="js/zepto.min.js"></script>
    <link rel="stylesheet" href="css/weui.css">
    <style type="text/css" media="screen">
    .page-title {
      text-align: center;
      margin-left: auto; 
      margin-right: auto;
    }    .text-center {
      text-align: center;
    }
    .hd > * {
      margin-bottom: 15px;
    }
    .que,
    .que:hover,
    .que:active {
      color: green;
    }
    .err,
    .err:hover,
    .err:active {
      color: #999933;
    }
    </style>
  </head>
<body ontouchstart>
	<div class="container js_container">
		<div class="page">
			<div class="weui_msg">
				<div class="weui_icon_area">
					<i class="weui_icon_success weui_icon_msg"></i>
				</div>
				<div class="weui_text_area">
					<h2 class="weui_msg_title">操作成功</h2>
					<p class="weui_msg_desc">获取手机报告成功，我们会在影像拍摄完成后给您发送报告！</p>
				</div>
				<div class="weui_opr_area">
					<p class="weui_btn_area">
						<!-- <a href="#" class="weui_btn weui_btn_primary">确定</a>  -->
						<%
						String flag = (String) session.getAttribute("returnPage");
						if(flag.equals("Report"))
						{
						 %>
						<a href="ReportList.jsp" class="weui_btn weui_btn_default">返回</a>
						<%
						}else if(flag.equals("notification")){
						 %>
						<a href="notificationRecord.jsp" class="weui_btn weui_btn_default">返回</a>
						<%
						}
						 %>
					</p>
				</div>
				<!-- <div class="weui_extra_area">
					<a href="">查看详情</a>
				</div> -->
			</div>
		</div>
	</div>

</body>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
</html>
