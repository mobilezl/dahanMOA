//
//  CommonFun.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-19.
//
//

#import <UIKit/UIKit.h>

@interface CommonTool : NSObject

+(CommonTool*) commonToolManager;
- (BOOL) isConnectionAvailable;
- (BOOL) IS_IOS7;
- (UIColor *)UIColorFromRGB: (NSInteger)rgbValue;
- (UIImage*) getAppBgPic;
- (UIImage*) getAppNavBgPic;
- (UIImage*) getAppMenuBarBgPic;
- (NSString*) getUUID;
@end
