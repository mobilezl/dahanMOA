//
//  CDVSendEmailPlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import <Cordova/CDVPlugin.h>
#import "MessageUI/MFMailComposeViewController.h"

@interface CDVSendEmailPlugin : CDVPlugin<MFMailComposeViewControllerDelegate>

-(void) sendEmail:(CDVInvokedUrlCommand *)command;

@end
