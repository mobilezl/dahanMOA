//
//  CDVGetAppKey.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-22.
//
//

#import "CDVGetAppKeyPlugin.h"
#import "MainViewController.h"
@implementation CDVGetAppKeyPlugin

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
