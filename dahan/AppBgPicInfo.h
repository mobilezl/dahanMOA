//
//  AppBgPicInfo.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-2.
//
//

#import <Foundation/Foundation.h>

@interface AppBgPicInfo : NSObject

@property(nonatomic, retain) NSString* appBgPicID;
@property(nonatomic, retain) NSString* appBgPicUrl;
@property(nonatomic, retain) NSString* appBgPicPreviewUrl;
@property(nonatomic, retain) NSString* appNavPicUrl;
@property(nonatomic, retain) NSString* appMenuBarPicUrl;
@property(nonatomic, assign) bool bSelected;
@end
