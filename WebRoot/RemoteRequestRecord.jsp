<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="iu.RemoteRequest.RemoteRequestRecord"%>
<%@ page import="iu.RemoteRequest.RemoteRequestRecordBean"%>
<%@ page import="iu.utils.AsyCryptography"%>
<%
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	//String openid = "oJNPFwGdjvBAobePcv9zoIZbDwWQ";
	List<RemoteRequestRecordBean> list = new RemoteRequestRecord().getRemoteRequestRecord(openid);
	Iterator<RemoteRequestRecordBean> it = list.iterator();
	RemoteRequestRecordBean bean;
	AsyCryptography asy = new AsyCryptography();
	String basePath = request.getScheme()+"://"+request.getServerName();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;  charset=utf-8">
<title>历史会诊记录</title>
<link rel="stylesheet" href="css/weui.css">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<style>
.page,body {
	background-color: #fbf9fe
}

.page_title {
	text-align: center;
	font-size: 34px;
	color: #3cc51f;
	font-weight: 400;
	margin: 0 15%
}
</style>
</head>

<body>
  <body >
  <div class="page">
    <div class="hd">
        <h1 class="page_title" style="color:#0072E3">会诊历史记录</h1>
    </div>
   </div>		

    <%
    while(it.hasNext()){
    	bean = it.next();
    	String studyUID = bean.getRelatedStudyUID();
    	String link = "http://wx.imagingunion.com" + "/MobilePhone/SendBrowseAddress.jsp?";
    	link += asy.getEncrypt(studyUID);
    	link += "&imgFile=" + studyUID.hashCode();
    	%>
    	 <div class="weui_cells">
    	 	<a href="<%=link%>">	
          		<div class="weui_cell">        		
	                <div class="weui_cell_bd weui_cell_primary">
	                    <p>会诊单位</p>
						<p>交易号</p>
						<p>申请时间</p>
						<p>交易时间</p>
						<p>交易状态</p>
	                </div>
	                <div class="weui_cell_ft">
		                <p><%=bean.getReqGroupName()%></p>
						<p><%=bean.getTransactionNumber() %></p>
						<p><%=bean.getRequestTime() %></p>
						<p><%=bean.getTransactionTime() %></p>
						<%if("1".equals(bean.getTransactionStatus())){
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
	                </div>
	            </div>
            </a>
         </div>
		<%  
		   }
		     %>  
        
</body>
</html>