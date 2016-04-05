//
//  AppMsgInfo.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-18.
//
//

#import <Foundation/Foundation.h>

@interface AppMsgInfo : NSObject

@property(nonatomic, retain) NSString* appID;
@property(nonatomic, retain) NSString* appName;
@property(nonatomic, retain) NSString* msgIcon;
@property(nonatomic, retain) NSString* appEntry;
@property(nonatomic, retain) NSString* appKey;
@property(nonatomic, retain) NSString* msgContent;
@property(nonatomic, retain) NSString* msgID;
@property(nonatomic, assign) BOOL       isRead;
@end
