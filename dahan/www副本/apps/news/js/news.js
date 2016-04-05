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
		 var url = UrlRoot+"NewsService.ashx?Action=GetNewsList&userID="
			+ UserInfo.UserId
			+ "&authorizeCode="
			+ UserInfo.AuthorizeCode
			+ "&startPage=1&pageCount=15";			
	getJsonFormServer(url, onSuccess);		
	}


//$(function(){
//	 var url = UrlRoot+"NewsService.ashx?Action=GetNewsList&userID="
//		+"zhongliang"
//		+ "&authorizeCode="
//		+"1"
//		+ "&startPage=1&pageCount=15";			
//getJsonFormServer(url, onSuccess);		
//	
//});

function onSuccess(data) {
	var li = "";
	if (data.NewsList.length >=15) {
		$("#load").show();
	}else{
		$("#load").hide();
	}
	for (i = 0; i < data.NewsList.length; i++) {
		var rst = data.NewsList[i];
		var cnt = data.NewsList[i].Summary.substring(0, 18) + "<wbr>"
				+ data.NewsList[i].Summary.substring(18, 35);
		li = li + "<li data-icon='false' onclick=openWebView('新闻详情','','NewsId','" + rst.NewsId
		+ "','news/www/newsDetail.html','1');><a><img style='padding: 10px 0px 10px 7px; ' src='"
		+ rst.Icon + "' width='75' height='100' onerror="
		+ "javascript:this.src='images/defualt.png';" + "  /><b>"
		+ rst.Title + "</b><p>" + cnt
		+ "...</p></a></li>".toString();
	}
	var ul = "<ul data-role='listview'>" + li + "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}
var next = 2;
function loadMore() {
	var url = UrlRoot+"NewsService.ashx?Action=GetNewsList&userID="
			+ UserInfo.UserId
			+ "&authorizeCode="
			+ UserInfo.AuthorizeCode
			+ "&startPage="+next+"&pageCount=15";
//	var url = UrlRoot+"NewsService.ashx?Action=GetNewsList&userID=zhongliang&startPage="+next+"&pageCount=5";
	next++;
	getJsonFormServer(url, onSuccess);
}

