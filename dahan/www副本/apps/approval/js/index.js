var UserInfo="";
var UrlRoot = "http://dahanis.eicp.net:25084/";
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
	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName=120020&authorizeCode=1392020295024&startPage=1&pageCount=15";
	getJsonFormServer(url, onSuccess);
}

//$(function(){
//	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName=120020&authorizeCode=1392020295024&startPage=1&pageCount=15";
//	getJsonFormServer(url, onSuccess);
//});


//�ص�����
function onSuccess(data) {
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
				+" <a id='a_"+rst.ProcessSN+"' href='#popup'  data-transition='slideup'>"
				+"<p><b style='font-size: 16px;'> "
				+ rst.ProcessName + "</b>" + "		</p> <span>" + rst.Submitter
				+ "</span><span id='span_"+rst.ProcessSN+"' style='color: #666; float: right;'>" + "		"
				+ rst.SubmitDate.substring(5,rst.SubmitDate.length) + "</span>" + "<br><br><p style='color: #999;'>"
				+ rst.Preview + "</p></a>"
				+"<div id='ck_"+rst.ProcessSN+"' style='margin-top:-86px; float:right; text-align: center;display: none;'>"
				+"<div  style='text-align: center; width: 150px;height: 86px;' data-mini='true' >"
				+"<div  style='text-align: center; background-color: #D84D4D;width: 75px;height: 86px;float:right; border-top-right-radius: 5px;border-bottom-right-radius:5px;' data-mini='true'><div style='padding-top: 20px;color: white;' onclick=onClickProcess('"+rst.ProcessSN+"','Reject(�ܾ�)','6')><span  style='font-size: 24px;' class='icon-reject'></span><br>�ܾ�  </div> </div>"
				+"<div  style='text-align: center; background-color: #37C468;width: 75px;height: 86px;' data-mini='true'><div style='padding-top: 20px;color: white;' onclick=onClickProcess('"+rst.ProcessSN+"','Approve(ͬ��)','0')><span  style='font-size: 24px;' class='icon-check'></span><br>ͬ��  </div></div></div>"
				+"</div></li>".toString();
				
//				+"<div id='ck_"+rst.ProcessSN+"' style='margin-top:-85px; float:right; text-align: center;display: none;'>"
//				+"<button data-theme='b' style='text-align: center; background-color: #37C468;' data-mini='true' onclick=onClickProcess('"+rst.ProcessSN+"','Approve(ͬ��)','0') ><span style='font-size: 20px;' class='icon-check'>ͬ��</span>  </button>"
//				+"<button data-theme='a' style='text-align: center; background-color: #D84D4D;' data-mini='true'onclick=onClickProcess('"+rst.ProcessSN+"','Reject(�ܾ�)','6')><span style='font-size: 20px;' class='icon-reject'>�ܾ�</span>  </button></div></li>".toString();
	}
	var ul = "<ul data-theme='c' data-corners='true' data-role='listview' style='font-size: 12px;margin-top: -11px;' id='swipeMe' data-inset='true'>" + li
			+ "</ul>";
	$("#list").append(ul);
	$("div#list").trigger('create');
}
function onClickProcess(ProcessSN,ApprovalAction,ApprovalActionValue){
		var url = UrlRoot
		+ "WorkflowService.ashx?Action=ActionProcess&loginName=120020&authorizeCode=1392020295024&processSN="
		+ ProcessSN + "&approvalAction="+ApprovalAction+"&ApprovalActionValue="+ApprovalActionValue+"&approvalComment=";
		getJsonFormServer(url, onProcess);
		$("#"+ProcessSN).remove();
}

function onPageTwoContent(data){
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
	var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName=120020&authorizeCode=1392020295024&startPage="+next+"&pageCount=15";
	next++;
	getJsonFormServer(url, onSuccess);
}
//��������
	$('#swipeMe li').live('click',function(){ 
		var Id = $(this).attr("id");
		SN = Id;
		var processType = $(this).attr("name");
		var url = UrlRoot
		+ "WorkflowService.ashx?Action=GetProcessInfo&loginName=120020&authorizeCode=1392020295024&ProcessSN="
		+ Id +"&processType="+processType;
		getJsonFormServer(url, onDetailSuccess);
	}); 
	
	function onDetailSuccess(data){
		var detailInfo = "<p>�����ˣ�"+data.ProcessBaseInfo[0].Submitter+"</p>"
		+"<p><span>"+data.ProcessBaseInfo[0].SubmitDate+"</span></p><hr>"+data.ProcessContentList;
		var textarea =  "<textarea cols='50' rows='7' id='Processtext' onKeyDown='textdown(event)'"
		+"onKeyUp='textup()' onfocus=if(value=='�����������'){value=''} onblur=if (value ==''){value='�����������'}>�����������</textarea>";
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
	}
	
	
//��ϸ
	function openDetailInfo(processDetailID){
		var url = UrlRoot+"WorkflowService.ashx?Action=GetProcessDetailInfo&loginName=120020&authorizeCode=1392020295024&processDetailID="+processDetailID+"&ProcessSN="+ SN;
		getJsonFormServer(url, onDetailInfo);
	}
	function onDetailInfo(data){
		$("#popdivs").html(data.DetailTableContent);
	}
	
	
	
	//����
	$('#bar li').live('click',function(){ 
		var ActionValue = $(this).attr("id");
		var ActionName = $(this).attr("name");
		var content = $("#Processtext").val();
		if (content == "�����������") {
			content = "";
		}
		if(ActionValue!=3 && ActionValue!= 1){
			var url = UrlRoot
			+ "WorkflowService.ashx?Action=ActionProcess&loginName=120020&authorizeCode=1392020295024&processSN="
			+ SN + "&approvalAction="+ActionName+"&ApprovalActionValue="+ActionValue+"&approvalComment=" + content;
			getJsonFormServer(url, onProcess);
    		$("#popup").dialog("close");
    		$("#"+SN).remove();
		}else{
			ProcessAction=ActionName;
			ProcessValue = ActionValue;
		}
		
	}); 
	

