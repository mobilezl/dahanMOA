//
//  CDVSetWebTitlePlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-22.
//
//

#import "CDVSetNavTitleByWebTitlePlugin.h"

@implementation CDVSetNavTitleByWebTitlePlugin
-(void) setNavTitleByWebTitle:(CDVInvokedUrlCommand *)command
{
    NSString *theTitle= [command.arguments objectAtIndex:0];

    //[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //设置标题
    if([theTitle isEqualToString:@""] || theTitle == nil)
    {
        
    }
    else
    {
        //self.viewController.title = theTitle;
    }

}
@end
