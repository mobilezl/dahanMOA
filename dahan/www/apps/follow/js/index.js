var UserInfo ="";
var date = new Date();        
var nowD = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" +date.getDate();
var after = date.getFullYear() + "-" + (date.getMonth()-2 ) + "-" +28;

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
		var url = UrlRoot+"WorkflowService.ashx?Action=GetMyApplyProcess&loginName="
		+UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId+"&pageSize=15&pageIndex=1&startDateTime="+after+"&endDateTime="+nowD;
		getJsonFormServer(url, onSuccess);		
		
	}


//	$(function() {
//		var url = "http://dahanis.eicp.net:25084/WorkflowService.ashx?Action=GetMyApplyProcess&loginName=120037&pageSize=15&pageIndex=1&startDateTime="+after+"&endDateTime="+nowD;
//	getJsonFormServer(url, onSuccess);
//	});
	function onSuccess(data) {
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		if (data.MyApprovedProcess.length >= 15) {
			$("#load").show();
		} else {
			$("#load").hide();
		}
		var li = "";
		for ( var i = 0; i < data.MyApprovedProcess.length; i++) {
			var rst = data.MyApprovedProcess[i];
			var color = "";
			if(rst.WFStatus==2){
				color ="#FF8A00";
			}else if(rst.WFStatus==6){
				color="#37C468";
			}else if(rst.WFStatus==5){
				color="#D84D4D";
			}
			li = li
					+ "<li data-icon='false' name='"+rst.ProcessName+"' username='"+rst.ApplyUserName+"' id='"+rst.Subject+"' onclick=openAfter('"
					+ rst.ProcInstId
					+ "')>"
					+ "<a href='#popup2' data-transition='slideup' ><p><b style='font-size: 16px;'> "
					+ rst.ProcessName
					+ "</b>"
					+ "</p><span style='font-size: 12px;'>"
					+ rst.ApplyUserName
					+ "</span> "
					+ "<p style='color: #999;'><br>申请日期：" + ChangeDateFormat(rst.ProcInstStartTime)
					+ "</p></a>"
					+"<div style='margin-top:-70px; float:right; text-align: center;'>"
					+"<a href='#popup2' data-transition='slideup' data-theme='f' type='button'  style='background-color:"+color+";color: white;text-align: center; ' data-mini='true' >"+ rst.WFStatusDescription + "</a>"
					+"</div></li>".toString();
		}
		var ul = "<ul  data-role='listview' style='font-size: 12px;' id='listview'>"
				+ li + "</ul>";
		$("#list").append(ul);
		$("div#list").trigger('create');
	}
	var Subject ="";
	var ProcessName = "";
	var userName = "";
	$('#listview li').live('click',function(){
		 ProcessName = $(this).attr("name");
		 Subject = $(this).attr("id");
		 userName =$(this).attr("username");
	});
	function openAfter(procinstid) {
		var url = UrlRoot+"WorkflowService.ashx?Action=GetApprovalHistoryList&loginName="+UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId+"&procinstid="
				+ procinstid;
		getJsonFormServer(url, onAfterSuccess);
	}
	function onAfterSuccess(data) {
		if(data.Result==0){
			if(data.ResultMsg.ErrCode=="-10001"){
				onMessage(data.ResultMsg.ErrMsg);
				setTimeout("logout()",1000);
			}else{
				onMessage("服务器请求错误");
			}
		}
		$("#pname").html(ProcessName+" :  "+userName);
		$("#psb").html(Subject);
		var li ="";
		var len = data.ApprovalHistoryList.length
		for(var i =len;i>0;i--){
			var rst = data.ApprovalHistoryList[i-1];
			if(i==1){
				li = li+"<li  class='green'> <span>"+ChangeDateFormat(rst.ReceiveTime)+"</span><br> "
				+"<dl> <dt>"+rst.ApprovePositionTitle+"   "+rst.ApproveUserName+" </dt> 流程状态："+rst.ApproveActionName+"</dl> </li>";
			}else{
				li = li+"<li  > <span>"+ChangeDateFormat(rst.ReceiveTime)+"</span><br> "
			+"<dl> <dt>"+rst.ApprovePositionTitle+"   "+rst.ApproveUserName+" </dt> 流程状态："+rst.ApproveActionName+"</dl> </li>";
			}
		}
		$("#ls").html(li);
	}
	var next = 2;
	function loadMore() {
		var url = UrlRoot+"WorkflowService.ashx?Action=GetMyApplyProcess&loginName="+UserInfo.UserId
		+"&accesc_Token="
		+UserInfo.accesc_Token
		+"&openId="
		+UserInfo.openId+"&pageSize=15&pageIndex="
				+ next + "&startDateTime="+after+"&endDateTime="+nowD;
		next++;
		getJsonFormServer(url, onSuccess);
	}
	function ChangeDateFormat(jsondate) {
		jsondate = jsondate.replace("/Date(", "").replace(")/", "");
		if (jsondate.indexOf("+") > 0) {
			jsondate = jsondate.substring(0, jsondate.indexOf("+"));
		 }else if (jsondate.indexOf("-") > 0) {
			 jsondate = jsondate.substring(0, jsondate.indexOf("-"));
			 }
		var date = new Date(parseInt(jsondate, 10));
		var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
		var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
		if(date.getMinutes()<1){
			return month +"/"+currentDate+" "+date.getHours()+":"+ date.getMinutes()+"0";
		}
		return month +"/"+currentDate+" "+ date.getHours()+":"+ date.getMinutes();
		}