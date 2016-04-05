/**
* Created caobaolin. 
* Author: caobaolin
* Date: 6/13/12 
* PhoneGAP plugin pushtoken 
*/

var webView = function () {};    

/**
 * js 中的调用方法，通过native处理网络请求数据，再将数据返回给js 参数 jscallback 回调函数 requestType 请求类型
 * 
 * @param url
 *            访问URL
 * @param jscallback
 *            回调函数，并传递字符串给用户
 * @param requestType
 *            请求方式 'get', 'post'
 */
webView.prototype.getJsonByGet = function(jscallback, url, requestType) {
    var config = {
        index_url : url + '' || '',
        requestType : requestType + '' || '',
    };
    var _callback = function(args) {  
        jscallback(args);    
    };

    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getJsonByGet', [config]);
}

webView.prototype.openContactDetail = function(idUser) {
    var config = {
        idUser : idUser
    };
    var _callback = function(args) {  
    };

    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'openContactDetail', [config]);
}

/**
*jscallback：
*	成功会执行该回调函数，并传递字符串给用户
*	
* @param url
*            请求地址
*/
webView.prototype.getJson = function(jscallback,url) {  
	var _callback = function(args) {  
		jscallback(args);    
	};
   
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getJson', [url]);
};

webView.prototype.callSystemAbility = function(systemAction) {  
    
    var config = {
    	systemAction : systemAction
    };
    
    var _callback = function(args) {  
        //success(args);    
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'callSystemAbility', [config]);
};
/**
 * js 中的调用方法，打开新的界面
 * 
 * @param url
 *            请求页面地址
 * @param titletype
 *            新页面标题类型
 * 
 * @param titletext
 *            标题名
 */

webView.prototype.openWebView = function(url, titletype, titletext) {  
    
    var config = {
        index_url : url + '' || '',
        title : titletext+'' || '',
        titletype : titletype
    };
    
    var _callback = function(args) {  
        //success(args);    
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'openWebView', [config]);
};

webView.prototype.goBackAndOpen = function(url, titletype, titletext) {
    
    var config = {
        index_url : url + '' || '',
        title : titletext+'' || '',
        titletype : titletype
    };
    
    var _callback = function(args) {
        //success(args);
    };
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'goBackAndOpen', [config]);
};

//web.goBackAndOpen(url, titletype, titletext);

/**
 * js 中的调用方法，设置界面中native的title标签
 * 
 * @param title
 *            标题名
 */
webView.prototype.setTitleTxt = function(title) {
    var _callback = function(args) {  
        //jscallback(args);    
    };
    
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'setTitleTxt', [title]);
}

/**
 * 获取推送串号.
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 *///getUuid
webView.prototype.getUuid = function(jscallback) {
    var _callback = function(args) {  
        jscallback(args);    
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getUuid', []);
}
/**
 * 获取登录Token.
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 */
webView.prototype.openToken= function(jscallback) {
    var _callback = function(args) {
        jscallback(args);
    };
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'getToken', []);
}

/**
 * 获取设备名称
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 */
webView.prototype.getDeviceName = function(jscallback) {
    var _callback = function(args) {  
        jscallback(args);    
    };
    
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getDeviceName', []);
}

/**
 * 截取url中“?”之后的字符串.
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 */
webView.prototype.getCallbackParams = function(jscallback) {
    var _callback = function(args) { 
        jscallback(args);   
        return args;
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'urlInterception', []);
}

/**
 * 提示信息
 * 
 * @param message
 *            提示的信息
 */

webView.prototype.alert = function(message) {  
    var _callback = function(args) {     
    };
    message = message.toString();
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'showAlert', [message]);
};

/**
 * 显示订阅按钮
 *
 * 
 */
webView.prototype.showRssButton = function(bool) {
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'showRightBarButtonItem', [bool]);
    
    
}

/**
 * 显示订阅按钮
 *
 * 
 */
