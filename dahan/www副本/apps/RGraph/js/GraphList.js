
var UserInfo ="";	 
var typeId =""; 
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		typeId = eval("("+getParameters()+")");
		var url = UrlRoot+"ReportService.ashx?Action=GetReportTypeList&userID="
		+ UserInfo.UserId
		+ "&authorizeCode="
		+ UserInfo.AuthorizeCode
		+ "&parentId="
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
	+ "&authorizeCode="
	+ UserInfo.AuthorizeCode
	+ "&parentId="
	+ typeId.typeId;
	getJsonFormServer(url, onSuccess);
}

function onSuccess(data){
	var li ="";
	for(var i =0;i< data.ReportTypeList.length;i++){
		var rst = data.ReportTypeList[i];
		if(rst.id=="e395a882-8df8-4b49-834e-85a937412008"){
			li = li + "<li class='ui-nodisc-icon ui-alt-icon' onclick=openWebViewToInner('报表详情','','ReportId','" + rst.id
			+ "','RGraph/www/GraphDetail.html','1');><a><img  src='../images/0.png' 	 onerror="
			+ "javascript:this.src='../images/defualt.png';" + "  /><h2>"
			+ rst.name + "</h2></a></li>".toString();
		}else{
			li = li + "<li class='ui-nodisc-icon ui-alt-icon' onclick=openWebViewToInner('报表详情','','ReportId','" + rst.id
			+ "','RGraph/www/GraphDetail.html','1');><a><img  src='../images/0.png'  	 onerror="
			+ "javascript:this.src='../images/defualt.png';" + "  /><h2>"
			+ rst.name + "</h2></a></li>".toString();
		}
	}
	var ul = "<ul data-role='listview'>" + li + "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}