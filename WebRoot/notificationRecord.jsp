<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="iu.notification.RequestNoticeBean" %>
<%@ page import="iu.notification.NotificationRecord" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	//openid="oJNPFwFInFohb4i8t-30VtXAk8wA";
	session.setAttribute("returnPage", "notification");
	List<RequestNoticeBean> list = new NotificationRecord().getNotificationRecord(openid);
	Iterator<RequestNoticeBean> it = list.iterator();
	RequestNoticeBean bean;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>申请通知记录</title>
    <link rel="stylesheet" href="css/weui.css">
    <link rel="stylesheet" type="text/css" href="css/style2.css" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script src="js/jquery-2.1.4.min.js" type="text/javascript"
	charset="utf-8"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
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
        <h1 class="page_title">申请通知记录</h1>
    </div>

    <%
    while(it.hasNext()){
        int i=0;
    	bean = it.next();
    	%>

	<div class="weui_cells">
		<!-- <div class="weui_cells_title">带说明、跳转的列表项</div> -->
		<div class="weui_cell">
			<div class="weui_cell_bd weui_cell_primary">
				<p>登记号</p>
				<p>医院</p>
				<p>申请时间</p>
				<p>是否处理</p>
				<p>处理时间</p>
				<p>选择获取报告</p>
			</div>
			<div class="weui_cell_ft ">
				<p><%=bean.getAccessNumber() %></p>
				<p><%=bean.getSourceUnit() %></p>
				<p><%=bean.getRequestTime() %></p>
				<%if("已处理".equals(bean.getHasProcessed())){
	                 %>
				<p>
					<i class="weui_icon_success_circle"></i>
				</p>
				<%}else{
	                %>
				<p>
					<i class="weui_icon_cancel"></i>
				</p>
				<%
	                }
	                %>
				<p><%=bean.getProcessedTime() %></p>
				<%if("1".equals(bean.getRequestImagConsult())){
	                 %>
				<p>
					已获取				
				</p>
				<%}else{
	                %>
				<p>
				<input type="checkbox" id=<%=i%> name="checkbox1" value=<%=bean.getNoticeReqUID()%> class="regular-checkbox" /><label for=<%=i%>></label>
				</p>
				<%
	                i++;
	                }
	                %>
				
			</div>

		</div>
	</div>
	<%  
   }
     %>    
<div class="btn-block">
  <input type="button"  class="weui_btn weui_btn_disabled weui_btn_warn" id="Paybutton" onclick="select2()" value="支付" />
</div>
<div class="weui_dialog_alert" id="dialog2" style="display: none;">
        <div class="weui_mask"></div>
        <div class="weui_dialog">
            <div class="weui_dialog_hd"><strong class="weui_dialog_title">错误</strong></div>
            <div class="weui_dialog_bd">请选择需要报告的通知记录！</div>
            <div class="weui_dialog_ft">
                <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
            </div>
        </div>
    </div>
<form id="payform" name="payform" action="RequestReportTopay"  method="post" >
<input type="text" id="hiddenprice" name="hiddenprice" value="" style="display:none;"><input type="text" id="hiddenreport" name="hiddenreport" value="" style="display:none;"><input type="text" id="openid" name="openid" value=<%=openid%> style="display:none;"><input type="text" id="accessNumber" name="accessNumber" value="" style="display:none;"></div>
</form>
  </body>
<script>

function select2(){
		var result = document.getElementsByName("checkbox1");
		var requestReport="";
		var price=0;
		for (var i = 0; i < result.length; i++) {
			if (result[i].checked) {
				requestReport += result[i].value + "/";
				price=price+1;
			}
		}
		$("#hiddenprice").val(price);
		$("#hiddenreport").val(requestReport);
		//$("#openid").val(openID);	
		if (requestReport !== "" && requestReport !== null) {
			document.payform.submit();
		} else {
			var $dialog = $('#dialog2');
	        $dialog.show();
	        $dialog.find('.weui_btn_dialog').one('click', function () {
	         $dialog.hide();
	         });  
		} 
	}

</script>
</html>
