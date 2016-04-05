//
//  CDVGetParametersFromIOS.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-26.
//
//
#import "MainViewController.h"
#import "CDVGetParametersFromIOSPlugin.h"
#import "AppDelegate.h"
#import "AppDefine.h"
@implementation CDVGetParametersFromIOSPlugin


-(void) getParametersFromIOS:(CDVInvokedUrlCommand *)command
{
    NSString* pKey = [command.arguments objectAtIndex:0];
    
    //AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* pVal = [gParametersForJS objectForKey:pKey];//[appDelegate.gParametersForJS objectForKey:pKey];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: pVal];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@"get: key:%@ val: %@", pKey, pVal);
}

-(void) getAppKey:(CDVInvokedUrlCommand *)command
{
    
    MainViewController* mainVC = (MainViewController*)self.viewController;
    /*NSDictionary* dic = [NSDictionary dictionaryWithObject:mainVC.appKey forKey:@"AppKey"];
     NSError *parseError = nil;
     NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
     
     NSString* strReslut = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     */
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: mainVC.appKey];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@ "AppKey:%@",mainVC.appKey);
}


@end
