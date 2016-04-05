//
//  CDVSendMsgPlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import <Cordova/CDVPlugin.h>


@interface CDVSendMsgPlugin : CDVPlugin

-(void) sendMsg:(CDVInvokedUrlCommand *)command;
@end
