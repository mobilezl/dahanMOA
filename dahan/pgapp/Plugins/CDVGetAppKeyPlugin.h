//
//  CDVGetAppKey.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-22.
//
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDVPlugin.h>

@interface CDVGetAppKeyPlugin : CDVPlugin
-(void) getAppKey:(CDVInvokedUrlCommand *)command;
@end
