<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="iu.requestReport.RequestReportBean" %>
<%@ page import="iu.requestReport.ReportRecord" %>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import= "java.text.SimpleDateFormat"%>
<%@ page import="iu.utils.AsyCryptography"%>
<%
	String path = request.getContextPath();
	String UID=request.getParameter("UID");
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	
	//String openid="oJNPFwB_bE0jV-fCtj_Cq98PEJWk";
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	} 
	List<RequestReportBean> list = new ReportRecord().getReportRecord(openid,UID);
	Iterator<RequestReportBean> it = list.iterator();
	RequestReportBean bean;
	SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    int i=0;
    AsyCryptography asy = new AsyCryptography();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>电子报告记录</title>
    <link rel="stylesheet" href="css/weui.css">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	 <link rel="stylesheet" type="text/css" href="css/style2.css" />
	<meta http-equiv="description" content="This is my page">
	<script src="js/jquery-2.1.4.min.js" type="text/javascript" charset="utf-8"></script>
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
  <body >
  <div class="page">
    <div class="hd">
        <h1 class="page_title">电子报告记录</h1>
    </div>
   </div>
    <%
    while(it.hasNext()){
    	
    	bean = it.next();
    	
    	String link = "http://wx.imagingunion.com" + "/MobilePhone/SendBrowseAddress.jsp?";
    	link += asy.getEncrypt(bean.getRelatedStudyUID());
    	link += "&imgFile=" + bean.getRelatedStudyUID().hashCode();
  
    	if(UID==null){
    	%>
     <a style="color:#0072E3"class="" href="UnitServicePrice.jsp?RELATEDSTUDYUID= <%=bean.getRelatedStudyUID()%> &REQUESTTIME=<%=bean.getRequestTime()%>">	
     <div class="weui_cells">
    	<!-- <div class="weui_cells_title">带说明、跳转的列表项</div> -->
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                	<p>登记号</p>
                    <p>医院</p>                   
                    <p>申请时间</p>
                    <p>是否处理</p>
                    <p>处理时间</p>
                </div>
                <div class="weui_cell_ft">
                	<p><%=bean.getAccessNumber() %></p>
	                <p><%=bean.getSourceUnit() %></p>	                
	                <p><%=sdf.format(format1.parse(bean.getRequestTime())) %></p>
	                <%if("已处理".equals(bean.getHasProcessed())){
	                 %>
	                	<p><i class="weui_icon_success_circle"></i></p>
	                <%}else{
	                %>
	               		<p><i class="weui_icon_cancel"></i></p>
	                <%
	                }
	                %>
	                <p><%=bean.getProcessedTime() %></p>
                </div>         
            </div>
        </div>
        </a>
        
        <div class="weui_cells weui_cell_ft">
        <a href="<%=link%>" class="weui_btn weui_btn_mini weui_btn_primary">查看图像</a>
        </div>
   <%  
   }else{
   	if("已处理".equals(bean.getHasProcessed())&&bean.getIsAvailable()){
   	  	i++;
     %>
     <div class="weui_cells">
    	<!-- <div class="weui_cells_title">带说明、跳转的列表项</div> -->
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                	<p>登记号</p>
                    <p>医院</p>                   
                    <p>申请时间</p>
                    <p>处理时间</p>
                    <p>关联到健康档案</p>
                </div>
                <div class="weui_cell_ft">
                	<p><%=bean.getAccessNumber() %></p>
	                <p><%=bean.getSourceUnit() %></p>	                
	                <p><%=sdf.format(format1.parse(bean.getRequestTime())) %></p>
	                <p><%=bean.getProcessedTime() %></p>
	                <p>
					<input type="checkbox" id=<%=bean.getAccessNumber() %> name="checkbox2" value=<%=bean.getRelatedStudyUID()%> class="regular-checkbox" /><label for=<%=bean.getAccessNumber() %>></label>
					</p>   
	            </div> 
	            
	                  
            </div>
        </div>
   <%
   }
  
   	}
   	}
    %>
    <% 
     if(!(UID==null)&&i!=0){
     System.out.print(i);
    %>
   	<div class="weui_btn_area">
		<input class="weui_btn weui_btn_primary" type="button" name="submit_p" id="submit_p" value="关联到健康档案"   onclick="Submit_Image('<%=UID%>','1')"/>
	</div>
	<% 
	}
	if(!(UID==null)&&i==0){%>
	<div class="page_title" >均已关联到该健康档案</div>

	<%
	}	
	 %>
  </body>
  <script>
  function Submit_Image(a,b){
  var Pic_uid = document.getElementsByName("checkbox2");
		var Pic_uids="";
		var count=0;
		for (var i = 0; i < Pic_uid.length; i++) {
			if (Pic_uid[i].checked) {
				Pic_uids += Pic_uid[i].value + "/";
				count++;
			}
		}
  		$.ajax({
					type : "post",
					url :"ArchiveImage",
					data : "PhrUID="+a+"&PicUID="+Pic_uids+"&flag="+1,
					success : function(data) {
						if (data==count){
							window.location.href="ShowPhr.jsp?UID="+a;
						}
					
					}
				});
  	
  
  }
  
  </script>
</html>
