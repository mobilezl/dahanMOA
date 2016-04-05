/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  pgapp
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AppDefine.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CommonTool.h"
#import <Cordova/CDVPlugin.h>
#import "LogoViewController.h"

@implementation AppDelegate

@synthesize window, viewController;
@synthesize dahanKeyChain;
@synthesize deviceApnToken;
- (id)init
{
    
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/

    gParametersForJS = [[NSMutableDictionary alloc] initWithCapacity:30];
    gNotificationDownloadMsg = FALSE;
    
    //网络cookie 请求
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    //网络缓存减少了需要向服务器发送请求的次数，同时也提升了离线或在低速网络中使用应用的体验。
    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
        [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}

#pragma mark UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
            
            //UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"推送提示didFinish" message:[dictionary objectForKey:@"badge"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //[av show];
            
            //获取应用程序消息通知标记数（即小红圈中的数字）
            //推送信息到达时你的app不在前台运行，而用户在弹出窗口点击了“View”按钮,则会调用该方法
            
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            //badge = 0;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//[[[dictionary objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
            gNotificationDownloadMsg = TRUE;
            
		}
	}

    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //消息推送注册
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability)];
        
    });
    */
    //消息推送注册
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [application registerForRemoteNotifications];
//    }
//    else
//    {
//        // iOS < 8 Notifications
//        [application registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//    }
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* firstLoginApp = [userDefaults stringForKey:@"firstLoginApp"];
    //UUID
    gUUID = [userDefaults stringForKey:@"AppUUID"];
    if([gUUID isEqualToString:@""] || gUUID == NULL)
    {
        gUUID = [[CommonTool commonToolManager] getUUID];
        [userDefaults setObject:gUUID forKey:@"AppUUID"];
        [userDefaults synchronize];
        gUUID = [userDefaults stringForKey:@"AppUUID"];
    }

    //styleType
    gStyleType = [userDefaults integerForKey:@"AppStyle"];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

#if __has_feature(objc_arc)
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;

    LoginViewController* rVC;
    UINavigationController *nc;
    LogoViewController* lVC;
    ipadLoginViewController *ipadrvc;
    
#if __has_feature(objc_arc)
        //self.viewController = [[MainViewController alloc] init];
    rVC = [[LoginViewController alloc] init];
    
    ipadrvc = [[ipadLoginViewController alloc] init];

    
    nc = [[UINavigationController alloc] initWithRootViewController:rVC];
    
    lVC = [[LogoViewController alloc] init];
    
#else
        //self.viewController = [[[MainViewController alloc] init] autorelease];
    rVC = [[[LoginViewController alloc] init] autorelease];
    
    ipadrvc = [[[ipadLoginViewController alloc] init] autorelease];
    
    nc = [[[UINavigationController alloc] initWithRootViewController:rVC] autorelease];
    
    lVC = [[[LogoViewController alloc] init] autorelease];
#endif
    //self.viewController.useSplashScreen = YES;

    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";

    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        [self.window addSubview:ipadrvc.view];
        self.window.rootViewController = ipadrvc;
        
        
    }else{

    if([firstLoginApp isEqualToString:@""] || firstLoginApp == nil)
    {
        
            [self.window addSubview:lVC.view];
            self.window.rootViewController = lVC;


    }
    else
    {
       

        
        [self.window addSubview:rVC.view];
        self.window.rootViewController = rVC;
        }
    }
    
   // [self.window addSubview:nc.view];
    
    //self.window.rootViewController = self.viewController;
    
    //self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];

    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if pgapp-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {
        return NO;
    }

    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
//    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

// repost the localnotification using the default NSNotificationCenter so multiple plugins may respond
- (void)            application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
   
    //NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) setUserInfo: (NSString*) account Password:(NSString*) password Code:(NSString*) code
{
    [dahanKeyChain setObject:account forKey:(id)kSecAttrAccount];
    [dahanKeyChain setObject:password forKey:(id)kSecValueData];
    [dahanKeyChain setObject:code forKey:(id)kSecAttrDescription];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    NSString* tmpDeviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    //remove <>
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    //remove " "
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"设备Token:%@", deviceTokenStr);
    
    if(deviceTokenStr == nil || [deviceTokenStr isEqualToString:@""])
    {
        //self.deviceApnTokenFailInfo = [NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@", tmpDeviceTokenStr];
    }
    
    self.deviceApnToken = deviceTokenStr;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    //self.deviceApnTokenFailInfo = [NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError: %@", error_str];
//    NSLog(@"获得设备Token失败, 原因:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"接收到推送消息: %@", userInfo);
    //以下情况会被调用
    //1.信息到达时你的app正在前台运行
    //2.在iOS４.０或更新的版本，如果你的app从暂停状态进入前台
    
    
    gNotificationDownloadMsg = TRUE;
    
    /*
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    [[userInfo objectForKey:@"badge"] integerValue];
    */
    NSLog(@"applicationIconBadgeNumber = %d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"大含OA" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"badgeNumberChange" object:self];
    
}

/*
//IOS7.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    
}
*/
@end
