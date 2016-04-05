//请求域名
var UrlRoot = "http://dahanis.eicp.net:25084/";
//var UrlRoot = "http://m.dahanis.com:8000/";

//客户端识别： 1：Android  2：IOS  3.浏览器
 document.addEventListener("deviceready", onDeviceReady, false);
var Client= "";
function onDeviceReady() {
			if (browser.versions.android) {
				javaobj.pageFinished();
				Client= "1";
			}else if (browser.versions.ios) {
				Client= "2";
			}else{
				Client= "3";
			}
		}

////获取用户信息android
function getAndroidUserInfo(){
		return javaobj.getUserInfo();
}
////获取用户信息ios
function getUserInfo(_callback){
	MyIOSPlugin.nativeFunction("UserInfoPlugin","getUserInfo",[ ],_callback,_callback);

}



//调用IOS方法插件
var MyIOSPlugin = {
    /**
     * 调用IOS方法
     * @param method 要调用IOS插件的方法名
     * @param parameter 参数[数组]
     * @param success 成功回调
     * @param fail 失败回调
     * @returns {*}
     */
nativeFunction: function(PluginName,method, parameter, success, fail) {
    return Cordova.exec(success, fail, PluginName, method, parameter);
}
};


//退出登录
function logout(){
	if(Client==1){
		javaobj.logout();
	}else if(Client==2){
		MyIOSPlugin.nativeFunction("LogoutPlugins","logoutApp",[],callback,callback);
	}
}

//关闭窗口
function finishWebView(){
	if(Client==1){
		javaobj.finishWebView();
	}else if(Client==2){
		MyIOSPlugin.nativeFunction("GoBackFromJSPlugin","goBackFromJS",[],callback,callback);
	}
}

//打开新窗口并传递参数
function openView(url, key, val) {
	if(Client==1){
		javaobj.bindParametersToNextPage("{'"+key+"':'"+val+"'}");
	}
	window.location.href = url;
}
//带右按钮
function openWebViewBtn(appName,AppKey,key,val,url,isTitle,btnText,url2,key2,val2,showTitleBar,appName){
	if(Client==1){
	var btn = "{'btnText':'"+btnText+"','url':'"+url2+"','"+key2+"':'"+val2+"','showTitleBar':'"+showTitleBar+"','operations':'','appName':'"+appName+"'}";
		javaobj.createNewPage(appName,AppKey,"{'"+key+"':'"+val+"'}",url,isTitle,btn);
	}else if(Client==2){
		setIOSTitle(appName);
		setStorageParameters(key,"{'"+key+"':'"+val+"'}");
		var i =url.indexOf('/');
		url = url.substring(i+1);
		window.location.href = url;
	}	
}
//默认
function openWebView(appName,AppKey,key,val,url,isTitle){
	if(Client==1){
		javaobj.createNewPage(appName,AppKey,"{'"+key+"':'"+val+"'}",url,isTitle,"");
	}else if(Client==2){
		setIOSTitle(appName);
		setStorageParameters(key,"{'"+key+"':'"+val+"'}");
		var i =url.indexOf('/');
		url = url.substring(i+1);
		window.location.href = url;
	}		
}
//默认(针对IOS平级页面)
function openWebViewToInner(appName,AppKey,key,val,url,isTitle){
	
	if(Client==1){
		javaobj.createNewPage(appName,AppKey,"{'"+key+"':'"+val+"'}",url,isTitle,"");
	}else if(Client==2){
		setIOSTitle(appName);
		setStorageParameters(key,"{'"+key+"':'"+val+"'}");
		var str =url.split('/');
		url = str[2].toString();
		window.location.href = url;
	}		
}
//多参数
function openWebViewParamToInner(appName,AppKey,parameters,url,isTitle,key){
	if(Client==1){
		javaobj.createNewPage(appName,AppKey,parameters,url,isTitle,"");
	}else if(Client==2){
		setIOSTitle(appName);
		setStorageParameters(key,parameters);
		var str =url.split('/');
		url = str[2].toString();
		window.location.href = url;
	}		
}
//多参数
function openWebViewParam(appName,AppKey,parameters,url,isTitle,key){
	if(Client==1){
		javaobj.createNewPage(appName,AppKey,parameters,url,isTitle,"");
	}else if(Client==2){
		setIOSTitle(appName);
		setStorageParameters(key,parameters);
		var i =url.indexOf('/');
		url = url.substring(i+1);
		window.location.href = url;
	}		
}
//获取参数
function getParameters(){
	if(Client==1){
		return javaobj.getParametersFromPrevious();
	}
}

