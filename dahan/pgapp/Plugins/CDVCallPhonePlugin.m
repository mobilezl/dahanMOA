//
//  CDVCallPhonePlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import "CDVCallPhonePlugin.h"
#import "MainViewController.h"
@implementation CDVCallPhonePlugin
@synthesize phoneCallWebView;

-(void) callPhone:(CDVInvokedUrlCommand *)command
{
    /*
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"www"];
    mainVC.wwwFolderName = [@"file://" stringByAppendingString:documentsDirectory];
    mainVC.startPage = @"/Apps/notice/iTunesConnect_DeveloperGuide_CN.pdf";//[appInfo.appLocalUrl substringFromIndex:1];
    [self.viewController.navigationController pushViewController:mainVC animated:YES];
    return;
    */
    NSString* phoneNumber = [command.arguments objectAtIndex:0];
    if(![phoneNumber isEqualToString:@""])
    {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
        
        if(!self.phoneCallWebView)
        {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
        }
        [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
}
@end
