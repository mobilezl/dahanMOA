//
//  CDVGoBackPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-28.
//
//

#import "CDVGoBackFromJSPlugin.h"

@implementation CDVGoBackFromJSPlugin

-(void) goBackFromJS:(CDVInvokedUrlCommand *)command
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}
@end
