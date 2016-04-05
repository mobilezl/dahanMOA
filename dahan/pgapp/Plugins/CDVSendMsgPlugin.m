//
//  CDVSendMsgPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import "CDVSendMsgPlugin.h"

@implementation CDVSendMsgPlugin

-(void) sendMsg:(CDVInvokedUrlCommand *)command
{
    NSString* phoneNumber = [command.arguments objectAtIndex:0];
    if(![phoneNumber isEqualToString:@""])
    {
          NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}
@end
