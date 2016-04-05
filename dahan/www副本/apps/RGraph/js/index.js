
var UserInfo ="";	 
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {	
	if (Client == 1) {
	getUserInfoCallback(getAndroidUserInfo());
} else if (Client == 2) {
	getUserInfo(getUserInfoCallback);
}
	}
function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	 var url = UrlRoot+"ReportService.ashx?Action=GetReportTypeList&userID="
		+ UserInfo.UserId
		+ "&authorizeCode="
		+ UserInfo.AuthorizeCode
		+ "&parentId=0";			
getJsonFormServer(url, onSuccess);		
	
}
function onSuccess(data){
	var icon = ["icon_caiwu.png","icon_gongcheng.png","icon_liucheng.png","icon_renshi.png","icon_yanfa.png","qita.png"];
	var div = "";
	for(var i =0;i< data.ReportTypeList.length;i++){
		if(icon.length>=data.ReportTypeList.length){
		if(i%2==0){
			div = div + "<div class='ui-block-a'><div class='icon-springboard' style='border: 1px solid #ccc; border-left: none;border-top: none;'>"
			+"<a onclick=openWebView('"+data.ReportTypeList[i].name+"','','typeId','"+data.ReportTypeList[i].id+"','RGraph/www/GraphList.html','1');>"
			+"<img src='images/"+icon[i]+"' width='90px' height='90px'>"  
			+"	<span class='icon-label' style='color: black;padding: 10px 0px;'>"+data.ReportTypeList[i].name+"</span></a></div></div>";
		}else{
			div = div + "<div class='ui-block-b' style='border-bottom: 1px solid #ccc;'><div class='icon-springboard'>"
			+"<a onclick=openWebView('"+data.ReportTypeList[i].name+"','','typeId','"+data.ReportTypeList[i].id+"','RGraph/www/GraphList.html','1');>"
			+"<img src='images/"+icon[i]+"' width='90px' height='90px'>"  
			+"	<span class='icon-label' style='color: black;padding: 10px 0px;'>"+data.ReportTypeList[i].name+"</span></a></div></div>";
		}
		}
		
	}
	
	var ls = "<div class='ui-grid-a'>"+div+"</div>";
	$("#list").html(ls);
	$("div#list").trigger('create');
}