//
//  AppDefine.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-17.
//
// 

#import "UserInfo.h"
//#define SERVERADDRESS @"http://dahanis.eicp.net:25084"
//#define SERVERADDRESS @"http://106.39.17.123:8080"
//#define SERVERADDRESS @"http://172.16.11.61:8080"
#define SERVERADDRESS @"http://mworkflow.cofcoko.com"

//#define SERVERADDRESS @"http://m.dahanis.com:8000"

//#define SERVERADDRESS @"http://180.173.61.125:25084"
//
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define USEIP 0

NSString* gUserName;
NSString* gUserAccout;
NSString* gUserPassword;
NSString* gAuthorizeCode;
int       gStyleType;
NSString* gUUID;
NSString* gOpenID;
NSString* gAppVer;
NSString* glocalVersion;
NSString* gDownLoadUrl;
NSMutableDictionary* gParametersForJS;  //存储JS返回过来的参数
BOOL      gNotificationDownloadMsg;
UserInfo* gUserInfo;
//NSString* gDeviceApnToken;