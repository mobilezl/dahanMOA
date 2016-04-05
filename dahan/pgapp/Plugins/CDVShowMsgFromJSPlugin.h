//
//  CDVShowMsgPlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-28.
//
//

#import <Cordova/CDVPlugin.h>

@interface CDVShowMsgFromJSPlugin : CDVPlugin<UIAlertViewDelegate>

-(void) showMsgFromJS:(CDVInvokedUrlCommand *)command;

@end
