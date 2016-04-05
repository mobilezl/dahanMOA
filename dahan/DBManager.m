//
//  DBManager.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-22.
//
//

#import "DBManager.h"
#import "AppInfo.h"
#import "FMDB.h"
#import "AppBgPicInfo.h"
#import "AppMsgInfo.h"
#import "AppDefine.h"

static DBManager* gdbManager;

@implementation DBManager


+ (DBManager*) dbManager
{
    if(gdbManager == nil)
    {
        gdbManager = [[DBManager alloc] init];
    }
    
    return gdbManager;
}

-(BOOL) executeSaveAppInfos:(NSArray* )arry
{
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }
    
     BOOL bCreate = [database executeUpdate:@"create table appInfos (appID text,appAuthoriy text,appDes text, appDownLoadUrl text, appIconUrl text, appLocalUrl text, appName text, appSize NSNumber, appType text, appVersion text, unReadMessageNumber text, appIndex text, userAccount text, homeIcon text)"];
    NSError* e = [database lastError];
    NSString* eStr = [database lastErrorMessage];
    
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppInfo* appInfo = (AppInfo*)[arry objectAtIndex:i];
        
        //插入数据
        b = [database executeUpdate:@"insert into appInfos values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)", appInfo.appID, appInfo.appAuthoriy, appInfo.appDes, appInfo.appDownLoadUrl, appInfo.appIconUrl,appInfo.appLocalUrl, appInfo.appName,[NSNumber numberWithDouble:appInfo.appSize],[NSString stringWithFormat:@"%d", appInfo.appType], appInfo.appVersion,[NSString stringWithFormat:@"%d", appInfo.unReadMessageNumber], [NSString stringWithFormat:@"%d", appInfo.appIndex], gUserAccout, appInfo.homeIcon];
//        break;
        NSError* ee = [database lastError];
        NSString* eeStr = [database lastErrorMessage];
    }
    [database close];
    
    return b;
}

-(BOOL) executeUpdateAppInfos:(NSArray*) arry
{
    
}
-(NSMutableArray*) executeFindAppInfos
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    for(int i = 0; i < paths.count; ++i)
    {
        NSString* d = [paths objectAtIndex:i];
        NSString* dd = d;
    }
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    FMResultSet *resultSet = [database executeQuery:@"select * from appInfos where userAccount =?", gUserAccout];
    
    while ([resultSet next])
    {
        AppInfo* appInfo = [[AppInfo alloc] init];
        appInfo.appID = [resultSet stringForColumn:@"appID"];
        appInfo.appIconUrl = [resultSet stringForColumn:@"appIconUrl"];
        appInfo.appName = [resultSet stringForColumn:@"appName"];
        appInfo.appLocalUrl = [resultSet stringForColumn:@"appLocalUrl"];
        appInfo.appType = [resultSet intForColumn:@"appType"];
        appInfo.appVersion = [resultSet stringForColumn:@"appVersion"];
        appInfo.appIndex = [resultSet intForColumn:@"appIndex"];
        appInfo.homeIcon = [resultSet stringForColumn:@"homeIcon"];
        [returnArr addObject:appInfo];
        
        NSLog(@"appID:%@,appIconUrl:%@,appName:%@, appLocalUrl:%@, appType:%d, appVersion:%@,appIndex:%d",appInfo.appID,appInfo.appIconUrl,appInfo.appName, appInfo.appLocalUrl, appInfo.appType, appInfo.appVersion, appInfo.appIndex);
    }
    
    [database close];
    
    return returnArr;
}

-(NSMutableArray*) getAppIDs
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }
    
    NSMutableArray* muArry = [NSMutableArray arrayWithCapacity:5];

    FMResultSet *resultSet = [database executeQuery:@"select * from appInfos where userAccount =?", gUserAccout];
    while ([resultSet next]) {
        NSString* appID = [resultSet stringForColumn:@"appID"];
        [muArry addObject:appID];
    }
    
    [database close];
    
    return muArry;
}

-(BOOL) executeDeleteApps:(NSArray*)arry
{
    BOOL delete = TRUE;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppInfo* appInfo = [arry objectAtIndex:i];
        delete = [database executeUpdate:@"delete from appInfos where appID = ? and userAccount = ?",appInfo.appID, gUserAccout];
    }
    
    [database close];
    return delete;
}

