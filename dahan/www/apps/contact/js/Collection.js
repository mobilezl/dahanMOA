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
	 var url =UrlRoot+"ContactsService.ashx?Action=GetFrequentContacts&userID="+
	 UserInfo.UserId+ "&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url =UrlRoot+"ContactsService.ashx?Action=GetFrequentContacts&userID=zhongliang&authorizeCode=111";
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
if(data.FrequentContacts.length<1){
	onMessage("您还没有收藏常用联系人！");
	return;
}
	var li ="";
	for ( var i = 0; i < data.FrequentContacts.length; i++) {
		var User = data.FrequentContacts[i];
	li = li+ "<li id='"+User.Id+"' data-swipeurl='#'  ><a onclick=openWebViewToInner('联系人详情','','UserID','"+ User.ContactsId+"','contact/www/txldetail.html','1');><img src='../images/employee.png' class='ui-li-icon'/>" + User.ContactsName
	+ "<span id='span_"+User.Id+"' style='float: right;'>" + User.ContactsTitle
	+ "</span></a>"
	+"<div id='ck_"+User.Id+"' style='margin-top:-43px; float:right; text-align: center;display: none;'>"
	+"<button data-theme='b' style='text-align: center; background-color: #37C468;' data-mini='true' onclick=onDelete('"+User.Id+"')>删除  </button>"
	+"</div></li>".toString();
	}
	var ul = "<ul data-icon='false' id='swipeMe' data-role='listview' style='font-size: 18px;' >" + li+ "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}


function onDelete(Id){
	var url =UrlRoot+"ContactsService.ashx?Action=DeleteFrequentContacts&userID="+UserInfo.UserId
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+"&id="+Id;
	getJsonFormServer(url, onDeleteSuccess);
}

//滑动按钮
$('#swipeMe li').live('swipe',function(){ 
	var Id = $(this).attr("id");
	$("#span_"+Id).toggle(50);
	 $("#ck_"+Id).animate({
	      width:'toggle'
	    });
}); 

function onDeleteSuccess(data) {
	if (data.Result == "1") {
		onMessage("删除成功");
		window.location.reload();
} else {
		onMessage("删除失败");
		window.location.reload();
}
}