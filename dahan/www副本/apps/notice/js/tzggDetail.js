var UserInfo="";
var NoticeId="";

document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		var url = "";
		var AppKey = javaobj.getAppKey();
		 NoticeId = eval("("+getParameters()+")");
		 if (AppKey != null && AppKey != "") {
		 url =UrlRoot+
		 "NoticesService.ashx?Action=GetNoticesDetailInfo&userID="
		 + UserInfo.UserId
		 + "&authorizeCode="
		 + UserInfo.AuthorizeCode
		 + "&NoticeId="
		 + AppKey;
		 } else {
		 url =UrlRoot+
		 "NoticesService.ashx?Action=GetNoticesDetailInfo&userID="
		 + UserInfo.UserId
		 + "&authorizeCode="
		 + UserInfo.AuthorizeCode
		 + "&NoticeId="
		 + NoticeId.NoticeId;
		 }
		 getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
	}
}
function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	getStorageParameters("NoticeId",getParametersFromIOS);
}
function getParametersFromIOS(Parameters){
	NoticeId = eval("(" + Parameters + ")");
	if(NoticeId.NoticeId != null && NoticeId.NoticeId != ""){
		var  url =UrlRoot+"NoticesService.ashx?Action=GetNoticesDetailInfo&userID="
		 + UserInfo.UserId
		 + "&authorizeCode="
		 + UserInfo.AuthorizeCode
		 + "&NoticeId="
		 + NoticeId.NoticeId;
		getJsonFormServer(url, onSuccess);
	}else{
		getAppkey(getAppkeyCallback);
	}
}
function getAppkeyCallback(key){
	var url = UrlRoot
	+ "NoticesService.ashx?Action=GetNoticesDetailInfo&userID="
	+ UserInfo.UserId + "&authorizeCode="
	+ UserInfo.AuthorizeCode + "&NoticeId=" + key;
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url = UrlRoot
//	+ "NoticesService.ashx?Action=GetNoticesDetailInfo&userID=zhongliang&authorizeCode=1&NoticeId=2";
//	getJsonFormServer(url, onSuccess);
//});

function onSuccess(data) {
	var content = "";
	var rst = data.NoticeDetailInfo;
	content = "<span style='float: left;font-size: 16px; font-weight: bold;'>"
			+ rst.Title + "</span><br>	"
			+ "<span  style='float: left;font-size: 12px;'>" +  rst.PubTime
			+ "</span><span style='float: right;font-size: 12px;'>" +rst.Puber+"</span><br><br>"
			+ rst.content;
	$("#list").html(content.toString());
	$("div#list").trigger('create');
}