webView.prototype.setRightBtnText = function(txt) {
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'setRightBtnText', [txt]);
    
    
}

webView.prototype.setRightBtnImage = function(imgsrc) {
    var _callback = function(args) {
    };
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'setRightBtnImage', [imgsrc]);
    
    
}

/**
 * 控制订阅按钮显示状态.
 *
 * 
 */
webView.prototype.setRightBtnSelect = function(boolen) {
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'setRightBtnSelect', [boolen]);
    
    
}

/**
 * js 中的调用方法，预览图片
 * 
 * @param index
 *            图片序号（0,1,2,3）
 * @param images
 *            图片URL
 * @param names
 *            图片名
 * @param xs
 *            ys 经纬度
 */

webView.prototype.showImage = function(index, imageStr, nameStr, xStr, yStr) {  
    var arr = new Array();
    var images = new Array();
    var names = new Array();
    var xs = new Array();
    var ys = new Array();
    
    
    images = imageStr.split(",");
    names = nameStr.split(",");
    xs = xStr.split(",");
    ys = yStr.split(",");
    
    var count = 0;
    
    if (isArray(images))
    {
        count = images.length;
    }
   
    for(var i = 0; i < count; i++)
    {
       
        var image = images[i];
        var name = "";
        
        if (isArray(names) && names.length>i)
        {
            name = names[i];
        }
        
        if (isArray(xs) && xs.length>i)
        {
            var x = xs[i];
        }
        
        if (isArray(ys) && ys.length>i)
        {
            var y = ys[i];
        }
         
        var config = {
            image : image,
            name : name,
            x : x,
            y : y
        };
         
        arr.push(config);
         
    }
  
    var _callback = function(args) {  
           
    };
   
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'showImage', [index, arr]);
};
function isArray(object){
    return object && typeof object==='object' && Array == object.constructor;
}

/**
 * 获取图片经纬度
 * @param jscallback
 *            回调函数，并传递字符串给用户
 * 
 */
webView.prototype.picGetAdress = function(jscallback) {
    var _callback = function(args) { 
        var x = parseFloat(args.x);
        var y = parseFloat(args.y);
        jscallback(x, y);    
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'picGetAddress', []);
}

/**
 * 要显示的webjs部分通过回调传给native，这时native
 * title的显示种类。（比如：新闻的title就是：返回键＋title标签，校园风光界面的title是：返回键＋title标签＋中间菜单按钮＋右边菜单按钮等）。
 * 更具回调传回来的type类型，native这边做相关显示等操作
 */
webView.prototype.initTitleViewFormTitletype = function(type) {  
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'initTitleViewFormTitletype', [type]);
};

/**
 * js 中的调用方法，设置键值对
 * 
 * @param key
 *            键名
 * @param value
 *            值
 *
 */
webView.prototype.setKeyAndValue = function(key, value) {  
    var config = {
        key : key + '' || '',
        value : value || '',
    };
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'setKeyAndValue', [config]);
};
webView.prototype.dischargeConferenceOk = function(title, msg,callbackParam) {  
    var config = {
        title : title + '' || '',
        msg : msg + '' || '',
    };
    var _callback = function() {
        callbackParam();
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'dischargeConferenceOk', [config]);
};

/**
 * 根据键名获取值
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 * @param key
 *            键名
 */
webView.prototype.getValueByKey = function(jscallback,key) {
//    alert(key);
    var _callback = function(args) {
//        alert(args);
        jscallback(args);    
    };
    
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getValueByKey', [key]);
}

/**
 * 获取当前经纬度
 *
 * @param jscallback
 *            回调函数，并传经纬度给用户
 * 
 */
webView.prototype.getXY = function(jscallback,key) {
    var _callback = function(args) {
        var x = parseFloat(args.x);
        var y = parseFloat(args.y);
        jscallback(x, y);    
    };
    
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'getLocation', [key]);
}