-(BOOL) executeSaveAppPics:(NSArray*) arry
{
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }
    
    BOOL bCreate = [database executeUpdate:@"create table appBgPics (picID text, picUrl text, picPreviewUrl text, navUrl text, menuBarUrl text, bSelected text, userAccout text)"];
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppBgPicInfo* appBgPicInfo = (AppBgPicInfo*)[arry objectAtIndex:i];
        NSString* strSelected = @"0";
        if(appBgPicInfo.bSelected)
        {
            strSelected = @"1";
        }
        //插入数据
        b = [database executeUpdate:@"insert into appBgPics values (?,?,?,?,?,?,?)", appBgPicInfo.appBgPicID, appBgPicInfo.appBgPicUrl, appBgPicInfo.appBgPicPreviewUrl, appBgPicInfo.appNavPicUrl, appBgPicInfo.appMenuBarPicUrl,strSelected, gUserAccout];
//        break;
    }
    [database close];
    
    return b;

}
-(NSMutableArray*) executeFindAppPics
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    FMResultSet *resultSet = [database executeQuery:@"select * from appBgPics where userAccout = ?", gUserAccout];
    
    while ([resultSet next])
    {
        AppBgPicInfo* appBgPicInfo = [[AppBgPicInfo alloc] init];
        appBgPicInfo.appBgPicID = [resultSet stringForColumn:@"picID"];
        appBgPicInfo.appBgPicUrl = [resultSet stringForColumn:@"picUrl"];
        appBgPicInfo.appBgPicPreviewUrl = [resultSet stringForColumn:@"picPreviewUrl"];
        appBgPicInfo.appNavPicUrl = [resultSet stringForColumn:@"navUrl"];
        appBgPicInfo.appMenuBarPicUrl = [resultSet stringForColumn:@"menuBarUrl"];
        NSString* str = [resultSet stringForColumn:@"bSelected"];
        if([str isEqualToString:@"0"])
        {
            appBgPicInfo.bSelected = false;
        }
        else
        {
            appBgPicInfo.bSelected = true;
        }
        [returnArr addObject:appBgPicInfo];
        
        NSLog(@"appBgPicID:%@,appBgPicUrl:%@,appBgPicPreviewUrl:%@",appBgPicInfo.appBgPicID, appBgPicInfo.appBgPicUrl, appBgPicInfo.appBgPicPreviewUrl);
    }
    
    [database close];
    
    return returnArr;
}
-(NSMutableArray*) getAppPicsID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }
    
    NSMutableArray* muArry = [NSMutableArray arrayWithCapacity:5];
    
    FMResultSet *resultSet = [database executeQuery:@"select * from appBgPics where userAccout = ?", gUserAccout];
    while ([resultSet next]) {
        NSString* appBgPicID = [resultSet stringForColumn:@"picID"];
        [muArry addObject:appBgPicID];
    }
    
    [database close];
    
    return muArry;

}

-(BOOL) executeDeleteAppPics:(NSArray *)arry
{
    BOOL delete = TRUE;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppBgPicInfo* appBgPicInfo = [arry objectAtIndex:i];
        delete = [database executeUpdate:@"delete from appBgPics where picID = ? and userAccout = ?",appBgPicInfo.appBgPicID, gUserAccout];
    }
    
    [database close];
    return delete;

}

-(AppBgPicInfo*) getSelecedAppBgPicInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }

    FMResultSet *resultSet = [database executeQuery:@"select * from appBgPics where bSelected = ? and userAccout = ?", @"1", gUserAccout];
    NSString* appBgPicUrl = @"";
    AppBgPicInfo* appBgPicInfo = [[AppBgPicInfo alloc] init];
    
    while ([resultSet next]) {
        appBgPicInfo.appBgPicUrl = [resultSet stringForColumn:@"picUrl"];
        appBgPicInfo.appNavPicUrl = [resultSet stringForColumn:@"navUrl"];
       appBgPicInfo.appMenuBarPicUrl = [resultSet stringForColumn:@"menuBarUrl"];
    }
    
    [database close];
    
    return appBgPicInfo;
}

