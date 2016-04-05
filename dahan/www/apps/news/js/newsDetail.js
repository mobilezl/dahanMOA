var UserInfo = "";
var newsId ="";
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		var AppKey = javaobj.getAppKey();
		 newsId = eval("(" + getParameters() + ")");
		if (AppKey != null && AppKey != "") {
			var url = UrlRoot
					+ "NewsService.ashx?Action=GetNewsDetailInfo&userID="
					+ UserInfo.UserId + "&authorizeCode="
					+ UserInfo.AuthorizeCode 	
					+"&accesc_Token="
					+UserInfo.accesc_Token
					+"&openId="
					+UserInfo.openId
					+ "&newsId=" + AppKey;
		} else {
			url = UrlRoot + "NewsService.ashx?Action=GetNewsDetailInfo&userID="
					+ UserInfo.UserId + "&authorizeCode="
					+ UserInfo.AuthorizeCode 
					+"&accesc_Token="
					+UserInfo.accesc_Token
					+"&openId="
					+UserInfo.openId
					+ "&newsId=" + newsId.NewsId;
		}
		getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
		
	}
}

function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	getStorageParameters("NewsId",getParametersFromIOS);
	getAppkey(getAppkeyCallback);
}
var Nid="";
function getParametersFromIOS(Parameters){
	newsId = eval("(" + Parameters + ")");
	
	if(newsId.NewsId != null && newsId.NewsId != ""){
		Nid= newsId.NewsId;
	}
}
function getAppkeyCallback(key){
if(Nid != null && Nid != ""){
	var url = UrlRoot
	+ "NewsService.ashx?Action=GetNewsDetailInfo&userID="
	+ UserInfo.UserId + "&authorizeCode="
	+ UserInfo.AuthorizeCode 
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+ "&newsId=" + Nid;
	getJsonFormServer(url, onSuccess);
}else{
	var url = UrlRoot
	+ "NewsService.ashx?Action=GetNewsDetailInfo&userID="
	+ UserInfo.UserId + "&authorizeCode="
	+ UserInfo.AuthorizeCode 
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+ "&newsId=" + key;
	getJsonFormServer(url, onSuccess);
}
}


//$(function(){
//	var url = UrlRoot
//	+ "NewsService.ashx?Action=GetNewsDetailInfo&userID="
//	+ "zhongliang"+ "&authorizeCode="
//	+ "1"+ "&newsId=6" ;
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
	var newsDete = "";
	var rst = data.NewsDetailInfo;
	var content = rst.Content.replace(/<img /g,
			"<img width='100%' height='40%' ");
	newsDete = "<span style='float: left;font-size: 16px; font-weight: bold;'>"
			+ rst.Title + "</span><br>"
			+ "<span  style='float: left;font-size: 12px;'>" +  ChangeDateFormat(rst.PubTime) 
			+ "</span><span style='float: right;font-size: 12px;'>" +rst.Puber
			+ "</span><br>" + content;
	$("#list").append(newsDete);
	$("div#list").trigger('create');
}

function ChangeDateFormat(jsondate) {
jsondate = jsondate.replace("/Date(", "").replace(")/", "");
if (jsondate.indexOf("+") > 0) {
	jsondate = jsondate.substring(0, jsondate.indexOf("+"));
 }else if (jsondate.indexOf("-") > 0) {
	 jsondate = jsondate.substring(0, jsondate.indexOf("-"));
	 }
var date = new Date(parseInt(jsondate, 10));
var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
return date.getFullYear() + "-" + month + "-" + currentDate;
}