//消息提示
function onMessage(str){
	if (Client==1) {
		javaobj.showMsg(str);
	}else if (Client==2){
		MyIOSPlugin.nativeFunction("ShowMsgFromJSPlugin","showMsgFromJS",[str],callback,callback);
	}else{
	 $.mobile.loading( "show",{
		 text: "Loader",
		 textVisible: true,
		 theme: "b",
		 textonly: true,
		 html: "<span class='ui-bar ui-shadow ui-overlay-d ui-corner-all'><h2>"+str+"</h2></span>"});
		 setTimeout("$.mobile.loading('hide')",2000);
	}
}


function setStorageParameters(key,val){
	MyIOSPlugin.nativeFunction("StorageParametersForJSPlugin","storageParametersForJS",[key,val],callback,callback);
}
function getStorageParameters(key,_callback){
	MyIOSPlugin.nativeFunction("GetParametersFromIOSPlugin","getParametersFromIOS",[key],_callback,_callback);
}
//插件类名： GetAppKeyPlugin
//接口名：getAppKey
//返回值：AppKey/String
function getAppkey(_callback){
	MyIOSPlugin.nativeFunction("GetAppKeyPlugin","getAppKey",[ ],_callback,_callback);
	
}
//设置IOS应用标题（标题）
function setIOSTitle(title){
	MyIOSPlugin.nativeFunction("SetNavTitleByWebTitlePlugin","setNavTitleByWebTitle",[title],callback,callback);
}
function callback(agrs){}
//拨打电话（电话号码）
function callPhone(callNum){
	if(Client==1){
		javaobj.call(callNum);
	}else if(Client==2){
		MyIOSPlugin.nativeFunction("CallPhonePlugin","callPhone",[callNum],callback,callback);
	}
}
//发送短信（电话号码）
function sendMsg(sendNum){
if(Client==1){
	javaobj.SendMessage(sendNum);
	}else if(Client==2){
	MyIOSPlugin.nativeFunction("SendMsgPlugin","sendMsg",[sendNum],callback,callback);
	}
}
//打开附件
function openFile(fileUrl){
	if(Client==1){
		javaobj.downloadFileAndOpen(fileUrl);
	}else if(Client==2){
		MyIOSPlugin.nativeFunction("PreviewDocPlugin","previewDoc",[fileUrl],callback,callback);
	}
}

//发邮件
function sendEmail(){
	javaobj.sendEmail('主题','sss@qq.com,aaa@qq.com','内容');
}
//json请求方法
function getJsonFormServer(urlstr, onLoadServerDataSuccess) {
	var type = "POST";
	var async = true;
	var dataType = "json";
	var timeout = 20000;
	var data = "";
	var url = "";
	if (urlstr.substring(0, 4) != 'http') {
		url = site_url + urlstr;
	} else {
		url = urlstr;
	}
	
	
	$.ajax({
		type : type,
		url : url,
		async : async,
		dataType : dataType,
		timeout : timeout,
		data : data,
		success : function(data, statu) {
			onLoadServerDataSuccess(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
//			$("#list").html("服务器忙,请稍后进入...");
			onMessage("请检查网络连接是否正常");
			
		}
	});
}
//客户端识别方法
var browser={    
		versions:function(){            
			var u = navigator.userAgent, app = navigator.appVersion;            
			return{                trident: u.indexOf('Trident')>-1,//IE内核              
				presto: u.indexOf('Presto')>-1,//opera内核               
				webKit: u.indexOf('AppleWebKit')>-1,//苹果、谷歌内核               
				gecko: u.indexOf('Gecko')>-1&& u.indexOf('KHTML')==-1,//火狐内核               
				mobile:!!u.match(/AppleWebKit.*Mobile.*/)||!!u.match(/AppleWebKit/),//是否为移动终端                
				ios:!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),//ios终端                
				android: u.indexOf('Android')>-1|| u.indexOf('Linux')>-1,//android终端或者uc浏览器                
				iPhone: u.indexOf('iPhone')>-1|| u.indexOf('Mac')>-1,//是否为iPhone或者QQHD浏览器                
				iPad: u.indexOf('iPad')>-1,//是否iPad                
				webApp: u.indexOf('Safari')==-1//是否web应该程序，没有头部与底部           
				};}()}
//document.writeln(" 是否为移动终端: "+browser.versions.mobile);
//document.writeln(" ios终端: "+browser.versions.ios);
//document.writeln(" android终端: "+browser.versions.android);
//document.writeln(" 是否为iPhone: "+browser.versions.iPhone);
//document.writeln(" 是否iPad: "+browser.versions.iPad);
//document.writeln(navigator.userAgent);