-(BOOL) executeUpdateAppPics:(NSArray*) arry
{
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }
    
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppBgPicInfo* appBgPicInfo = (AppBgPicInfo*)[arry objectAtIndex:i];
        NSString* strSelected = @"0";
        if(appBgPicInfo.bSelected)
        {
            strSelected = @"1";
        }
        //插入数据picID text, picUrl text, picPreviewUrl text, bSelected text
        b = [database executeUpdate:@"update appBgPics set bSelected = ? where picID = ? and userAccout = ?", strSelected, appBgPicInfo.appBgPicID, gUserAccout];

    }
    [database close];
    
    return b;

}


-(BOOL) executeSaveAppMsgs:(NSArray*) arry
{
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }
    
    BOOL bCreate = [database executeUpdate:@"create table appMsgs (appID text, appName text, msgIcon text, appEntry text, appKey text, msgcontent text, msgID text, msgIsRead text, userAccount text)"];
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppMsgInfo* appMsgInfo = (AppMsgInfo*)[arry objectAtIndex:i];
        NSString* strRead = @"0";
        if(appMsgInfo.isRead)
        {
            strRead = @"1";
        }
        //插入数据
        b = [database executeUpdate:@"insert into appMsgs values (?,?,?,?,?,?,?,?,?)", appMsgInfo.appID, appMsgInfo.appName, appMsgInfo.msgIcon, appMsgInfo.appEntry, appMsgInfo.appKey, appMsgInfo.msgContent, appMsgInfo.msgID,strRead, gUserAccout];
        //        break;
    }
    [database close];
    
    return b;

}
-(BOOL) executeUpdateAppMsgs:(NSArray*) arry
{
    
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppMsgInfo* appMsgInfo = (AppMsgInfo*)[arry objectAtIndex:i];
        NSString* strRead = @"0";

        if(appMsgInfo.isRead)
        {
            strRead = @"1";
        }
        //插入数据
        b = [database executeUpdate:@"update appMsgs set msgIsRead = ? where msgID = ? and userAccount = ?", strRead, appMsgInfo.msgID, gUserAccout];
        
    }
    [database close];
    
    return b;

}

-(BOOL) executeUpdateAppMsgsReadedByAppID:(NSString*) appid
{
    
    BOOL b = FALSE;
    
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return b;
    }

    //插入数据
    b = [database executeUpdate:@"update appMsgs set msgIsRead = 1 where appID = ? and userAccount = ?", appid, gUserAccout];
    
    [database close];
    
    return b;
    
}

-(NSMutableArray*) executeFindAppMsgs
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    FMResultSet *resultSet = [database executeQuery:@"select * from appMsgs where userAccount = ?", gUserAccout];
    
    while ([resultSet next])
    {//appID text, appName text, msgIcon text, appEntry text, appKey text, msgcontent text, msgID text, msgIsRead text
        AppMsgInfo* appMsgInfo = [[AppMsgInfo alloc] init];
        appMsgInfo.appID = [resultSet stringForColumn:@"appID"];
        appMsgInfo.appName = [resultSet stringForColumn:@"appName"];
        appMsgInfo.appKey = [resultSet stringForColumn:@"appKey"];
        appMsgInfo.appEntry = [resultSet stringForColumn:@"appEntry"];
        appMsgInfo.msgIcon = [resultSet stringForColumn:@"msgIcon"];
        appMsgInfo.msgID = [resultSet stringForColumn:@"msgID"];
        appMsgInfo.msgContent = [resultSet stringForColumn:@"msgContent"];
        NSString* str = [resultSet stringForColumn:@"msgIsRead"];
        if([str isEqualToString:@"0"])
        {
            appMsgInfo.isRead = false;
        }
        else
        {
            appMsgInfo.isRead = true;
        }

        [returnArr addObject:appMsgInfo];
        
        NSLog(@"appID:%@,appName:%@,appKey:%@, appEntry:%@, msgIcon:%@, msgIsRead:%@",appMsgInfo.appID, appMsgInfo.appName, appMsgInfo.appKey, appMsgInfo.appEntry, appMsgInfo.msgIcon, str);
    }
    
    [database close];
    
    return returnArr;

}


