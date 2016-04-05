//
//  CDVGoBackPlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-28.
//
//


#import <Cordova/CDVPlugin.h>

@interface CDVGoBackFromJSPlugin : CDVPlugin

-(void) goBackFromJS:(CDVInvokedUrlCommand *)command;

@end
