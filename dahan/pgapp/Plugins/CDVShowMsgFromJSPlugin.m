//
//  CDVShowMsgPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-28.
//
//

#import "CDVShowMsgFromJSPlugin.h"

@implementation CDVShowMsgFromJSPlugin

-(void) showMsgFromJS:(CDVInvokedUrlCommand *)command
{
    NSString* msg = [command.arguments objectAtIndex:0];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
   
    av.delegate = self;
    [av show];
}

#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

@end
