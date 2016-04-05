//
//  AppInfo.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-22.
//
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property(nonatomic, retain) NSString* appID;
@property(nonatomic, retain) NSString* appName;
@property(nonatomic, assign) int appType;
@property(nonatomic, retain) NSString* appIconUrl;
@property(nonatomic, retain) NSString* homeIcon;
@property(nonatomic, retain) NSString* appDownLoadUrl;
@property(nonatomic, assign) double     appSize;
@property(nonatomic, retain) NSString* appVersion;
@property(nonatomic, retain) NSString* appAuthoriy;
@property(nonatomic, retain) NSString* appDes;
@property(nonatomic, retain) NSString* appLocalUrl;
@property(nonatomic, assign) int unReadMessageNumber;
@property(nonatomic, assign) int appIndex;
@property(nonatomic, assign) int    appSatate;  //下载 1，下载中 2，卸载 3，更新 4
@property(nonatomic, retain) NSString* pgComPkgVer; //phonegap公共包
@end
