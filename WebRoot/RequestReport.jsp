<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String appId = request.getParameter("appid");
String timeStamp = request.getParameter("timeStamp");
String nonceStr = request.getParameter("nonceStr");
String packageValue = request.getParameter("package");
String paySign = request.getParameter("sign");
//String openid = request.getParameter("openid");
//String out_trade_no = request.getParameter("out_trade_no");
String totalmoney =request.getParameter("money");//session.getAttribute("requestReportTotalmoneys").toString();
//String NoticeReqUID=session.getAttribute("NoticeReqUID").toString();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>手机报告申请付款页面</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=0">
<meta name="format-detection" content="telephone=no">
<script src="js/zepto.min.js"></script>
<link rel="stylesheet"
	href="http://cdn.bootcss.com/weui/0.3.0/style/weui.css">
<script src="js/jquery-2.1.4.min.js" type="text/javascript"
	charset="utf-8"></script>
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
<!-- <link rel="stylesheet" href="exp.css" media="screen" title="no title" charset="utf-8"> -->
</head>
<body>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<div class="hd">
		<div class="page-title">
			<tr>
				<img src="img/imagingunion.png" style="height: 40px;">
			</tr>
			<br> <br>
			<tr>
			<div class="weui_dialog_hd"><strong style="color:red" class="weui_dialog_title">手机报告申请总额：<%=totalmoney%>元</strong></div>
			<%-- <label style="color:red">手机报告申请总额：(<%=totalmoney%>)元</label> --%>
			</tr>
			<tr></tr>
			<!-- <tr>
            <label >单张报告缴费1元，自动将检查报告和检查图像发送到您的手机！</label>
			</tr> -->
			<tr></tr>
			<tr>
				<input type="button"
					class="weui_btn weui_btn_disabled weui_btn_warn" value="确认支付"
					onclick="callpay()"/>
			</tr>
		</div>
		<h4 class="page-title">欢迎使用影联网影像报告系统</h4>
	</div>
	
	<!-- <div style="text-align:center;size:30px;"><input type="button" style="width:200px;height:80px;" value="确认支付" onclick="callpay()"></div> -->
<form name="Selectedforms" id="Selectedforms" action="wxPay" method="post">

</form>
</body>
<script type="text/javascript">
  	function callpay(){
		 WeixinJSBridge.invoke('getBrandWCPayRequest',{
  		 "appId" : "<%=appId%>","timeStamp" : "<%=timeStamp%>", "nonceStr" : "<%=nonceStr%>", "package" : "<%=packageValue%>","signType" : "MD5", "paySign" : "<%=paySign%>" 
   			},function(res){
				WeixinJSBridge.log(res.err_msg);
	            if(res.err_msg == "get_brand_wcpay_request:ok"){ 			
					document.Selectedforms.submit();
	                alert("微信支付成功!"); 
	               // window.location.href="wxpay.jsp"; 
	            }else if(res.err_msg == "get_brand_wcpay_request:cancel"){  
	                alert("用户取消支付!");  
	            }else{  
	               alert("支付失败!");  
	            }  
			})
		}
  </script>
</html>

