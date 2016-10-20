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
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
<meta name="format-detection" content="telephone=no">
<script src="js/zepto.min.js"></script>
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


<%
//网页授权后获取传递的参数

	String url = request.getRequestURL().toString(); 
	Map<String, String> ret = new HashMap<String, String>();  
	ret = JsSignUtil.sign(url);
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
	    openid = (String) session.getAttribute("openid");
	} 
	session.setAttribute("returnPage", "Report");	
%>
</head>
<body>
<form name="Selectedforms" id="Selectedforms" action="RequestReportTopay" method="post">
			<div id="advenced-option">
				<div class="bd">
					<div class="weui_cells_title">请选择手机报告<input type="text" id="hiddenprice" name="hiddenprice" value="" style="display:none;"><input type="text" id="hiddenreport" name="hiddenreport" value="" style="display:none;"><input type="text" id="openid" name="openid" value="" style="display:none;"><input type="text" id="accessNumber" name="accessNumber" value="" style="display:none;"></div>	
<% // openid="oJNPFwFInFohb4i8t-30VtXAk8wA";
    DatabaseConnection dbc = null;
	Connection conn = null ;
	PreparedStatement ps = null ;
    dbc = new DatabaseConnection();
    conn = dbc.getConnection();
    String sql = "select NoticeReqUID,SourceUnit,AccessNumber,RequestTime from IU_RequestNotice where WxUserOpenID=?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, openid);
    ResultSet rs = ps.executeQuery();
    String NoticeReqUID="";
    String SourceUnit="";
    String AccessNumber="";
    String requestTime="";
    SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String study="";
    while (rs.next()) {
      NoticeReqUID=rs.getString("NoticeReqUID");
	  SourceUnit=rs.getString("SourceUnit");
	  AccessNumber=rs.getString("AccessNumber");
	  requestTime=rs.getString("RequestTime");
	  String sql1="select * from IU_RequestReport where WxUserOpenID = ? and SourceUnit=? and AccessNumber=?";
	  ps=conn.prepareStatement(sql1);
	  ps.setString(1, openid);
	  ps.setString(2, rs.getString("SourceUnit"));
	  ps.setString(3, rs.getString("AccessNumber"));
	  ResultSet rs1=ps.executeQuery();
	  if(!rs1.next()){
	  String RequestTime = sdf.format(format1.parse(requestTime));
%>
<div class="weui_cells weui_cells_checkbox" id="reportList">	
<div class="weui_cells">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>医院</p>
                </div>
                <div class="weui_cell_ft"><%=SourceUnit %></div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>登记号</p>
                </div>
                <div class="weui_cell_ft"><%=AccessNumber %></div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>时间</p>
                </div>
                <div class="weui_cell_ft"><%=requestTime %></div>
            </div>
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p>价格</p>
                </div>
                <div class="weui_cell_ft">1元</div>
            </div>
            <label class="weui_cell weui_check_label" for=<%=NoticeReqUID%>>
              
                <div class="weui_cell_bd weui_cell_primary">
                    <p>选择</p>
                </div>
                <div class="weui_cell_hd">
			<input type="checkbox" class="weui_check" name="checkbox1"
			id=<%=NoticeReqUID%> value=<%=NoticeReqUID%>> <i class="weui_icon_checked"></i>
		</div>
            </label>
        </div>
 </div>
	<%
		}}
	%>		
 </div>
 </div>

  <div class="hidden" id="scan-loading">
          <div id="loadingToast" class="weui_loading_toast">
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
              <p class="weui_toast_content">数据加载中</p>
            </div>
          </div>
        </div>
        <div class="hidden" id="scan-option">
          <div class="weui_cells">
              <div class="weui_cell">
                <div style="width: 100%;">
                  <p class="number" id="resultStr">对不起，找不到结果</p>
                </div>
              </div>
          </div>
          <!-- <div class="btn-block">
            <button class="weui_btn weui_btn_default">重新扫描</button>
            <p class="text-center"><a class="err" href="#">扫描的结果错误</a></p>
          </div> -->
          <div class="btn-block">
            <input type="button" class="weui_btn weui_btn_primary" onclick="getReport('<%=openid%>')" value="获取手机报告">
          </div>
          </div>
            <div id="scan-start">
          <div class="btn-block">
            <input type="button" class="weui_btn weui_btn_primary" id="scanQRCode1" value="扫一扫查询病例">
            
          </div>
  </div>
 <div class="btn-block" id="pay">
<input type="button"  class="weui_btn weui_btn_disabled weui_btn_warn" id="chooseWXPay" onclick="Selected('<%=openid%>')" value="支付" />
</div>
<div class="weui_dialog_alert" id="dialog2" style="display: none;">
        <div class="weui_mask"></div>
        <div class="weui_dialog">
            <div class="weui_dialog_hd"><strong class="weui_dialog_title">错误</strong></div>
            <div class="weui_dialog_bd">请选择手机报告！</div>
            <div class="weui_dialog_ft">
                <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
            </div>
        </div>
    </div>
</form>


</body>
<script type="text/javascript">
    var a;
	function Selected(a){
	    var openID=a;
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
		$("#openid").val(openID);	
		if (requestReport !== "" && requestReport !== null) {
			document.Selectedforms.submit();
		} else {
			var $dialog = $('#dialog2');
	        $dialog.show();
	        $dialog.find('.weui_btn_dialog').one('click', function () {
	         $dialog.hide();
	         });  
		}
	}
	var resultStr = null;
   wx.config({  
        debug: false,  
        appId: '<%=ret.get("appId")%>',  
        timestamp:'<%=ret.get("timestamp")%>',  
        nonceStr:'<%=ret.get("nonceStr")%>',  
        signature:'<%=ret.get("signature")%>',
		jsApiList : [ 'checkJsApi', 'scanQRCode' ]
	});//end_config  

	wx.ready(function() {
		document.querySelector('#scanQRCode1').onclick = function() {
			wx.scanQRCode({
				needResult : 1,
				desc : 'scanQRCode desc',
				success : function(res) {
					var obj = eval(res);
					resultStr = obj.resultStr;
					 var str= new Array(); 
				     try{
				     str=resultStr.split(",");
				     resultStr=str[1];
				     }catch(e){
				     }
				    var reg = /20\d{11}/;
					if(!reg.test(resultStr)){
						alert("请扫描正确的医院条形码！");
						return false;
					}  
					//$("#scan-start").addClass("hidden");
					$("#reportList").addClass("hidden");
					$("#pay").addClass("hidden");
					$("#scan-loading").removeClass("hidden");
					setTimeout(function() {
						$("#scan-loading").addClass("hidden");
						$("#scan-option").removeClass("hidden");
					}, 100);
					$("#resultStr").html("扫描结果：" + resultStr);
					
				}
			});
		};
		// 10 微信支付接口
		// 10.1 发起一个支付请求

	});
	wx.error(function(res) {
		alert(res.errMsg);
	});
	function getReport(a){
	     var openID=a;
	     $("#accessNumber").val(resultStr);
	     $("#hiddenprice").val("1");
	     $("#openid").val(openID);
	     $.ajax({
			type : 'post',
			url : 'VerifyReportPay',
			data : "openid="+openID+"&AccessNumber=" + resultStr,
			success : function(data) {
				if(data==0){
				document.Selectedforms.submit();
				}else if(data==1){
				alert("你已申请此手机报告，不能重复申请！")
				}else if(data==2){
				alert("未知错误！");
				}
			}
		});
	}
	</script>	
</html>