//��������
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
    	   onMessage("��ѡ������");
       }else{
    		if (agree != null && agree != "") {
    			url = UrlRoot
    					+ "WorkflowService.ashx?Action=BatchActionProcess&loginName=120020&authorizeCode=1392020295024&ProcessSNList="
    					+ ProcessSN + "&approvalAction=ͬ��&approvalActionValue=0";
    		}else if (back != null && back != "") {
    			url = UrlRoot
					+ "WorkflowService.ashx?Action=BatchActionProcess&loginName=120020&authorizeCode=1392020295024&ProcessSNList="
					+ ProcessSN + "&approvalAction=�ܾ�&approvalActionValue=6";
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
    //�ж�IDΪtext���ı����������Ƿ񳬹�200�� 
    if (s.length > 200) {
        document.getElementById('textarea').value = s.substring(0, 200);
    }
}


function showNavbar() {
	 $("#navbar").animate({
		 height:'toggle'
	    });
}
//�л�����ѡ����
$(document).on("pageinit", "#wrapper", function() {
	$("#list").on("taphold", function() {
		var url = UrlRoot+"WorkflowService.ashx?Action=GetWaitApprovalList&loginName=120020&authorizeCode=1392020295024&startPage=1&pageCount=15";
		getJsonFormServer(url, onPageTwoContent);
		window.location.href = "#pagetwo";
	});
});
var after ="";
	//������ť
	$('#swipeMe li').live('swipe',function(){ 
		var Id = $(this).attr("id");
		if(after!=""){
			if( after== Id){
				//�رյ�ǰ
				$("#span_"+after).show();
				$("#ck_"+after).hide();
				 $("#a_"+after).animate({
					    width:'+=150px'
					  });
				after="";
				return;
			}else{
				//�ر���һ��
			$("#span_"+after).toggle(50);
			$("#ck_"+after).animate({
			      width:'toggle'
			    });
			 $("#a_"+after).animate({
				    width:'+=150px'
				  });
			}

		}
		//Ĭ�ϴ�
		 $("#a_"+Id).animate({
			    width:'-=150px'
			  });
		$("#span_"+Id).toggle(50);
		$("#ck_"+Id).animate({
		      width:'toggle'
		    });
		 after =Id;
	}); 
	
//	-------------------------------------

	function radioSearch() {
		var url = UrlRoot;
		var SearchName = $("#search").val();

		if (SearchName == null || SearchName == "") {
			return;
		} else {
				url = UrlRoot+"WorkflowService.ashx?Action=SearchRedirectTosByKey&loginName=zhongliang&authorizeCode=1392020295024&Key="
						+ SearchName;
		}
		getJsonFormServer(url, onradioSearchSuccess);
	}
	function onradioSearchSuccess(data) {
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
		if (content == "�����������") {
			content = "";
		}
		var radioValue ="";
		 $("input[name='radio']:radio").each(function(){ 
	           if($(this).attr("checked")){
	        	   radioValue = $(this).val();
	           }
	       });
	   
	     if(radioValue!=""){
				var url =  UrlRoot+"WorkflowService.ashx?Action=RedirectProcess&loginName=120020&authorizeCode=1392020295024&ProcessSN="+SN+"&RedirectAction="+ProcessAction+"&RedirectValue="+ProcessValue+"&RedirectComment="+content+"&RedirectTos="+radioValue;
				  getJsonFormServer(url, onProcess);
	    	 history.go(-2);
				  $("#"+SN).remove();
	     }else{
	    	 onMessage("��ѡ��תǩ��"); 
	     }
	   
	}
	
	

	function ckSearch() {
		var url = UrlRoot;
		var SearchName = $("#cksearch").val();

		if (SearchName == null || SearchName == "") {
			return;
		} else {
				url = UrlRoot+"WorkflowService.ashx?Action=SearchRedirectTosByKey&loginName=zhongliang&authorizeCode=1392020295024&Key="
						+ SearchName;
		}
		getJsonFormServer(url, onckSearchSuccess);
	}
	function onckSearchSuccess(data) {
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
		if (content == "�����������") {
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
	    	  var url =  UrlRoot+"WorkflowService.ashx?Action=RedirectProcess&loginName=120020&authorizeCode=1392020295024&ProcessSN="+SN+"&RedirectAction="+ProcessAction+"&RedirectValue="+ProcessValue+"&RedirectComment="+content+"&RedirectTos="+RedirectTos;
	    	  getJsonFormServer(url, onProcess);
	    	  history.go(-2);
				$("#"+SN).remove();
	     }else{
	    	 onMessage("��ѡ���ǩ��"); 
	     }
	}
	
	function onProcess(data) {
		if (data.Result == "1") {
				onMessage("����ɹ�");
//			   setTimeout("finishWebView()",1000);   
		} else {
				onMessage("����ʧ��");
//			   setTimeout("finishWebView()",1000);   
		}
	}
	