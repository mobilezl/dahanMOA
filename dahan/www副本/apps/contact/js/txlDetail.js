var userCode = "";
var UserInfo ="";

document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		userCode = eval("("+getParameters()+")");
		 var url =UrlRoot+"ContactsService.ashx?Action=GetContactsByUserId&userID="+
		 UserInfo.UserId+ "&authorizeCode="+
		 UserInfo.AuthorizeCode+"&userCode="
		 + userCode.UserID;
		getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
	}
}

function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	 getStorageParameters("UserID",getParametersFromIOS);
}

function getParametersFromIOS(Parameters){
	userCode = eval("(" + Parameters + ")");
	 var url =UrlRoot+"ContactsService.ashx?Action=GetContactsByUserId&userID="+
	 UserInfo.UserId+ "&authorizeCode="+
	 UserInfo.AuthorizeCode+"&userCode="
	 + userCode.UserID;
	getJsonFormServer(url, onSuccess);
}

//$(function (){
//	 
//	 var url =UrlRoot+"ContactsService.ashx?Action=GetContactsByUserId&userID=hushenyang&authorizeCode=111&userCode="
//	 + "maoyajun";
//	getJsonFormServer(url, onSuccess);
//});

function onSuccess(data) {
	var div = "<div><img src='"+data.ResultList[0].Icon+"' class='round_photo' /></div>"
			+ "<div style='margin-left: 35%;'><b style='font-size: 20px;'>"
			+ data.ResultList[0].UserName
			+ "</b><br><span style='font-size: 14px;'>"
			+ data.ResultList[0].Title
			+ "</span><br><span style='font-size: 14px;'>"
			+ data.ResultList[0].UserID
			+ "</span></div>"
			+ "<br><hr><div style='height: 45px;'><span style='color: #74B0FF;'>邮箱</span><br><span style='font-size:  17px; '>"
			+ data.ResultList[0].Email
			+ "</span></div>"
			+ "<hr><div style='height: 45px;'><span style='color: #74B0FF;'>IM</span><br><span style='font-size: 17px; '>"
			+ data.ResultList[0].IM
			+ "</span></div><hr><div style='height: 45px;'><span style='color: #74B0FF;'>移动电话</span><br><span style='font-size: 17px; '>"
			+ data.ResultList[0].Mobile
			+ "</span><span style='float: right; font-size: 32px; color: #0099cc;' class='icon-phone' onclick=callPhone('"
			+ data.ResultList[0].Mobile
			+ "')></span><span style='float: right; font-size: 32px; color: #0099cc;' class='icon-message'  onclick=sendMsg('"+data.ResultList[0].Mobile+"')></span></div>"
			+ "<hr><div style='height: 45px;'><span style='color: #74B0FF;'>办公室电话</span><br><span style='font-size:  17px; '>"
			+ data.ResultList[0].OfficeMobile
			+ "</span><span style='float: right; font-size: 32px; color: #0099cc;' class='icon-phone' onclick=callPhone('"
			+ data.ResultList[0].OfficeMobile + "')></span></div><hr>";
	if(data.ResultList[0].IsFrequent=="true"){
		$("#list").html(div);
		$("div#list").trigger('create');
	}else{
		var title = Trim(data.ResultList[0].Title,"g");
		var but ="<button id='btn' onclick=onSub('"+data.ResultList[0].UserName+"','"+title+"') style='color: white; background-color: #3795FF' type='button'>收藏为常用联系人</button>";
		$("#list").html(div+but);
		$("div#list").trigger('create');
	}
}
function onSub(ContactsName,Title){
	
	 var url =UrlRoot+"ContactsService.ashx?Action=SaveFrequentContacts&userID="+UserInfo.UserId+"&authorizeCode="+UserInfo.AuthorizeCode+"&ContactsId="+userCode.UserID+"&ContactsName="+ContactsName+"&ContactsTitle="+Title;
	 getJsonFormServer(url, onSubmitSuccess);
}
function onSubmitSuccess(data) {
	if (data.Result == "1") {
		onMessage("收藏成功");
		$("#btn").css("display","none");
} else {
		onMessage("收藏失败");
		window.location.reload();
}
}


function Trim(str,is_global)
{
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g,"");
    if(is_global.toLowerCase()=="g")
    {
        result = result.replace(/\s/g,"");
     }
    return result;
}