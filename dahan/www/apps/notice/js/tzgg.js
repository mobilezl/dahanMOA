var UserInfo = "";


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
	var url = UrlRoot + "NoticesService.ashx?Action=GetNoticesList&userID="
	+ UserInfo.UserId + "&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+ "&startPage=1&pageCount=15";
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url = UrlRoot + "NoticesService.ashx?Action=GetNoticesList&userID="
//	+ "zhongliang" + "&authorizeCode=" + "1"
//	+ "&startPage=1&pageCount=15";
//	getJsonFormServer(url, onSuccess);
//});
function onSuccess(data) {
	if(data.Result==0){
		if(data.ResultMsg.ErrCode=="-10001"){
			onMessage(data.ResultMsg.ErrMsg);
			setTimeout("logout()",1000);
		}else{
			onMessage("服务器请求错误");
		}
	}
	var li = "";
	if (data.NoticesList.length >=15) {
		$("#load").show();
	}else{
		$("#load").hide();
	}
	for (i = 0; i < data.NoticesList.length; i++) {
		var rst = data.NoticesList[i];
		var cnt = data.NoticesList[i].Summary.substring(0, 25) + "<wbr>"
				+ data.NoticesList[i].Summary.substring(25, 48);
		
	li = li + "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebView('通知详情','','NoticeId','" + rst.NoticeId
				+ "','notice/www/tzggDetail.html','1');><a><span style='font-size: 16px;font-weight: bold;'>" +rst.Title
				+ "</span></a></li>".toString();
	}
	var ul = "<ul data-role='listview' >" + li + "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}
// 加载更多
function loadMore() {
	var url = UrlRoot + "NoticesService.ashx?Action=GetNoticesList&userID="
			+ UserInfo.UserId + "&authorizeCode=" + UserInfo.AuthorizeCode
			+ "&startPage=1&pageCount=15";
	getJsonFormServer(url, onSuccess);
}