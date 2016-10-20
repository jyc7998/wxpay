<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="iu.utils.JsSignUtil"%>
<%@ page import="iu.utils.WeixinUtil"%>
<%@ page import="iu.utils.CurrentHospital"%>
<%
	String url = request.getRequestURL().toString(); 
	Map<String, String> ret = new HashMap<String, String>();  
	ret = JsSignUtil.sign(url);
	String openid = (String) session.getAttribute("openid");
	if (openid == null) {
		// redirect to get openid
		WeixinUtil.requestOpenId(request, response);
		openid = (String) session.getAttribute("openid");
	}
	String hospitalName = new CurrentHospital().getHospitalName(openid);
	// String hospitalName = "安徽省中医院影像中心";
%>
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
    .btn-block {
      margin-top: 15px;
      padding: 0 15px;
    }
    .page-title {
      text-align: center;
      margin-left: auto; 
      margin-right: auto;
    }    .text-center {
      text-align: center;
    }
    .hidden {
      display: none !important;
    }
    .hd {
      margin-top: 15px;
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
  <body >
  <div id="top-start">
        <div class="hd">
          <div class="page-title">
            <img src="img/imagingunion.png" style="height: 40px;">
          </div>
         <!--  <h4 class="page-title">欢迎使用影联网影像报告系统</h4> -->
        </div>
        <div class="weui_cells_title">当前单位</div>
        <div class="weui_cells">
            <div class="weui_cell">
                <div class="weui_cell_bd weui_cell_primary">
                    <p style="color:#0000ff"><%=hospitalName %></p>
                    <p style="color:#888">(若当前单位和您所在单位不一致，请重新扫描医院二维码)</p>
                </div>
                <div class="weui_cell_ft"></div>
            </div>
        </div>
        <div id="scan-start">
          <div class="btn-block">
            <button class="weui_btn weui_btn_primary" id="scanQRCode1">扫一扫查询病例</button>
            <!-- <p class="text-center"><a class="que" href="#">找不到条形码编号？</a></p> -->
          </div>
          <div class="btn-block" id="remind" style="padding-right: 17px;">
            <img src="scanDemoPic?hospitalName=<%=hospitalName%>" class="img-thumbnail">
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
        <div class="weui_cells">
	    
        <div class="hidden" id="scan-option">
	        <div class="weui_cells_title">扫描结果</div>
	        <div class="weui_cells">
	            <div class="weui_cell">
	                <div class="weui_cell_bd weui_cell_primary" id="resultStr">                    
	                </div>
	            </div>
	        </div>
          <div class="btn-block">
          	<!-- <button class="weui_btn weui_btn_plain_default" onclick="reScanQRCode();">重新扫描</button> -->
            <button class="weui_btn weui_btn_primary" onclick="getReportNotification();">获取报告通知</button>
          </div>
        </div>
      </div>
  </div>

  </body>
  <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
	$("#scan-start").removeClass("hidden");
	$("#scan-option").addClass("hidden");
	var resultStr = null;
   	wx.config({  
        debug: false,  
        appId: '<%=ret.get("appId")%>',  
        timestamp:'<%=ret.get("timestamp")%>',  
        nonceStr:'<%=ret.get("nonceStr")%>',  
        signature:'<%=ret.get("signature")%>',
		jsApiList : [ 'checkJsApi', 'scanQRCode' ]
	});
	
	wx.ready(function() {
		document.querySelector('#scanQRCode1').onclick = function() {
			wx.scanQRCode({
				needResult : 1,
				desc : 'scanQRCode desc',
				success : function(res) {
					var obj = eval(res);
					resultStr = obj.resultStr;
					var reg = /20\d{11}/;
					if(!reg.test(resultStr)){
						alert("请扫描正确的医院条形码");
						return false;
					}
					if(resultStr.indexOf(",")>=0){
						resultStr = resultStr.split(",")[1];
					}
					$("#scan-start").addClass("hidden");
					$("#scan-loading").removeClass("hidden");
					setTimeout(function() {
						$("#scan-loading").addClass("hidden");
						$("#scan-option").removeClass("hidden");
					}, 100);
					$("#resultStr").html(resultStr);				
				}
			});
		};
	});
	wx.error(function(res) {
		alert(res.errMsg);
	});
	
	function getReportNotification(){
		$.ajax({
			type : 'post',
			url : 'notification/RequestNotification',
			data : "scanResult=" + resultStr,
			success : function(data) {
				if(data==1){
					window.location.href = "success.html";
				}if(data==2){
					alert("您已获取过该通知");
				}else{		
					alert("获取通知失败");
				}
			}
		});
	}
</script>
</html>
