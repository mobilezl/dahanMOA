var DepartmentorderId = "";
var UserInfo ="";

document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		DepartmentorderId = eval("("+getParameters()+")");
			var url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID="+ UserInfo.UserId
			+"&accesc_Token="
			+UserInfo.accesc_Token
			+"&openId="
			+UserInfo.openId
			+"&departmentID="
			+ DepartmentorderId.DepartmentorderId;
			getJsonFormServer(url, onSuccess);
	} else if (Client == 2) {
		getUserInfo(getUserInfoCallback);
	}
}
function getUserInfoCallback(Info){
	UserInfo =eval("(" + Info + ")");
	getStorageParameters("DepartmentorderId",getParametersFromIOS);
	
}

function getParametersFromIOS(Parameters){
	DepartmentorderId = eval("(" + Parameters + ")");
	var url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID="+ UserInfo.UserId
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+"&departmentID="
	+ DepartmentorderId.DepartmentorderId;
	getJsonFormServer(url, onSuccess);
}
function onSuccess(data) {
	if(data.Result==0){
		if(data.ResultMsg.ErrCode=="-10001"){
			onMessage(data.ResultMsg.ErrMsg);
			setTimeout("logout()",1000);
		}else{
			onMessage("服务器请求错误");
		}
	}
	var li1 = "";
	var li2 = "";
	var li3 = "";
	if (data.SubDeptList != null && data.SubDeptList != "") {
		for ( var i = 0; i < data.SubDeptList.length; i++) {
			var Department = data.SubDeptList[i];
			if (Department.isSubDep > 0) {
				li1 = li1
						+ "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebViewToInner('通讯录','','DepartmentId','"+Department.DepartmentId+"','contact/www/Departmentorder.html','1');><a><img src='../images/Department.png' class='ui-li-icon'/>"
						+ Department.Department
						+ "</a></li>".toString();
			} else {
				li1 = li1 + "<li class='ui-nodisc-icon ui-alt-icon' ><a><img src='../images/Department.png' class='ui-li-icon'/>" + Department.Department + "</a></li>".toString();
			}

		}
	}
	if (data.EmpList != null && data.EmpList != "") {
		for ( var i = 0; i < data.EmpList.length; i++) {
			var User = data.EmpList[i];
			li2 = li2 + "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebViewToInner('联系人详情','','UserID','"+ User.UserID+"','contact/www/txldetail.html','1');><a><img src='../images/employee.png' class='ui-li-icon'/>" + User.UserName
					+ "<span style='float: right;'>" + User.Title
					+ "</span></a></li>".toString();
		}
	}

	if (data.ResultList != null) {
		for ( var i = 0; i < data.ResultList.length; i++) {
			var User = data.ResultList[i];
			li3 = li3 + "<li class='ui-nodisc-icon ui-alt-icon'   onclick=openWebViewToInner('联系人详情','','UserID','"+ User.UserID+"','contact/www/txldetail.html','1');><a><img src='../images/employee.png' class='ui-li-icon'/>" + User.UserName
					+ "<span style='float: right;'>" + User.Title
					+ "</span></a></li>".toString();
		}
	}
	var ul = "<ul style='font-size: 18px;' data-role='listview' >" + li1
			+ li2 + li3 + "</ul>";
	$("#list").html(ul);
	$("div#list").trigger('create');
}

//function openUser(url, val) {
//	sessionStorage.setItem("userCode", val);
//	window.location.href = url;
//}
//function openDepartment(url, val) {
//	sessionStorage.setItem("DepartmentOrderId", val);
//	window.location.href = url;
//}
function Search() {
	var url = "";
	var SearchName = $("#search").val()
	if (SearchName == null || SearchName == "") {
		url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID="+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId
		+"&departmentID="
		+ DepartmentorderId.DepartmentorderId;
	} else {
		if (!isNaN(SearchName)) {
			url = UrlRoot+"ContactsService.ashx?Action=SearchContactsByKey&userID="+ UserInfo.UserId+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId+"&key=Ext2*"
					+ SearchName;
		} else if ((/[\u4e00-\u9fa5]+/).test(SearchName)) {
			url = UrlRoot+"ContactsService.ashx?Action=SearchContactsByKey&userID="+ UserInfo.UserId+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId+"&key=userName*"
					+ SearchName;
		} else if ((/[a-z]|[A-Z]+/).test(SearchName)) {
			url = UrlRoot+"ContactsService.ashx?Action=SearchContactsByKey&userID="+ UserInfo.UserId+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId+"&key=userId*"
					+ SearchName;
		}
	}
	getJsonFormServer(url, onSuccess);
}
