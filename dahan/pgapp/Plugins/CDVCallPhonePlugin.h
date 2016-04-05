//
//  CDVCallPhonePlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import <Cordova/CDVPlugin.h>

@interface CDVCallPhonePlugin : CDVPlugin

@property(nonatomic, retain) UIWebView* phoneCallWebView;

-(void) callPhone:(CDVInvokedUrlCommand *)command;
@end
