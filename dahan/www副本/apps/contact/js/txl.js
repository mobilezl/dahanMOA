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
	var url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID="
	+ UserInfo.UserId
	+ "&authorizeCode="
	+ UserInfo.AuthorizeCode
	+ "&departmentID=00000000-0000-0000-0000-000000000000";
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID=zhongliang&authorizeCode=1&departmentID=A626C757-05B6-40A9-B6CB-4548B6DE95D2";
//	getJsonFormServer(url, onSuccess);	
//});

function onSuccess(data) {
	var li1 = "";
	var li2 = "";
	var li3 = "";
	if (data.SubDeptList != null && data.SubDeptList != "") {
		for ( var i = 0; i < data.SubDeptList.length; i++) {
			var Department = data.SubDeptList[i];

			li1 = li1 + "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebView('通讯录','','DepartmentId','"+Department.DepartmentId+"','contact/www/Department.html','1');> <a><img src='images/Department.png' class='ui-li-icon'/>" + Department.Department
					+ "</a></li>".toString();
		}
	}
	if (data.EmpList != null && data.EmpList != "") {
		for ( var i = 0; i < data.EmpList.length; i++) {
			var User = data.EmpList[i];
			
			li2 = li2 + "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebView('联系人详情','','UserID','"+ User.UserID+"','contact/www/txldetail.html','1');><a><img src='images/employee.png' class='ui-li-icon'/>" + User.UserName
			+ "<span style='float: right;'>" + User.Title
			+ "</span></a></li>".toString();
			
		}
	}

	if (data.ResultList != null && data.ResultList != "") {
		for ( var i = 0; i < data.ResultList.length; i++) {
			var User = data.ResultList[i];
			li3 = li3 + "<li class='ui-nodisc-icon ui-alt-icon'  onclick=openWebView('联系人详情','','UserID','"+ User.UserID+"','contact/www/txldetail.html','1');><a><img src='images/employee.png' class='ui-li-icon'/>" + User.UserName
					+ "<span style='float: right;'>" + User.Title
					+ "</span></a></li>".toString();
		}
	}
	var ul = "<ul style='font-size: 18px;' data-role='listview' >" + li1 + li2 + li3 + "</ul>";
	$("#list").html(ul);
	$("div#list").trigger('create');
}
function Search() {
	var url = "";
	var SearchName = $("#search").val();

	if (SearchName == null || SearchName == "") {
	 url = UrlRoot+"ContactsService.ashx?Action=GetDeptContactsByDeptId&userID="
		+ UserInfo.UserId
		+ "&authorizeCode="
		+ UserInfo.AuthorizeCode
		+ "&departmentID=A626C757-05B6-40A9-B6CB-4548B6DE95D2";
	} else {
		if (!isNaN(SearchName)) {
			url =UrlRoot+ "ContactsService.ashx?Action=SearchContactsByKey&userID="
					+ UserInfo.UserId
					+ "&authorizeCode="
					+ UserInfo.AuthorizeCode + "&key=Ext2*" + SearchName;
		} else if ((/[\u4e00-\u9fa5]+/).test(SearchName)) {
			url =UrlRoot+ "ContactsService.ashx?Action=SearchContactsByKey&userID="
					+ UserInfo.UserId
					+ "&authorizeCode="
					+ UserInfo.AuthorizeCode + "&key=userName*" + SearchName;
		} else if ((/[a-z]|[A-Z]+/).test(SearchName)) {
			url = UrlRoot+"ContactsService.ashx?Action=SearchContactsByKey&userID="
					+ UserInfo.UserId
					+ "&authorizeCode="
					+ UserInfo.AuthorizeCode + "&key=userId*" + SearchName;
		}
	}
	getJsonFormServer(url, onSuccess);
}