///**
// * 获取当前经纬度
// *
// * @param jscallback
// *            回调函数，并传经纬度给用户
// * 
// */
//webView.prototype.getXY = function(jscallback) {
//    navigator.geolocation.getCurrentPosition(onSuccess, onError);
//    
//    function onSuccess(position) {         
//        var x = parseFloat(position.coords.latitude);
//        
//        var y = parseFloat(position.coords.longitude);
//        
//        jscallback(x, y);    
//    }
//    function onError(error) {
////        alert('code: '    + error.code    + '\n' +
////              'message: ' + error.message + '\n');
//    }
//}

/**
 * 拍照并返回图片路径
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 * 
 */
webView.prototype.getPictureFromCamera = function(jscallback,flag) {

    navigator.camera.getPicture(onPhotoDataSuccess, function(ex) { 
                                // alert("Camera Error!"); 
                                }, { 
                                quality : 50, 
                                targetWidth: 240, 
                                targetHeight: 240, 
                                encodingType: Camera.EncodingType.JPEG,
                                //用data_url,而不用file_url的原因是,file_url在不同平台有差异 
                                destinationType:Camera.DestinationType.FILE_URI,
                                sourceType:Camera.PictureSourceType.CAMERA
                                });
    function onPhotoDataSuccess(imageData) {
        jscallback(imageData);    
    }
    
}

/**
 * 从图片库选取图片并返回路径
 *
 * @param jscallback
 *            回调函数，并传递字符串给用户
 * 
 */
webView.prototype.getPictureFromFile = function(jscallback) {

    navigator.camera.getPicture(onPhotoDataSuccess, function(ex) { 
                                 //alert("Camera Error!"); 
                                }, { 
                                quality : 50, 
                                targetWidth: 240, 
                                targetHeight: 240, 
                                encodingType: Camera.EncodingType.JPEG,
                                //用data_url,而不用file_url的原因是,file_url在不同平台有差异 
                                destinationType:Camera.DestinationType.FILE_URI,
                                sourceType:Camera.PictureSourceType.PHOTOLIBRARY
                                });

    function onPhotoDataSuccess(imageData) {
        jscallback(imageData);    
    }
    
}

/**
 * boolen == true 显示loading层.
 * boolen == false 去除loading层.
 */
webView.prototype.setProgressBarVisibility = function(boolen) {
    if(!boolen)
    {
        boolen = false;
    }
    var _callback = function(args) {     
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'setProgressBar', [boolen]);
    
};

/**
 * 判断是否有网络连接，无网络则提示
 */
webView.prototype.isNetLink = function() {  
    var _callback = function(args) {
//        var result = Boolean(args)
//        jscallback(result);
    };
    return cordova.exec(
                        _callback,
                        _callback, 
                        'com.wisedu.CDVWebView', 'isNetLink', []);
};


/**
 * 判断是否有网络连接，无网络则提示
 */
webView.prototype.Return = function() {
    var _callback = function(args) {
        //        var result = Boolean(args)
        //        jscallback(result);
    };
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'goBack', []);
};

/**

 */
webView.prototype.setTitle = function(titleText,isLeftVisiable,isRightVisiable) {
	var config = {
        title : titleText + '' || '',
        isLeftShow : isLeftVisiable+'' || '',
        isRightShow : isRightVisiable
    };
	
	var _callback = function(args) {
    	
    };
    
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'setTitle', [config]);
}
/**

 */
webView.prototype.setAlarmClock = function(alertID, alertTime, alertMsg) {
	var config = {
        alertID : alertID + '' || '',
        alertTime : alertTime+'' || '',
        alertMsg : alertMsg
    };
	
	var _callback = function(args) {
    	
    };
    
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'setAlarmClock', [config]);
}
webView.prototype.cancelAlarmClock = function(aId) {
	var config = {
        alertID : aId
    };
	
	var _callback = function(args) {
    	
    };
    
    return cordova.exec(
                        _callback,
                        _callback,
                        'com.wisedu.CDVWebView', 'cancelAlarmClock', [config]);
}