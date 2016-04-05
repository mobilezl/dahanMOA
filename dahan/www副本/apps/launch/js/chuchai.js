var UserInfo ="";
var typeId = "";
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (Client == 1) {
		UserInfo = eval("(" + getAndroidUserInfo() + ")");
		typeId = eval("("+getParameters()+")");
		 var url = UrlRoot+"TravelpProxyService.ashx?Action=GetTravelInfo&userID=120037&authorizeCode=11&travelType="+typeId.typeId;		 
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
	 var url = UrlRoot+"TravelpProxyService.ashx?Action=GetTravelInfo&userID=120037&authorizeCode=11&travelType="+typeId.typeId;			
	 getJsonFormServer(url, onSuccess);		
}

//$(function(){
//	 var url = UrlRoot+"TravelpProxyService.ashx?Action=GetTravelInfo&userID=120037&authorizeCode=11&travelType=1";			
//	 getJsonFormServer(url, onSuccess);	
//});

function onSuccess(data) {
	var option = "";
	for ( var i = 0; i < data.SiteList.length; i++) {
		var rst = data.SiteList[i];
		option = option + " <option value='" + rst.EncodeText + "'>"
				+ rst.EncodeValue + "</option>";
	}
	$("#chufa").html(option);
	$("#mudi").html(option);

	var t_option = "";
	for ( var j = 0; j < data.TransportList.length; j++) {
		var rst = data.TransportList[j];
		t_option = t_option + " <option value='" + rst.EncodeText + "'>"
				+ rst.EncodeValue + "</option>";
	}
	$("#jiaotong").html(t_option);
}

// 提交
function onSub() {
	// 出差事务类型
	var businessTravelTypeField = "国外";
	var appUserCodeField = $("#man").val();
	var startSiteField = $("#chufa").val();
	var endSiteField = $("#mudi").val();
	var moreTripModeField = $("#jiaotong").val();
	var startDateField = $("#startTime").val();
	var endDateField = $("#endTime").val();
	var purposeField = $("#context").val();
	// 出差事务持续时间
	var businessTravelDurationField = dealtime(startDateField, endDateField);
	var d1 = new Date(startDateField);
	var d2 = new Date(endDateField);
	if(startDateField=="" || endDateField==""|| purposeField.trim()=="" || startSiteField =="" || endSiteField=="" || moreTripModeField==""){
		onMessage("请将信息填写完整后提交！");
		return;
	}
	if (d1.getTime() >= d2.getTime()) {
		onMessage("开始时间不能大于或等于结束时间！");
		return;
	}
	var detailEntity = "{'purpose':'" + purposeField.trim() + "','startSite':'"
			+ startSiteField + "','endSite':'" + endSiteField
			+ "','startDate':'" + startDateField + "','endDate':'"
			+ endDateField + "','businessTravelDuration':'"
			+ businessTravelDurationField + "','moreTripMode':'"
			+ moreTripModeField + "'}";
	var basicEntity = "{'businessTravelType':'" + businessTravelTypeField
			+ "','appUserCode':'" + appUserCodeField + "'}";
	var processCode = "SMS_HR_CCSQ";

	var url = UrlRoot
			+ "TravelpProxyService.ashx?Action=SaveDrafInfo&userID=120037&authorizeCode=11&detailEntity="
			+ escape(detailEntity) + "&basicEntity=" + escape(basicEntity)
			+ "&processCode=" + escape(processCode);
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


// 计算时间差
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

// 日期控件
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
			$.extend(opt['date'], {
				theme : 'android-ics',
				mode : 'mixed',
				display : 'bottom',
				lang : 'zh'
			}));

});