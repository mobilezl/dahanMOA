//
//  CommonFun.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-19.
//
//

#import "CommonTool.h"
#import "AppDefine.h"
#import "DBManager.h"
#import "NSString+NSString_MD5HexDigest.h"
#import "AppBgPicInfo.h"
static CommonTool* gCommonToolManager;

@implementation CommonTool


+ (CommonTool*) commonToolManager
{
    if(gCommonToolManager == nil)
    {
        gCommonToolManager = [[CommonTool alloc] init];
    }
    
    return gCommonToolManager;
}

- (BOOL) isConnectionAvailable
{
    
    return TRUE;
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
    
}

- (NSUInteger) DeviceSystemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}


- (BOOL) IS_IOS7
{
    return ([self DeviceSystemMajorVersion] >= 7);
}

- (UIColor *)UIColorFromRGB: (NSInteger)rgbValue {
    
    UIColor *rgbColor;
    
    rgbColor = [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                               green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                                blue: ((float)(rgbValue & 0xFF)) / 255.0
                               alpha: 1.0];
    
    return rgbColor;
}

-(UIImage*) getAppBgPic
{
    UIImage* bgImg = NULL;
    AppBgPicInfo* bgPicInfo = [[DBManager dbManager] getSelecedAppBgPicInfo];
    NSString* bgPicUrl = bgPicInfo.appBgPicUrl;
    if(bgPicUrl == nil || [bgPicUrl isEqualToString:@""] || [bgPicUrl isEqualToString:@"defaultBgPic"])
    {
        bgImg = [UIImage imageNamed:@"main_bg.png"];
    }
    else
    {
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        
        NSString *imageType = @"png";
        //从url中获取图片类型
        　　NSMutableArray *arr = (NSMutableArray *)[bgPicUrl componentsSeparatedByString:@"."];
        if (arr) {
            imageType = [arr objectAtIndex:arr.count-1];
        }
        NSString* filePath = [docPath stringByAppendingPathComponent:@"dahanPic"];
        NSString* md5StrUrl = [[[bgPicUrl md5HexDigest] stringByAppendingString:@"."] stringByAppendingString:imageType];
        filePath = [filePath stringByAppendingPathComponent:md5StrUrl];
        

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:filePath forKey:@"AppBgPic"];
        [userDefaults synchronize];
        
        bgImg = [UIImage imageWithContentsOfFile:filePath];
    }

    return bgImg;
    
  
}


- (UIImage*) getAppNavBgPic
{
    UIImage* bgImg = NULL;
    AppBgPicInfo* bgPicInfo = [[DBManager dbManager] getSelecedAppBgPicInfo];
    NSString* bgNavPicUrl = bgPicInfo.appNavPicUrl;
    if(bgNavPicUrl == nil || [bgNavPicUrl isEqualToString:@""] || [bgNavPicUrl isEqualToString:@"defaultNavBgPic"])
    {
        bgImg = [UIImage imageNamed:@"main_Navbg.png"];
    }
    else
    {
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        
        NSString *imageType = @"png";
        //从url中获取图片类型
        　　NSMutableArray *arr = (NSMutableArray *)[bgNavPicUrl componentsSeparatedByString:@"."];
        if (arr) {
            imageType = [arr objectAtIndex:arr.count-1];
        }
        NSString* filePath = [docPath stringByAppendingPathComponent:@"dahanPic"];
        NSString* md5StrUrl = [[[bgNavPicUrl md5HexDigest] stringByAppendingString:@"."] stringByAppendingString:imageType];
        filePath = [filePath stringByAppendingPathComponent:md5StrUrl];
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:filePath forKey:@"AppNavBgPic"];
        [userDefaults synchronize];
        
        bgImg = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return bgImg;

}
- (UIImage*) getAppMenuBarBgPic
{
    UIImage* bgImg = NULL;
    AppBgPicInfo* bgPicInfo = [[DBManager dbManager] getSelecedAppBgPicInfo];
    NSString* bgMenuBarPicUrl = bgPicInfo.appMenuBarPicUrl;
    if(bgMenuBarPicUrl == nil ||
       [bgMenuBarPicUrl isEqualToString:@""] || [bgMenuBarPicUrl isEqualToString:@"defaultMenuBarBgPic"])
    {
        bgImg = [UIImage imageNamed:@"main_MenuBarbg.png"];
    }
    else
    {
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        
        NSString *imageType = @"png";
        //从url中获取图片类型
        　　NSMutableArray *arr = (NSMutableArray *)[bgMenuBarPicUrl componentsSeparatedByString:@"."];
        if (arr) {
            imageType = [arr objectAtIndex:arr.count-1];
        }
        NSString* filePath = [docPath stringByAppendingPathComponent:@"dahanPic"];
        NSString* md5StrUrl = [[[bgMenuBarPicUrl md5HexDigest] stringByAppendingString:@"."] stringByAppendingString:imageType];
        filePath = [filePath stringByAppendingPathComponent:md5StrUrl];
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:filePath forKey:@"AppMenuBarBgPic"];
        [userDefaults synchronize];
        
        bgImg = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return bgImg;

}

- (NSString*) getUUID
{
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    return uuid;
}
@end