-(NSMutableDictionary*) executeFindAppUnMsgs
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    NSMutableDictionary* muDir = [NSMutableDictionary dictionaryWithCapacity:5];
    
    FMResultSet *resultSet = [database executeQuery:@"select appID appid,count(appID) C from appMsgs where msgIsRead = 0 and userAccount = ? group by appID", gUserAccout];
    while ([resultSet next])
    {
        NSString* s = [resultSet stringForColumn:@"appid"];
        NSString* count = [resultSet stringForColumn:@"C"];
        [muDir setObject:count forKey:s];

    }

    return muDir;
}
-(NSMutableArray*) getAppMsgsID
{
    return [NSMutableArray arrayWithCapacity:5];
}

-(NSMutableArray*) getAppReadedMsgs:(NSString*) appid;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    FMResultSet *resultSet = [database executeQuery:@"select * from appMsgs where msgIsRead = 1 and appID = ? and userAccount = ?", appid, gUserAccout];
    
    while ([resultSet next])
    {//appID text, appName text, msgIcon text, appEntry text, appKey text, msgcontent text, msgID text, msgIsRead text
        AppMsgInfo* appMsgInfo = [[AppMsgInfo alloc] init];
        appMsgInfo.appID = [resultSet stringForColumn:@"appID"];
        appMsgInfo.appName = [resultSet stringForColumn:@"appName"];
        appMsgInfo.appKey = [resultSet stringForColumn:@"appKey"];
        appMsgInfo.appEntry = [resultSet stringForColumn:@"appEntry"];
        appMsgInfo.msgIcon = [resultSet stringForColumn:@"msgIcon"];
        appMsgInfo.msgID = [resultSet stringForColumn:@"msgID"];
        appMsgInfo.msgContent = [resultSet stringForColumn:@"msgContent"];
        appMsgInfo.isRead = true;
    
        [returnArr addObject:appMsgInfo];
        
        NSLog(@"appID:%@,appName:%@,appKey:%@, appEntry:%@, msgIcon:%@, msgIsRead:%d",appMsgInfo.appID, appMsgInfo.appName, appMsgInfo.appKey, appMsgInfo.appEntry, appMsgInfo.msgIcon, appMsgInfo.isRead);
    }
    
    [database close];
    
    return returnArr;

}

-(NSMutableArray*) getAppUnReadMsgs:(NSString*) appid
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return nil;
    }
    
    NSMutableArray* returnArr = [NSMutableArray arrayWithCapacity:5];
    FMResultSet *resultSet = [database executeQuery:@"select * from appMsgs where msgIsRead = 0 and appID = ? and userAccount = ?", appid, gUserAccout];
    
    while ([resultSet next])
    {//appID text, appName text, msgIcon text, appEntry text, appKey text, msgcontent text, msgID text, msgIsRead text
        AppMsgInfo* appMsgInfo = [[AppMsgInfo alloc] init];
        appMsgInfo.appID = [resultSet stringForColumn:@"appID"];
        appMsgInfo.appName = [resultSet stringForColumn:@"appName"];
        appMsgInfo.appKey = [resultSet stringForColumn:@"appKey"];
        appMsgInfo.appEntry = [resultSet stringForColumn:@"appEntry"];
        appMsgInfo.msgIcon = [resultSet stringForColumn:@"msgIcon"];
        appMsgInfo.msgID = [resultSet stringForColumn:@"msgID"];
        appMsgInfo.msgContent = [resultSet stringForColumn:@"msgContent"];
        appMsgInfo.isRead = false;
        
        [returnArr addObject:appMsgInfo];
        
        NSLog(@"appID:%@,appName:%@,appKey:%@, appEntry:%@, msgIcon:%@, msgIsRead:%d",appMsgInfo.appID, appMsgInfo.appName, appMsgInfo.appKey, appMsgInfo.appEntry, appMsgInfo.msgIcon, appMsgInfo.isRead);
    }
    
    [database close];
    
    return returnArr;

}

-(BOOL) executeDeleteAppMsgs:(NSArray *)arry
{
    BOOL delete = TRUE;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"dahan.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return 0;
    }
    
    for(int i = 0; i < arry.count; ++i)
    {
        AppMsgInfo* appMsgInfo = [arry objectAtIndex:i];
        delete = [database executeUpdate:@"delete from appMsgs where msgID = ? and userAccount = ?",appMsgInfo.msgID, gUserAccout];
    }
    
    [database close];
    return delete;
    

}
@end
