
var UserInfo ="";	 
var ReportId =""; 
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		ReportId = eval("("+getParameters()+")");
		var url = UrlRoot+"ReportService.ashx?Action=GetReportByTypeId&userID="
		+ UserInfo.UserId
		+ "&authorizeCode="
		+ UserInfo.AuthorizeCode
		+ "&reportTypeId="
		+ ReportId.ReportId;
		getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
	}
}
function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	getStorageParameters("ReportId",getParametersFromIOS);
	
}

function getParametersFromIOS(Parameters){
	ReportId = eval("(" + Parameters + ")");
	var url = UrlRoot+"ReportService.ashx?Action=GetReportByTypeId&userID="
	+ UserInfo.UserId
	+ "&authorizeCode="
	+ UserInfo.AuthorizeCode
	+ "&reportTypeId="
	+ ReportId.ReportId;
	getJsonFormServer(url, onSuccess);
}
function onSuccess(data){
	var js ="";
	for(var i =0;i< data.ReportList.length;i++){
		js = data.ReportList[i].XmlFile;
	}
	$("#list").append(js);
}
