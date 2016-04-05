//
//  CDVGetParametersFromIOS.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-26.
//
//

#import <Cordova/CDVPlugin.h>

@interface CDVGetParametersFromIOSPlugin : CDVPlugin

-(void) getParametersFromIOS:(CDVInvokedUrlCommand *)command;
-(void) getAppKey:(CDVInvokedUrlCommand *)command;
@end
