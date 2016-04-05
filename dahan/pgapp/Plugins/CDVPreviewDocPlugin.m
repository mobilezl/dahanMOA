//
//  CDVPreviewDocPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-5-4.
//
//

#import "CDVPreviewDocPlugin.h"
#import "MainViewController.h"
@implementation CDVPreviewDocPlugin

-(void) previewDoc:(CDVInvokedUrlCommand *)command
{
    NSString* docUrl = @"";
    docUrl = [command.arguments objectAtIndex:0];
    
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
    
    mainVC.startPage = docUrl;//@"http://180.173.61.125:25084/file/Backbonejs.pdf";
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:mainVC animated:YES];
    /*
    UIWebView* webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = TRUE;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Apps/notice/ios_Js.xlsx"];
    //"http://180.173.61.125:25084/file/Backbonejs.pdf
    NSURL* myDocUrl = [NSURL fileURLWithPath:path];
    NSURLRequest* myReq = [NSURLRequest requestWithURL:myDocUrl];
    [webView loadRequest:myReq];
    */
}


@end
