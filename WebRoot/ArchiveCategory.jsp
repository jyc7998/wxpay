<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
<title>修改模版</title>
<link rel="icon" type="image/png" href="images/favicon.png" />
<script src="js/jquery-2.1.4.min.js" type="text/javascript" charset="utf-8"></script>
<script src="js/JQueryzTree/js/jquery-migrate-1.2.1.js"></script>
<link rel="stylesheet" href="js/JQueryzTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="js/JQueryzTree/js/jquery.ztree.core-3.5.js"></script>

<style type="text/css">

</style>
<script language="JavaScript">
	$(document).ready(function() {
		showTemplate("HealthArchiveServlet");
	});
	
	function showTemplate(url){		
		var setting = {	
			async : {
				enable : true, 
				type: "post",
				url : url, 
				autoParam:["id", "name", "level"],
				otherParam: ["flag",'2'],
				dataFilter: ajaxDataFilter,
			},		
			// 回调函数  
			callback : {
				onClick : function(event, treeId, treeNode, clickFlag) {
				if(!treeNode.isParent){
					$.ajax({
							type : "post",
							url :"HealthArchiveServlet",
							data : "flag=" + 3+"&level="+treeNode.name,
							success : function(data) {
							window.location.href="ShowPhr.jsp?UID="+data;	
								}
						});
					
					}
				},
				onAsyncError : zTreeOnAsyncError,
			}
		};
		function ajaxDataFilter(treeId, parentNode, responseData) {
		if (responseData=="]") {
			alert("您还没有创建过档案，请先创建一份档案");
			window.location.href="HealthArchive.jsp";
		   /* responseData={"name":"没有数据"}; */
		}
		return responseData;
	};
		function zTreeOnAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
			alert("加载错误：" + XMLHttpRequest);
		};
		$.fn.zTree.init($("#templateTree"), setting);
	}
	$(window).bind('resize load', function(){
	$("body").css("zoom", $(window).width() / 240);
	$("body").css("display" , "block");
	});


</script>

</head>
<body>
	<div id="templateTree" class="ztree" style="width:200px;height:600px;overflow:auto"></div>
</body>
</html>
