var UserInfo="";
var SN = "";
var ProcessAction = "";
var ProcessValue = "";
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
	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName="
	+ UserInfo.UserId
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+ "&startPage=1&pageCount=15";
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName=120020&authorizeCode=1392020295024&startPage=1&pageCount=15";
//	getJsonFormServer(url, onSuccess);
//});


//回调函数
function onSuccess(data) {
	if(data.Result==0){
		if(data.ResultMsg.ErrCode=="-10001"){
			onMessage(data.ResultMsg.ErrMsg);
			setTimeout("logout()",1000);
		}else{
			onMessage("服务器请求错误");
		}
	}
	if(data.WaitApprovalListList.length>=15){
		$("#load").show();
	}else{
		$("#load").hide();
	};
	var li = "";
	for (i = 0; i < data.WaitApprovalListList.length; i++) {
		var rst = data.WaitApprovalListList[i];
		//href='#popup'
		li = li + "<li data-icon='false' id='"+rst.ProcessSN+"' name='"+rst.processType+"' >" 
				+" <a id='a_"+rst.ProcessSN+"' href='#popup'   data-transition='slideup'>"
				+"<p><b style='font-size: 16px;'> "
				+ rst.ProcessName + "</b>" + "		</p> <span>" + rst.Submitter
				+ "</span><span id='span_"+rst.ProcessSN+"' style='color: #666; float: right;'>" + "		"
				+ rst.SubmitDate.substring(5,rst.SubmitDate.length) + "</span>" + "<br><br><p style='color: #999;'>"
				+ rst.Preview + "</p></a>"
				+"<div id='ck_"+rst.ProcessSN+"' style='margin-top:-86px; float:right; text-align: center;display: none;'>"
				+"<div  style='text-align: center; width: 150px;height: 86px;' data-mini='true' >"
				+"<div  style='text-align: center; background-color: #D84D4D;width: 75px;height: 86px;float:right;' data-mini='true'><div style='padding-top: 20px;color: white;' onclick=onClickProcess('"+rst.ProcessSN+"','Reject(拒绝)','6')><span  style='font-size: 24px;' class='icon-reject'></span><br>拒绝  </div> </div>"
				+"<div  style='text-align: center; background-color: #37C468;width: 75px;height: 86px;' data-mini='true'><div style='padding-top: 20px;color: white;' onclick=onClickProcess('"+rst.ProcessSN+"','Approve(同意)','0')><span  style='font-size: 24px;' class='icon-check'></span><br>同意  </div></div></div>"
				+"</div></li>".toString();
				
//				+"<div id='ck_"+rst.ProcessSN+"' style='margin-top:-85px; float:right; text-align: center;display: none;'>"
//				+"<button data-theme='b' style='text-align: center; background-color: #37C468;' data-mini='true' onclick=onClickProcess('"+rst.ProcessSN+"','Approve(同意)','0') ><span style='font-size: 20px;' class='icon-check'>同意</span>  </button>"
//				+"<button data-theme='a' style='text-align: center; background-color: #D84D4D;' data-mini='true'onclick=onClickProcess('"+rst.ProcessSN+"','Reject(拒绝)','6')><span style='font-size: 20px;' class='icon-reject'>拒绝</span>  </button></div></li>".toString();
	}
	var ul = "<ul data-theme='c' data-corners='true' data-role='listview' style='font-size: 12px;margin-top: -11px;' id='swipeMe' data-inset='true'>" + li
			+ "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}
function onClickProcess(ProcessSN,ApprovalAction,ApprovalActionValue){
		var url = UrlRoot
		+ "WorkflowService.ashx?Action=ActionProcess&loginName="
		+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId
		+ "&processSN="
		+ ProcessSN + "&approvalAction="+ApprovalAction+"&ApprovalActionValue="+ApprovalActionValue+"&approvalComment=";
		getJsonFormServer(url, onProcess);
		$("#"+ProcessSN).remove();
}

function onPageTwoContent(data){
	if(data.Result==0){
		if(data.ResultMsg.ErrCode=="-10001"){
			onMessage(data.ResultMsg.ErrMsg);
			setTimeout("logout()",1000);
		}else{
			onMessage("服务器请求错误");
		}
	}
	var input ="";
	for (i = 0; i < data.WaitApprovalListList.length; i++) {
		var rst = data.WaitApprovalListList[i];
	input= input+"<input type='checkbox'  name='checkbox' id='checkbox-t-"+i+"a' value='"+rst.ProcessSN+"' >"
    +"<label for='checkbox-t-"+i+"a' style='font-size: 12px;'>"
    +" <p><b style='font-size: 16px;'> "+ rst.ProcessName +"</b></p> <span>"+rst.Submitter+"</span>"
	+"<span style='color: #666; float: right;'>"
	+rst.SubmitDate +"</span><p style='color: #999;'>"
	+ rst.Preview +"</p> </label>";
	
	}
	var fieldset = " <fieldset data-role='controlgroup'  data-iconpos='left' >"+input+"</fieldset>";
	$("#content").append(fieldset);
$("div#content").trigger('create');
}
var next = 2;
function loadMore() {
	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName="
	+ UserInfo.UserId
	+"&accesc_Token="
	+UserInfo.accesc_Token
	+"&openId="
	+UserInfo.openId
	+ "&startPage="+next+"&pageCount=15";
	next++;
	getJsonFormServer(url, onSuccess);
}
//进入详情
	$('#swipeMe li').live('click',function(){ 
		var Id = $(this).attr("id");
		SN = Id;
		var processType = $(this).attr("name");
		var url = UrlRoot
		+ "WorkflowService.ashx?Action=GetProcessInfo&loginName="
		+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId
		+ "&ProcessSN="
		+ Id +"&processType="+processType;
		
//		var url = UrlRoot
//		+ "WorkflowService.ashx?Action=GetProcessInfo&loginName="
//		+ "120020"
//		+"&accesc_Token="
//		+"1"
//		+"&openId="
//		+"1"
//		+ "&ProcessSN="
//		+ Id +"&processType="+processType;
		getJsonFormServer(url, onDetailSuccess);
	}); 
	
	function onDetailSuccess(data){
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		var detailInfo = "<p>发起人："+data.ProcessBaseInfo[0].Submitter+"</p>"
		+"<p><span>"+data.ProcessBaseInfo[0].SubmitDate+"</span></p><hr>"+data.ProcessContentList;
		var textarea =  "<textarea cols='50' rows='7' id='Processtext' onKeyDown='textdown(event)'"
		+"onKeyUp='textup()' onfocus=if(value=='您的审批意见'){value=''} onblur=if (value ==''){value='您的审批意见'}>您的审批意见</textarea>";
		var btn = "";
		for (j = 0; j < data.ProcessDetailList.length; j++) {
			var rst = data.ProcessDetailList[j];
			btn = btn +" <li><a onclick=openDetailInfo('"+rst.ProcessDetailID+"')  href='#popdiv' data-rel='popup'  data-role='button'>"+rst.ProcessDetailName+"</a></li>";
		}
		
		var controlgroup = "<div data-role='navbar' ><ul>"+btn+"</ul></div>";
		$("#detail").html(detailInfo+controlgroup+textarea);
		$("div#detail").trigger('create');
		
		var navbarSelect="";
		for (k = 0; k < data.ProcessActionList.length; k++) {
			var rst = data.ProcessActionList[k];
			
			if(rst.ActionValue!=0 && rst.ActionValue!=6){
				switch (rst.ActionValue) {
				case "1":
					navbarSelect =navbarSelect+"<li id='"+rst.ActionValue+"' name='"+rst.ActionName+"'><a href='#popupadd' data-transition='slideup'><img src='images/icon_add.png' width='20px' height='20px;'>"+rst.ActionName+"</a></li>";
					break;
				case "3":
					navbarSelect =navbarSelect+"<li id='"+rst.ActionValue+"' name='"+rst.ActionName+"'><a href='#popuprd' data-transition='slideup'><img src='images/icon_rd.png' width='20px' height='20px;'>"+rst.ActionName+"</a></li>";
					break;
				case "4":
					navbarSelect =navbarSelect+"<li id='"+rst.ActionValue+"' name='"+rst.ActionName+"'><a><img src='images/icon_return.png' width='20px' height='20px;'>"+rst.ActionName+"</a></li>";
					break;

				default:
					navbarSelect =navbarSelect+"<li id='"+rst.ActionValue+"' name='"+rst.ActionName+"'><a><img src='images/icon_more.png' width='20px' height='20px;'>"+rst.ActionName+"</a></li>";
					break;
				}
			}
		}
		var ul = "<div data-role='navbar'  ><ul id='bar'>"+navbarSelect+"</ul></div>";
		$("#navbarSelect").html(ul);
		$("div#navbarSelect").trigger('create');
		$("#actionDiv").show();
	}
	
	
//明细
	function openDetailInfo(processDetailID){
		var url = UrlRoot+"WorkflowService.ashx?Action=GetProcessDetailInfo&loginName="
		+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId
		+ "&processDetailID="+processDetailID+"&ProcessSN="+ SN;
		getJsonFormServer(url, onDetailInfo);
	}
	function onDetailInfo(data){
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		$("#popdivs").html(data.DetailTableContent);
	}
	
	
	
	//审批
	$('#bar li').live('click',function(){ 
		var ActionValue = $(this).attr("id");
		var ActionName = $(this).attr("name");
		var content = $("#Processtext").val();
		if (content == "您的审批意见") {
			content = "";
		}
		if(ActionValue!=3 && ActionValue!= 1){
			var url = UrlRoot
			+ "WorkflowService.ashx?Action=ActionProcess&loginName="
			+ UserInfo.UserId
			+"&accesc_Token="
			+UserInfo.accesc_Token
			+"&openId="
			+UserInfo.openId
			+ "&processSN="
			+ SN + "&approvalAction="+ActionName+"&ApprovalActionValue="+ActionValue+"&approvalComment=" + content;
			getJsonFormServer(url, onProcess);
    		$("#popup").dialog("close");
    		$("#"+SN).remove();
		}else{
			ProcessAction=ActionName;
			ProcessValue = ActionValue;
		}
		
	}); 
	

//批量审批
function Process(agree, back) {
	var url = "";
	   var str="";
       $("input[name='checkbox']:checkbox").each(function(){ 
           if($(this).attr("checked")){
               str += $(this).val()+","
           }
       });
     
     var ProcessSN = str.split(",");
       if(ProcessSN==""){
    	   onMessage("请选择流程");
       }else{
    		if (agree != null && agree != "") {
    			url = UrlRoot
    					+ "WorkflowService.ashx?Action=BatchActionProcess&loginName="
    					+ UserInfo.UserId
    					+"&accesc_Token="
    					+UserInfo.accesc_Token
    					+"&openId="
    					+UserInfo.openId
    					+"&ProcessSNList="
    					+ ProcessSN + "&approvalAction=同意&approvalActionValue=0";
    		}else if (back != null && back != "") {
    			url = UrlRoot
					+ "WorkflowService.ashx?Action=BatchActionProcess&loginName="
					+ UserInfo.UserId
					+"&accesc_Token="
					+UserInfo.accesc_Token
					+"&openId="
					+UserInfo.openId
					+"&ProcessSNList="
					+ ProcessSN + "&approvalAction=拒绝&approvalActionValue=6";
    		}
       }
       getJsonFormServer(url, onProcess);
}
function textdown(e) {
    textevent = e;
    if (textevent.keyCode == 8) {
        return;
    }
    if (document.getElementById('textarea').value.length >= 200) {
        if (!document.all) {
            textevent.preventDefault();
        } else {
            textevent.returnValue = false;
        }
    }
}
function textup() {
    var s = document.getElementById('textarea').value;
    //判断ID为text的文本区域字数是否超过200个 
    if (s.length > 200) {
        document.getElementById('textarea').value = s.substring(0, 200);
    }
}


function showNavbar() {
	 $("#navbar").animate({
		 height:'toggle'
	    });
}
//切换至多选界面
$(document).on("pageinit", "#wrapper", function() {
	$("#list").on("taphold", function() {
		var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName="
		+ UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId
		+"&startPage=1&pageCount=15";
		getJsonFormServer(url, onPageTwoContent);
		window.location.href = "#pagetwo";
	});
});
var after ="";
	//滑动按钮
	$('#swipeMe li').live('swipeleft',function(){ 
		var Id = $(this).attr("id");
		if(after!=""){
			if( after== Id){
				//关闭当前
//				$("#span_"+after).show();
//				$("#ck_"+after).hide();
//				 $("#a_"+after).animate({
//					    width:'+=150px'
//					  });
//				after="";
				return;
			}else{
				//关闭上一条
			$("#span_"+after).toggle(50);
			$("#ck_"+after).animate({
			      width:'toggle'
			    });
			 $("#a_"+after).animate({
				    width:'+=150px'
				  });
			}

		}
		//默认打开
		 $("#a_"+Id).animate({
			    width:'-=150px'
			  });
		$("#span_"+Id).toggle(50);
		$("#ck_"+Id).animate({
		      width:'toggle'
		    });
		 after =Id;
	}); 
	
	//滑动按钮
	$('#swipeMe li').live('swiperight',function(){ 
		var Id = $(this).attr("id");
		
		if(after!=""){
			if( after== Id){
				//关闭当前
				$("#span_"+after).show();
				$("#ck_"+after).hide();
				 $("#a_"+after).animate({
					    width:'+=150px'
					  });
				after="";
				return;
			}else{
				//关闭上一条
			$("#span_"+after).toggle(50);
			$("#ck_"+after).animate({
			      width:'toggle'
			    });
			 $("#a_"+after).animate({
				    width:'+=150px'
				  });
			}
			after="";

		}
	});
	
//	-------------------------------------

	function radioSearch() {
		var url = UrlRoot;
		var SearchName = $("#search").val();

		if (SearchName == null || SearchName == "") {
			return;
		} else {
				url = UrlRoot+"WorkflowService.ashx?Action=SearchRedirectTosByKey&loginName="
				+ UserInfo.UserId
				+"&accesc_Token="
				+UserInfo.accesc_Token
				+"&openId="
				+UserInfo.openId
				+"&Key="+ SearchName;
		}
		getJsonFormServer(url, onradioSearchSuccess);
	}
	function onradioSearchSuccess(data) {
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		var input = "";
		if (data.ResultList != null && data.ResultList != "") {
			$("#Sendspk").show();
			for ( var i = 0; i < data.ResultList.length; i++) {
				var User = data.ResultList[i];
				input = input +"<input type='radio'  name='radio' id='checkbox-t-"+i+"a' value='"+User.UserID+"' >"
			    +"<label for='checkbox-t-"+i+"a' style='font-size: 12px;'>"
			    +"<span>"+User.UserName+"</span>"
				+"<span style='color: #666; float: right;'>"
				+User.DeptName +"</span></label>";
				
			}

			var fieldset = " <fieldset data-role='controlgroup'  data-iconpos='right' >"+input+"</fieldset>";
			$("#searchlist").html(fieldset);
			$("div#searchlist").trigger('create');
		}else{
			$("#search").val("");
			return;
		}
	}

	function radioSend(){
		var content = $("#txt").val();
		if (content == "您的审批意见") {
			content = "";
		}
		var radioValue ="";
		 $("input[name='radio']:radio").each(function(){ 
	           if($(this).attr("checked")){
	        	   radioValue = $(this).val();
	           }
	       });
	   
	     if(radioValue!=""){
				var url =  UrlRoot+"WorkflowService.ashx?Action=RedirectProcess&loginName="
				+ UserInfo.UserId
				+"&accesc_Token="
				+UserInfo.accesc_Token
				+"&openId="
				+UserInfo.openId
				+"&ProcessSN="+SN+"&RedirectAction="+ProcessAction+"&RedirectValue="+ProcessValue+"&RedirectComment="+content+"&RedirectTos="+radioValue;
				  getJsonFormServer(url, onProcess);
	    	 history.go(-2);
				  $("#"+SN).remove();
	     }else{
	    	 onMessage("请选择转签人"); 
	     }
	   
	}
	
	

	function ckSearch() {
		var url = UrlRoot;
		var SearchName = $("#cksearch").val();

		if (SearchName == null || SearchName == "") {
			return;
		} else {
				url = UrlRoot+"WorkflowService.ashx?Action=SearchRedirectTosByKey&loginName="
				+ UserInfo.UserId
				+"&accesc_Token="
				+UserInfo.accesc_Token
				+"&openId="
				+UserInfo.openId
				+"&Key="+ SearchName;
		}
		getJsonFormServer(url, onckSearchSuccess);
	}
	function onckSearchSuccess(data) {
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		var input = "";
		if (data.ResultList != null && data.ResultList != "") {
			$("#ckSendspk").show();
			for ( var i = 0; i < data.ResultList.length; i++) {
				var User = data.ResultList[i];
				input = input +"<input type='checkbox'  name='check' id='checkbox-t-"+i+"a' value='"+User.UserID+"' >"
			    +"<label for='checkbox-t-"+i+"a' style='font-size: 12px;'>"
			    +"<span>"+User.UserName+"</span>"
				+"<span style='color: #666; float: right;'>"
				+User.DeptName +"</span></label>";
				
			}

			var fieldset = " <fieldset data-role='controlgroup'  data-iconpos='right' >"+input+"</fieldset>";
			$("#cksearchlist").html(fieldset);
			$("div#cksearchlist").trigger('create');
		}else{
			$("#search").val("");
			return;
		}
	}

	function ckSend(){
		var content = $("#cktxt").val();
		if (content == "您的审批意见") {
			content = "";
		}
		var checkboxValue ="";
		 $("input[name='check']:checkbox").each(function(){ 
	           if($(this).attr("checked")){
	        	   checkboxValue += $(this).val()+","
	           }
	       });
		 var RedirectTos = checkboxValue.split(",");
	     if(RedirectTos!=""){
	    	  var url =  UrlRoot+"WorkflowService.ashx?Action=RedirectProcess&loginName="
	    	  	+ UserInfo.UserId
				+"&accesc_Token="
				+UserInfo.accesc_Token
				+"&openId="
				+UserInfo.openId
				+"&ProcessSN="+SN+"&RedirectAction="+ProcessAction+"&RedirectValue="+ProcessValue+"&RedirectComment="+content+"&RedirectTos="+RedirectTos;
	    	  getJsonFormServer(url, onProcess);
	    	  history.go(-2);
				$("#"+SN).remove();
	     }else{
	    	 onMessage("请选择加签人"); 
	     }
	}
	
	function onProcess(data) {
		if (data.Result == "1") {
				onMessage("处理成功");
//			   setTimeout("finishWebView()",1000);   
		} else {
				onMessage("处理失败");
//			   setTimeout("finishWebView()",1000);   
		}
	}
	