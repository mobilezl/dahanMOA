//
//  CDVUserInfoPlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-15.
//
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDVPlugin.h>

@interface CDVUserInfoPlugin : CDVPlugin

-(void) getUserInfo:(CDVInvokedUrlCommand *)command;

@property (nonatomic, retain) UIWebView* myWevView;
@end
