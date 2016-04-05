//
//  CDVSetBarRightBtnPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-5-19.
//
//

#import "CDVSetBarRightBtnPlugin.h"
#import "AppDefine.h"
#import "MainViewController.h"

@implementation CDVSetBarRightBtnPlugin

-(void) setBarRightBtn:(CDVInvokedUrlCommand *)command
{

    NSString* strTitle = @"";
    strTitle = [command.arguments objectAtIndex:0];
    NSString* url = @"Apps";
    url = [url stringByAppendingPathComponent:[command.arguments objectAtIndex:1]];
    
    ((MainViewController*)self.viewController).rightBtn_urlStr = url;
    
    if([strTitle isEqualToString:@""])
    {
        strTitle = @"进入";
    }
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [rightBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarBtn setTitle:strTitle forState:UIControlStateNormal];
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"nav_smallbtn.png"] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(clickBarRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 58.0,28.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.viewController.navigationItem.rightBarButtonItem = barBackBtn;
    
    /*
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [rightBarBtn setImage:[UIImage imageNamed:@"nav_smallbtn.png"] forState:UIControlStateNormal];
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
    mainVC.startPage = ((MainViewController*)self.viewController).rightBtn_urlStr;
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:mainVC animated:YES];
     
}



@end
