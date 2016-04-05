//
//  CDVUserInfoPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-15.
//
//

#import "CDVUserInfoPlugin.h"
#import "AppDefine.h"
#import "MainViewController.h"
@implementation CDVUserInfoPlugin

@synthesize myWevView;

-(void) getUserInfo:(CDVInvokedUrlCommand *)command
{
    
    NSString* strReslut = nil;
    NSArray* arryKeys = [NSArray arrayWithObjects:@"UserId", @"AuthorizeCode", @"UserName", @"accesc_Token", @"openId", nil];
    NSString* userName = gUserName;
    if([userName isEqual:@""])
    {
        userName = gUserAccout;
    }
        
    NSArray* arryValues = [NSArray arrayWithObjects:gUserAccout, gAuthorizeCode, userName, gAuthorizeCode, gOpenID, nil];
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:arryValues forKeys:arryKeys];
    NSError *parseError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    strReslut = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: strReslut];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@ "%@",strReslut);

    /*
    ((MainViewController*)self.viewController).rightBtn_urlStr = @"Apps/news/www/newsDetail.html";//@"Apps/news/index.html";
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [rightBarBtn setImage:[UIImage imageNamed:@"main_rightBtn.png"] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(clickBarRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 58.0,28.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.viewController.navigationItem.rightBarButtonItem = barBackBtn;
    */
    
     
}

-(void) clickBarRightBtn:(id)sender
{
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    mainVC.wwwFolderName = [@"file://" stringByAppendingString:documentsDirectory];
    //mainVC.startPage = [appInfo.appLocalUrl substringFromIndex:1];
    mainVC.startPage = ((MainViewController*)self.viewController).rightBtn_urlStr; //@"Apps/news/index.html";//[mainVC.startPage stringByReplacingOccurrencesOfString:@"apps" withString:@"Apps"];
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:mainVC animated:YES];
}

@end
