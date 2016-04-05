var UserInfo ="";
var typeId = "";
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
	var url = UrlRoot+"LeaveProxyService.ashx?Action=GetLeaveInfo&userID=120037&authorizeCode=11";
	getJsonFormServer(url, onSuccess);	
}

//$(function(){
//	var url = UrlRoot+"LeaveProxyService.ashx?Action=GetLeaveInfo&userID=120037&authorizeCode=11";
//	getJsonFormServer(url, onSuccess);	
//});

var appUserCode ="";
function onSuccess(data){
	var t_option = "";
	for ( var j = 0; j < data.LeaveType.length; j++) {
		var rst = data.LeaveType[j];
		t_option = t_option + " <option value='" + rst.LeaveType + "'>"
				+ rst.LeaveType + "</option>";
	}
	$("#leaveType").html(t_option);
	appUserCode = data.HolidayPreview[0].empcode;
	var tr = "";
	for ( var i = 0; i < data.HolidayPreview.length; i++) {
		var rst = data.HolidayPreview[i];
		var enddate = "";
		var d = new Date();
		if(d.getFullYear()==ChangeDateFormat(rst.enddate).substr(0,4)){
			enddate = ChangeDateFormat(rst.enddate);
		}else{
			enddate ="审核中";
		}
			tr = tr+"<tr><td>"+rst.leavetype+"</td><td>"+Math.floor(rst.AllHours/8)+"天</td><td>"+Math.floor(rst.UsedHours/8)+"天</td><td>"+Math.floor(rst.Hours/8)+"天</td><td>"+rst.year+"</td><td>"+enddate+"</td></tr>";
	
	}
	
	var table = "<table border='1' style='border-color: #ccc;text-align: center;' >"
	+"<tr style='font-weight: bold;'><td>休假类型</td><td>假期总时长</td><td>已用时长</td><td>可用时长</td><td>年份</td><td>有效期</td></tr>"
	+tr+"</table>";
	$("#looktab").html(table);
}
//提交
function onSub(){
	var processCode ="SMS_HR_QJSQ";
	var start = $("#startTime").val();
	var end = $("#endTime").val();
	var leaveType = $("#leaveType").val();
	var remark = $("#remark").val();
	var flag = "";
	if($("#flag").attr("checked")=="checked"){
		flag= "true";
	}else{
		flag="false";
	}
	
	if(start=="" || end==""|| remark.trim()=="" ||leaveType==""){
		onMessage("请将信息填写完整后提交！");
		return;
	}
	var startDate = start.substr(0,10);
	var startTime = start.substr(11);
	var endDate = end.substr(0,10);
	var emdTime = end.substr(11);
	var duration = "";
	
	var date1 = new Date(start);
	var date2 = new Date(end);
	var date3= date2.getTime()-date1.getTime();
	//计算出相差天数  
	var days=Math.floor(date3/(24*3600*1000))  
	var leave1=date3%(24*3600*1000)    //计算天数后剩余的毫秒数  
	var hours=leave1/(3600*1000); 
	if (date1.getTime() >= date2.getTime()) {
		onMessage("开始时间不能大于或等于结束时间！");
		return;
	}
	if(startDate == endDate){
		if(hours<=8){
			duration =hours.toFixed(2);	
		}
	}else{
		duration = (dealtime(startDate,endDate)*8).toFixed(2);
	}
	var detailEntityJson ="{'leaveType':'"+leaveType+"','startDate':'"+startDate+"','startTime':'"+startTime+"','endDate':'"+endDate+"','emdTime':'"+emdTime+"','duration':'"+duration+"','remark':'"+remark.trim()+"'}";
	var basicEntityJson = "{'appUserCode':'"+appUserCode+"'}";
	var url =UrlRoot+"LeaveProxyService.ashx?Action=SaveDrafInfo&userID=120037&authorizeCode=11&detailEntityJson="+escape(detailEntityJson)+"&basicEntityJson="+(basicEntityJson)+"&flag="+flag+"&processCode=" + escape(processCode);
 	 getJsonFormServer(url, onSubmitSuccess);

}
function onSubmitSuccess(data) {
	if (data.Result == "1") {
		onMessage("流程申请成功");
	   setTimeout("finishWebView()",1000);   
} else {
		onMessage("流程申请失败");
	   setTimeout("finishWebView()",1000);   
}
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
//计算时间差
function dealtime(time1, time2) {
	// 把时间按"_"切成数组
	var ss1 = time1.split("-");
	var ss2 = time2.split("-");
	// 转为毫秒数
	var btime = new Date(ss1[0], ss1[1] - 1, ss1[2]);
	var etime = new Date(ss2[0], ss2[1] - 1, ss2[2]);
	// 计算相差天数
	time = (etime.getTime() - btime.getTime()) / (1000 * 24 * 60 * 60);

	return time;
}
//时间相差
function dateTimes(endTime,startTime){
	var date3= endTime.getTime()-startTime.getTime();
	//计算出相差天数  
	var days=Math.floor(date3/(24*3600*1000))  
	//计算出小时数  
	var leave1=date3%(24*3600*1000)    //计算天数后剩余的毫秒数  
	var hours=leave1/(3600*1000); 
	//计算相差分钟数  
	var leave2=leave1%(3600*1000)        //计算小时数后剩余的毫秒数  
	var minutes=Math.floor(leave2/(60*1000))  
	//计算相差秒数  
	var leave3=leave2%(60*1000)      //计算分钟数后剩余的毫秒数  
	var seconds=Math.round(leave3/1000)  
// 	" 相差 "+days+"天 "+hours+"小时 "+minutes+" 分钟"+seconds+" 秒"

}



//格式化日期
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
return date.getFullYear() + "-" + month + "-" + currentDate;
}

//日期控件
$(function() {
	var curr = new Date().getFullYear();
	var opt = {

	}

	opt.date = {
		preset : 'date'
	};
	opt.datetime = {
		preset : 'datetime',
		minDate : new Date(2012, 3, 10, 9, 22),
		maxDate : new Date(2014, 7, 30, 15, 44),
		stepMinute : 5
	};
	opt.time = {
		preset : 'time'
	};
	opt.tree_list = {
		preset : 'list',
		labels : [ 'Region', 'Country', 'City' ]
	};
	opt.image_text = {
		preset : 'list',
		labels : [ 'Cars' ]
	};
	opt.select = {
		preset : 'select'
	};
	$('input[data-role="datebox"]').val('').scroller('destroy').scroller(
			$.extend(opt['datetime'], {
				theme : 'android-ics',
				mode : 'mixed',
				display : 'bottom',
				lang : 'zh'
			}));

});