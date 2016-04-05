//
//  DBManager.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-22.
//
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"
#import "AppBgPicInfo.h"
@interface DBManager : NSObject

+(DBManager*) dbManager;

/*
 AppList
 */
-(BOOL) executeSaveAppInfos:(NSArray* )arry;
-(NSMutableArray*) executeFindAppInfos;
-(BOOL) executeUpdateAppInfos:(NSArray*) arry;
-(NSMutableArray*) getAppIDs;
-(BOOL) executeDeleteApps:(NSArray*)arry;

/*
 AppPicList
 */

-(BOOL) executeSaveAppPics:(NSArray*) arry;
-(BOOL) executeUpdateAppPics:(NSArray*) arry;
-(NSMutableArray*) executeFindAppPics;
-(NSMutableArray*) getAppPicsID;
-(BOOL) executeDeleteAppPics:(NSArray *)arry;
-(AppBgPicInfo*) getSelecedAppBgPicInfo;

/*
 App_Message
 */
-(BOOL) executeSaveAppMsgs:(NSArray*) arry;
-(BOOL) executeUpdateAppMsgs:(NSArray*) arry;
-(BOOL) executeUpdateAppMsgsReadedByAppID:(NSString*) appid;
-(NSMutableArray*) executeFindAppMsgs;
-(NSMutableDictionary*) executeFindAppUnMsgs;
-(NSMutableArray*) getAppMsgsID;
-(NSMutableArray*) getAppReadedMsgs:(NSString*) appid;
-(NSMutableArray*) getAppUnReadMsgs:(NSString*) appid;
-(BOOL) executeDeleteAppMsgs:(NSArray *)arry;
@end
