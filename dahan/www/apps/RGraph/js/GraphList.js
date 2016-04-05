var UrlRoot = "http://dahanis.eicp.net:25084/";
var UserInfo ="";	 
var typeId =""; 
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		typeId = eval("("+getParameters()+")");
		var url = UrlRoot+"ReportService.ashx?Action=GetReportTypeList&userID="
		+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId+"&parentId="
		+ typeId.typeId;
		getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
	}
}

function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	getStorageParameters("typeId",getParametersFromIOS);
	
}


function getParametersFromIOS(Parameters){
	typeId = eval("(" + Parameters + ")");
	var url = UrlRoot+"ReportService.ashx?Action=GetReportTypeList&userID="
	+ UserInfo.UserId
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId+"&parentId="
	+ typeId.typeId;
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url ="http://dahanis.eicp.net:25084/ReportService.ashx?Action=GetReportTypeList&userID=zhongliang&authorizeCode=1&parentId=e395a882-8df8-4b49-834e-85a885948271";
//	getJsonFormServer(url, onSuccess);
//});

function onSuccess(data){
	if(data.Result==0){
		if(data.ResultMsg.ErrCode=="-10001"){
			onMessage(data.ResultMsg.ErrMsg);
			setTimeout("logout()",1000);
		}else{
			onMessage("服务器请求错误");
		}
	}
	var li ="";
	for(var i =0;i< data.ReportTypeList.length;i++){
		var rst = data.ReportTypeList[i];
		if(rst.id=="e395a882-8df8-4b49-834e-85a937412008"){
			li = li + "<li class='ui-nodisc-icon ui-alt-icon' onclick=openWebViewToInner('报表详情','','ReportId','" + rst.id
			+ "','RGraph/www/GraphDetail.html','1');><a><img style='padding: 10px 10px 10px 7px; '  width='75' height='60'   src='../images/icon_qita.png'  	 onerror="
			+ "javascript:this.src='../images/defualt.png';" + "  /><h2>"
			+ rst.name + "</h2></a></li>".toString();
		}else{
			li = li + "<li class='ui-nodisc-icon ui-alt-icon' onclick=openWebViewToInner('报表详情','','ReportId','" + rst.id
			+ "','RGraph/www/GraphDetail.html','1');><a><img style='padding: 10px 10px 10px 7px; '  width='75' height='60'   src='../images/icon_qita.png'  	 onerror="
			+ "javascript:this.src='../images/defualt.png';" + "  /><h2>"
			+ rst.name + "</h2></a></li>".toString();
		}
	}
	var ul = "<ul data-role='listview'>" + li + "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}