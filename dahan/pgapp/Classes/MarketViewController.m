//
//  MarketViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-18.
//
//

#import "MarketViewController.h"
#import "MainViewController.h"
#import "AppMarkView.h"
#import "CommonTool.h"
#import "AppDefine.h"
#import "SettingViewController.h"
#import "DBManager.h"
#import "AppInfo.h"
#import "DownloadAppsViewController.h"
#import "MessageViewController.h"
#import "TestWebViewViewController.h"
#import "AppBgPicInfo.h"
#import "NSString+NSString_MD5HexDigest.h"
#import "AppMsgInfo.h"
#import "SBJson.h"
#import "XMLHelper.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "UserInfo.h"


#define PAGE_CONTROL_HEIGHT 20

@interface MarketViewController ()

@end

@implementation MarketViewController

@synthesize myScrollView;
@synthesize myPageControl;
@synthesize welcomeLabel;
@synthesize welcomeImgView;
@synthesize bgView;
@synthesize msgBtn;
@synthesize appBtn;
@synthesize settingBtn;
@synthesize appsList;
@synthesize bgImg;
@synthesize phoneCallWebView;
@synthesize selectedAppID;
@synthesize userInfoView;

//@synthesize mainVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)HideTabBar:(BOOL)hidden{
    
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0];
    
    
    
    
    for(UIView *view in self.tabBarController.view.subviews){
        
        
        if([view isKindOfClass:[UITabBar class]]){   //处理UITabBar视图
            
            if (hidden) {
                
                
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width,							view.frame.size.height)];
                
            } else {
                
                [view setFrame:CGRectMake(view.frame.origin.x, 480-48, view.frame.size.width,					view.frame.size.height)];
                
            }
            
        }else{   //处理其它视图
            
            if (hidden) {
                
                
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,					480)];
                
                
            } else {
                
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,					480-48)];
                
            }
            
        }
        
    }
    
    
    [UIView commitAnimations];
    
}

- (void) hideTabBar1:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, 320, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 320-49, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 320)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 320-49)];
            }
        }
    }
    
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    
    MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];
    
    self.hidesBottomBarWhenPushed = NO;
    vcs.tabBar.hidden = TRUE;
    [vcs hideSegmentButton:FALSE];


    
    if(gStyleType == 1)
    {
        self.navigationController.tabBarController.tabBar.hidden = YES;
        if(![[CommonTool commonToolManager] IS_IOS7])
        {
            [self HideTabBar:YES];
        }

        [self showBnt:YES];
    }
    else
    {
       // self.navigationController.tabBarController.tabBar.hidden = NO;
        [self showBnt:NO];
    }
    
    [self setViewFrame];
    
    if(gNotificationDownloadMsg)
    {
        [self send_PullMessage_Msg];
    }
    else
    {
        self.appsList = [self getAppsList];
        [self addAppMarkViews:self.appsList ShowType:2];
        [self ShowUnMsgNumber];
    }

    self.myPageControl.currentPage = 0;
    
}


- (void) send_PullMessage_Msg
{
    /*
    if(![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
    */
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<PullMessage xmlns=\"http://tempuri.org/\">"
                             "<userID>%@</userID>"
                             "<authorizeCode>%@</authorizeCode>"
                             "</PullMessage>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/PullMessage" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/MsgService.asmx?op=PullMessage", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"PullMessageResponse"] objectForKey:@"PullMessageResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"])
        {
            
            //
            NSMutableArray* muArry = [NSMutableArray arrayWithCapacity:5];
            NSArray* arry =  [strJson objectForKey:@"MsgList"];
            
            for(int i = 0; i < [arry count]; ++i)
            {
                AppMsgInfo* msgInfo = [[AppMsgInfo alloc] init];
                msgInfo.appID = [[arry objectAtIndex:i] objectForKey:@"AppId"];
                msgInfo.appName = [[arry objectAtIndex:i] objectForKey:@"AppName"];
                msgInfo.appKey = [[arry objectAtIndex:i] objectForKey:@"AppKey"];
                msgInfo.appEntry = [[arry objectAtIndex:i] objectForKey:@"AppEntry"];
                msgInfo.msgID = [[arry objectAtIndex:i] objectForKey:@"Id"];
                msgInfo.msgContent = [[arry objectAtIndex:i] objectForKey:@"Message"];
                msgInfo.msgIcon = [[arry objectAtIndex:i] objectForKey:@"MsgIcon"];
                msgInfo.isRead = FALSE;
                
                [muArry addObject:msgInfo];
            }
            if([muArry count] > 0)
            {
                [[DBManager dbManager] executeSaveAppMsgs:muArry];
            }
            
            gNotificationDownloadMsg = FALSE;

            self.appsList = [self getAppsList];
            [self addAppMarkViews:self.appsList ShowType:2];
            [self ShowUnMsgNumber];
        }
        else
        {
            NSString* errorMsg = [[strJson objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        
        NSLog(@"--------------%@", strJson);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
    }];
    [manager.operationQueue addOperation:operation];
    
}


-(void) ShowUnMsgNumber
{
    if(self.selectedAppID == nil || [self.selectedAppID isEqualToString:@""])
    {
        
    }
    else
    {
        [[DBManager dbManager] executeUpdateAppMsgsReadedByAppID:self.selectedAppID];
    }
    
    NSMutableDictionary* muDir = [[DBManager dbManager] executeFindAppUnMsgs];
    //NSArray* keyAll = [muDir allKeys];
    NSArray* arry = self.myScrollView.subviews;
    int totalUnCountMsg = 0;
    for(UIView* view in self.myScrollView.subviews)
    {
        if([[view class] isSubclassOfClass:[AppMarkView class]])
        {
            AppMarkView* appMarkView = (AppMarkView*)view;
            NSString* unCountMsg = [muDir objectForKey:appMarkView.appID];
            totalUnCountMsg += unCountMsg.intValue;
            if([unCountMsg isEqualToString:@""] || unCountMsg == nil)
            {
                appMarkView.updateMarkImgView.hidden = TRUE;
            }
            else
            {
                //appMarkView.markLabel.text = unCountMsg;
                appMarkView.updateMarkImgView.hidden = FALSE;

            }

        }
    }
    
    if(totalUnCountMsg >= 0)
    {
        self.userInfoView.waitingOpView.unMessageNumberLabel.text = [NSString stringWithFormat:@"%d", totalUnCountMsg];
    }
    else
    {
        self.userInfoView.waitingOpView.unMessageNumberLabel.text = [NSString stringWithFormat:@"0%d", totalUnCountMsg];
    }
    
    self.userInfoView.waitingOpView.daibanLabel.text = @"待办";

}
- (void)viewDidLoad
{
    [super viewDidLoad];


    
    
    // Do any additional setup after loading the view from its nib.
    //gStyleType = 1;
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
                                                                    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /*
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line_w.png"]];
    }
    
    /*
    CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect1.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context1, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
    CGContextFillRect(context1, rect1);
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];
    [vcs.tabBar setBackgroundImage:image1];
    
    [vcs.tabBar setShadowImage:[UIImage imageNamed:@"line_w.png"]];//隐藏那条黑线
    */
    
    NSDate * seldate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: seldate];
    NSDate * date = [seldate dateByAddingTimeInterval: interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"HH"];
    
    int curHour =  [[formatter stringFromDate: date] intValue];
    if(curHour < 12)
    {
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@,上午好", gUserName];
    }
    else if(curHour >= 12 && curHour < 18)
    {
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@,下午好", gUserName];
    }
    else
    {
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@,晚上好", gUserName];
    }
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
      self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 300.0)];
    }else{
     self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 160.0)];
    }
//    self.userInfoView.layer.borderWidth=5;
//    self.userInfoView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
//    
    self.userInfoView.strUrl = @"";
    /*self.userInfoView.userNameLabel_CH.text = @"张家驹";
    self.userInfoView.userNameLabel_EN.text = @"Beyon";
    self.userInfoView.userPostLabel.text = @"资深设计师";
    self.userInfoView.unMessageNumberLabel.text = @"09";
    self.userInfoView.daibanLabel.text = @"待办";
     */
    self.userInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.userInfoView];
    
    [self send_UserDevicetoken_Msg];
    //[self getAppBgPic];
    self.bgImg = [[CommonTool commonToolManager] getAppBgPic];
    [self initViews];
    
    [self send_GetWaitApprovalCount_Msg];
    [self send_GetUserInfo_Msg];
    
}

-(void) getAppBgPic
{
    AppBgPicInfo* appBgPicInfo = [[DBManager dbManager] getSelecedAppBgPicInfo];
    NSString* bgPicUrl = appBgPicInfo.appBgPicUrl;
    bgPicUrl = @"";
    if([bgPicUrl isEqualToString:@""] || [bgPicUrl isEqualToString:@"defaultBgPic"])
    {
        self.bgImg = [UIImage imageNamed:@"main_bg.png"];
    }
    else
    {
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        
        NSString *imageType = @"png";
        //从url中获取图片类型
        　　NSMutableArray *arr = (NSMutableArray *)[bgPicUrl componentsSeparatedByString:@"."];
        if (arr) {
            imageType = [arr objectAtIndex:arr.count-1];
        }
        NSString* filePath = [docPath stringByAppendingPathComponent:@"dahanPic"];
        NSString* md5StrUrl = [[[bgPicUrl md5HexDigest] stringByAppendingString:@"."] stringByAppendingString:imageType];
        filePath = [filePath stringByAppendingPathComponent:md5StrUrl];
        
        self.bgImg = [UIImage imageWithContentsOfFile:filePath];
    }

}
-(void) setViewFrame
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        CGRect frame = CGRectMake(0.0, 0.0, 768.0, 1024.0);
        // return;
        // [self getAppBgPic];
        self.bgImg = [[CommonTool commonToolManager] getAppBgPic];
        float addHeight = 0.0;
        //self.myPageControl.layer.borderWidth = 2;
        // self.myPageControl.layer.borderColor = [UIColor blackColor].CGColor;
        if([[CommonTool commonToolManager] IS_IOS7])
        {
            if(IS_IPHONE_5)
            {
                if(gStyleType == 0)
                {
                    // myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0+88.0, 320.0, 20.0);
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0, 320.0, 20.0);
                }
                else if(gStyleType == 1)
                {
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT+88.0, 320.0, 20.0);
                }
            }
            else
            {
                if(gStyleType == 0)
                {
                    //myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0, 320.0, 20.0);
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-60-20.0-48.0, 768.0, 20.0);
                }
                else if(gStyleType == 1)
                {
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT, 320.0, 20.0);
                }
            }
            
            addHeight = 64.0;
            //self.view.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight-addHeight, frame.size.width, frame.size.height-64.0);
            // frame = CGRectMake(0, 24, 320, 436);
            if(gStyleType == 0)
            {
                // self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width, frame.size.height-64.0-44.0-64.0-20.0);
                if(IS_IPHONE_5)
                {
                    self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+130.0+60.0, frame.size.width, 180.0);
                }
                else
                {
                    //appview
                    self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+330.0+20.0, frame.size.width, 480.0);
                }
                
            }
            else if(gStyleType ==1)
            {
                self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width-180.0, frame.size.height-64.0);
            }
            
        }
        else
        {
            if(gStyleType == 0)
            {
                myPageControl.frame = CGRectMake(0.0, 348, 320.0, 20.0);
            }
            else if(gStyleType ==1)
            {
                myPageControl.frame = CGRectMake(0.0, 348+44.0+8.0, 320.0, 20.0);
            }
        }
        
        //frame = self.view.frame;
        
        //self.bgView = [[UIView alloc] init];
        if(gStyleType == 0)
        {
            
            if([[CommonTool commonToolManager] IS_IOS7])
            {
                //self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0);
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-64.0-44.0-5.0);
            }
            else
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height);
            }
        }
        else if(gStyleType == 1)
        {
            if([[CommonTool commonToolManager] IS_IOS7])
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height);
            }
            else
            {
                
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+64.0);
            }
        }
        
        UIImage* bg = nil;
        if(IS_IPHONE_5)
        {
            if(gStyleType == 0)
            {
                //self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0+88.0);
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0+10.0);
            }
            else if(gStyleType == 1)
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0);
            }
            
            if(gStyleType == 0)
            {
                bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+88.0)];
            }
            else if(gStyleType == 1)
            {
                bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+88.0+44.0)];
            }
        }
        else
        {
            if(gStyleType == 0)
            {
                if([[CommonTool commonToolManager] IS_IOS7])
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0)];
                }
                else
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0+10.0+10.0)];
                }
                
                
                
            }
            else if(gStyleType == 1)
            {
                if([[CommonTool commonToolManager] IS_IOS7])
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+44.0)];
                }
                else
                {
                    
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-44.0+10.0+10.0+44.0)];
                }
                
                
                
            }
        }
        self.bgView.layer.contents = (id)bg.CGImage;

    }else{
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
        // return;
        // [self getAppBgPic];
        self.bgImg = [[CommonTool commonToolManager] getAppBgPic];
        float addHeight = 0.0;
        //self.myPageControl.layer.borderWidth = 2;
        // self.myPageControl.layer.borderColor = [UIColor blackColor].CGColor;
        if([[CommonTool commonToolManager] IS_IOS7])
        {
            if(IS_IPHONE_5)
            {
                if(gStyleType == 0)
                {
                    // myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0+88.0, 320.0, 20.0);
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0, 320.0, 20.0);
                }
                else if(gStyleType == 1)
                {
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT+88.0, 320.0, 20.0);
                }
            }
            else
            {
                if(gStyleType == 0)
                {
                    //myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0, 320.0, 20.0);
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-60-20.0-48.0, 320.0, 20.0);
                }
                else if(gStyleType == 1)
                {
                    myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT, 320.0, 20.0);
                }
            }
            
            addHeight = 64.0;
            //self.view.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight-addHeight, frame.size.width, frame.size.height-64.0);
            // frame = CGRectMake(0, 24, 320, 436);
            if(gStyleType == 0)
            {
                // self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width, frame.size.height-64.0-44.0-64.0-20.0);
                if(IS_IPHONE_5)
                {
                    self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+130.0+60.0, frame.size.width, 180.0);
                }
                else
                {
                    self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+130.0+20.0, frame.size.width, 180.0);
                }
                
            }
            else if(gStyleType ==1)
            {
                self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width-80.0, frame.size.height-64.0);
            }
            
        }
        else
        {
            if(gStyleType == 0)
            {
                myPageControl.frame = CGRectMake(0.0, 348, 320.0, 20.0);
            }
            else if(gStyleType ==1)
            {
                myPageControl.frame = CGRectMake(0.0, 348+44.0+8.0, 320.0, 20.0);
            }
        }
        
        //frame = self.view.frame;
        
        //self.bgView = [[UIView alloc] init];
        if(gStyleType == 0)
        {
            
            if([[CommonTool commonToolManager] IS_IOS7])
            {
                //self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0);
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-64.0-44.0-5.0);
            }
            else
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height);
            }
        }
        else if(gStyleType == 1)
        {
            if([[CommonTool commonToolManager] IS_IOS7])
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height);
            }
            else
            {
                
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+64.0);
            }
        }
        
        UIImage* bg = nil;
        if(IS_IPHONE_5)
        {
            if(gStyleType == 0)
            {
                //self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0+88.0);
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0+10.0);
            }
            else if(gStyleType == 1)
            {
                self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0);
            }
            
            if(gStyleType == 0)
            {
                bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+88.0)];
            }
            else if(gStyleType == 1)
            {
                bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+88.0+44.0)];
            }
        }
        else
        {
            if(gStyleType == 0)
            {
                if([[CommonTool commonToolManager] IS_IOS7])
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0)];
                }
                else
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0+10.0+10.0)];
                }
                
                
                
            }
            else if(gStyleType == 1)
            {
                if([[CommonTool commonToolManager] IS_IOS7])
                {
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+44.0)];
                }
                else
                {
                    
                    bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-44.0+10.0+10.0+44.0)];
                }
                
                
                
            }
        }
        self.bgView.layer.contents = (id)bg.CGImage;

    }
    
}
-(void) showBnt:(BOOL) show
{
    if(show)
    {
        self.msgBtn.hidden = NO;
        self.appBtn.hidden = NO;
        self.settingBtn.hidden = NO;
        
        [self.appBtn setImage:[UIImage imageNamed:@"main_app_highlighted.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.msgBtn.hidden = YES;
        self.appBtn.hidden = YES;
        self.settingBtn.hidden = YES;
    }
}
-(void) initViews
{
    CGRect frame = self.view.frame;
    
    self.myPageControl = [[UIPageControl alloc] init];
    self.myPageControl.enabled = FALSE;
    self.myPageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.myPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.myPageControl.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    //self.myPageControl.layer.opacity = 0.1;
     //self.myPageControl.layer.borderWidth = 2;
    // self.myPageControl.layer.borderColor = [UIColor greenColor].CGColor;
    
    [myPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:myPageControl];
    
   // self.myScrollView.layer.borderColor = [UIColor redColor].CGColor;
   // self.myScrollView.layer.borderWidth = 2;
    
    frame = self.view.frame;
    float addHeight = 0.0;
    if([[CommonTool commonToolManager] IS_IOS7])
    {
        if(IS_IPHONE_5)
        {
            if(gStyleType == 0)
            {
                myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0+88.0, 320.0, 20.0);
            }
            else if(gStyleType == 1)
            {
                myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT+88.0, 320.0, 20.0);
            }
            
        }
        else
        {
            if(gStyleType == 0)
            {
                myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT-44.0, 320.0, 20.0);
            }
            else if(gStyleType == 1)
            {
                myPageControl.frame = CGRectMake(0.0, frame.size.height-PAGE_CONTROL_HEIGHT, 320.0, 20.0);
            }
        }
        
        CGRect r = self.welcomeLabel.frame;
        self.welcomeLabel.frame = CGRectMake(r.origin.x, r.origin.y+64.0, r.size.width, r.size.height);
        r = self.welcomeImgView.frame;
        self.welcomeImgView.frame = CGRectMake(r.origin.x, r.origin.y+64.0, r.size.width, r.size.height);
        self.automaticallyAdjustsScrollViewInsets = NO;
        addHeight = 64.0;
        //self.view.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width, frame.size.height-64.0);
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

        frame = self.myScrollView.frame;
        //self.myScrollView.layer.borderWidth = 2;
        //self.myScrollView.layer.borderColor = [UIColor redColor].CGColor;
        
        if(gStyleType == 0)
        {
            self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width, frame.size.height-64.0-44.0);
        }
        else if(gStyleType ==1)
        {
            self.myScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y+addHeight, frame.size.width-80.0, frame.size.height-64.0);
        }
        
    }
    else
    {
        if(gStyleType == 0)
        {
            myPageControl.frame = CGRectMake(0.0, 348, 320.0, 20.0);
        }
        else if(gStyleType ==1)
        {
            myPageControl.frame = CGRectMake(0.0, 348+44.0, 320.0, 20.0);
        }
    }
    
   // [self addAppMarkViews:nil ShowType:2];
   // self.view.layer.borderColor = [UIColor blueColor].CGColor;
  //  self.view.layer.borderWidth = 2;
     frame = self.view.frame;
   // return;
    UIImage* bg = nil;
    frame = self.view.frame;
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView];
   // self.bgView.layer.borderColor = [UIColor greenColor].CGColor;
   // self.bgView.layer.borderWidth = 1;
    if(gStyleType == 0)
    {
        self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0-64.0);
    }
    else if(gStyleType == 1)
    {
        self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height);
    }
    
    if(IS_IPHONE_5)
    {
        if(gStyleType == 0)
        {
            //self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height-44.0+88.0);
            self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0);
        }
        else if(gStyleType == 1)
        {
            self.bgView.frame = CGRectMake(0.0, frame.origin.y, frame.size.width, frame.size.height+88.0);
        }
        
        if(gStyleType == 0)
        {
            bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+88.0)];

        }
        else if(gStyleType == 1)
        {
            bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0,self.bgView.frame.size.height)];
        }
    }
    else
    {
        if(gStyleType == 0)
        {
            bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0)];
           
        }
        else if(gStyleType == 1)
        {
            bg = [self reSizeImage:self.bgImg toSize:CGSizeMake(320.0, self.view.bounds.size.height-PAGE_CONTROL_HEIGHT-64.0-44.0+10.0+10.0+44.0)];
        }
    }
    

    [self.view sendSubviewToBack:self.bgView];
    
    self.bgView.layer.contents = (id)bg.CGImage;
    
}
-(IBAction) changePage:(id)sender
{
    int i = (int)((UIPageControl*)sender).currentPage;
    
    CGRect frame = self.myScrollView.frame;
    frame.origin.x = frame.size.width * self.myPageControl.currentPage;
    [self.myScrollView scrollRectToVisible:frame animated:YES];
}

-(AppInfo*) getLocalApp:(NSString*) appName AppID:(NSString*) appID AppLocalUrl:(NSString*) appLocalUrl AppIconUrl:(NSString*) appIconUrl AppIndex:(int)appIndex
{
    AppInfo* appInfo = [[AppInfo alloc] init];
    appInfo.appID = appID;
    appInfo.appName = appName;
    appInfo.appLocalUrl = appLocalUrl;
    appInfo.appIconUrl = appIconUrl;
    appInfo.homeIcon = appIconUrl;
    appInfo.appDes = @"";
    appInfo.appSize = 1.0;
    appInfo.appType = 1;
    appInfo.appVersion = @"1.0";
    appInfo.appAuthoriy = @"1.0";
    appInfo.appIndex = appIndex;
    appInfo.appDownLoadUrl = @"";
    appInfo.appSatate = 1;
    appInfo.pgComPkgVer = @"";
    
    return appInfo;
}
-(NSArray*) getLocalAppsList
{
    NSMutableArray* muArry = [[NSMutableArray alloc] initWithCapacity:5];
    
    AppInfo* appInfo = [self getLocalApp:@"新闻" AppID:@"xinwen" AppLocalUrl:@"/apps/news/index.html" AppIconUrl:@"xinwen" AppIndex:0];
    [muArry addObject:appInfo];
    
    appInfo = [self getLocalApp:@"公告" AppID:@"gonggao" AppLocalUrl:@"/apps/notice/index.html" AppIconUrl:@"gonggao" AppIndex:1];
    [muArry addObject:appInfo];
    
    appInfo = [self getLocalApp:@"流程发起" AppID:@"liuchengfaqi" AppLocalUrl:@"/apps/launch/index.html" AppIconUrl:@"liuchengfaqi" AppIndex:2];
    [muArry addObject:appInfo];

    appInfo = [self getLocalApp:@"流程跟踪" AppID:@"liuchenggenzong" AppLocalUrl:@"/apps/follow/index.html" AppIconUrl:@"liuchenggenzong" AppIndex:3];
    [muArry addObject:appInfo];
    
    appInfo = [self getLocalApp:@"报表" AppID:@"baobiao" AppLocalUrl:@"/apps/RGraph/index.html" AppIconUrl:@"baobiao" AppIndex:4];
    [muArry addObject:appInfo];
    
    
    return  muArry;
    

}
-(NSArray*) getAppsList
{
    NSMutableArray* muArry = [[NSMutableArray alloc] initWithCapacity:5];
    muArry = [[DBManager dbManager] executeFindAppInfos];
    
    if([muArry count] == 0 )
    {
         //增加本地预装的APP
        [muArry addObjectsFromArray: [self getLocalAppsList]];
        [[DBManager dbManager] executeSaveAppInfos:muArry];
        [muArry removeAllObjects];
        muArry = [[DBManager dbManager] executeFindAppInfos];
    }
    

    
    int index = 0;
    if([muArry count] == 0)
    {
       
        
        index = 1;
    }
    else
    {
        index = [muArry count] + 1;
    }
    
    AppInfo* appInfo = [[AppInfo alloc] init];
    appInfo.appID = @"addApps";
    appInfo.appIconUrl = @"add.png";
    appInfo.homeIcon = @"add.png";
    appInfo.appName = @"更多";
    appInfo.appLocalUrl = @"";
    appInfo.appType = @"";
    appInfo.appVersion = @"";
    appInfo.appIndex = index;

    [muArry addObject:appInfo];
    
    return muArry;
}
-(void) addAppMarkViews:(NSArray*) apps ShowType:(int) type
{
    NSArray* arry = self.myScrollView.subviews;
    for(int i = 0; i < arry.count; ++i)
    {
        if([[arry objectAtIndex:i] isKindOfClass:[AppMarkView class]])
        {
            [((AppMarkView*)[arry objectAtIndex:i]) removeFromSuperview];
        }
    }
    //已安装的应用数量
    int totalCounts = apps.count;
    
    int columnCounts = 0;
    
    int totalPages = 0;
    
    //totalCounts = 41;
    type = 2;
    //每列数量
    int numberPerLine = 0;
    int addOneline = 0;
    int linesPerPage = 0;//每页多少行
    int countsPerLine = 3;
    int countsPerPage = 6;
    if(gStyleType == 0)
    {
         if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
             countsPerLine = 4;
             if(IS_IPHONE_5)
             {
                 countsPerPage = 6;
                 linesPerPage = 2;
             }
             else
             {
                 countsPerPage = 8;
                 linesPerPage = 2;
             }

         }else{
             countsPerLine = 3;
             if(IS_IPHONE_5)
             {
                 countsPerPage = 6;
                 linesPerPage = 2;
             }
             else
             {
                 countsPerPage = 6;
                 linesPerPage = 2;
             }

         }
          }
    else
    {
        countsPerLine = 3;
        if(IS_IPHONE_5)
        {
            countsPerPage = 6;
            linesPerPage = 2;
        }
        else
        {
            countsPerPage = 6;
            linesPerPage = 2;
        }
    }
    
    numberPerLine = countsPerLine;
    columnCounts = totalCounts / countsPerLine;
    addOneline = totalCounts % countsPerLine;
    if(addOneline > 0)
    {
        columnCounts++;
    }
    totalPages = totalCounts / countsPerPage;
    int addPage = totalCounts % countsPerPage;
    if(addPage > 0)
    {
        totalPages++;
    }
    int pageWith;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
     pageWith = 768;
    }else{
    pageWith = 320;
    }
    if(gStyleType == 1)
    {
        pageWith = 240;
    }
    
    if(totalPages == 1)
    {
        self.myPageControl.hidden = TRUE;
        
    }
    else
    {
        self.myPageControl.hidden = FALSE;
        self.myPageControl.numberOfPages = totalPages;
        self.myPageControl.currentPage = 0;
    }

    self.myScrollView.contentSize = CGSizeMake(pageWith*totalPages, self.myScrollView.contentSize.height);
    
    int index = 0;
    int curPage = 0;
  
    for(int i = 0; i < columnCounts; ++i)
    {
        for(int j = 0; j < numberPerLine;++j)
        {
            
            
           // AppMarkView* appMarkView = [[AppMarkView alloc] initWithFrame:CGRectMake(curPage*pageWith + 80.0*(j%numberPerLine), (68.0+14.0)*(i%linesPerPage)+2.0, 80.0, 68.0)];
            AppMarkView* appMarkView;
             if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                 appMarkView = [[AppMarkView alloc] initWithFrame:CGRectMake(curPage*pageWith + 166.3*(j%numberPerLine), (118.0+44.0)*(i%linesPerPage)+2.0, 216.3, 68.0)];
                }else{
                    appMarkView = [[AppMarkView alloc] initWithFrame:CGRectMake(curPage*pageWith + 106.3*(j%numberPerLine), (68.0+24.0)*(i%linesPerPage)+2.0, 106.3, 68.0)];
             }
             //appMarkView.layer.borderWidth = 2.0;
             //appMarkView.layer.borderColor = [UIColor blackColor].CGColor;
           // appMarkView.backgroundColor = [UIColor orangeColor];
            
            
            AppInfo* appInfo = [apps objectAtIndex:index];
            appMarkView.appLabel.text = appInfo.appName;
            appMarkView.appID = appInfo.appID;
            appMarkView.strUrl = appInfo.homeIcon;
            appMarkView.myDelegate = self;
            
            [self.myScrollView addSubview:appMarkView];
            
            index++;
            if((index % countsPerPage) == 0)
            {
                curPage++;
            }
            else if(index == totalCounts)
            {
                return;
            }
        }
    }
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
                                
}
                                
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGSize s = reSizeImage.size;
    return reSizeImage;
    
}
                                
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotoWebBtn:(id)sender
{
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
    mainVC.useSplashScreen = false;
    //mainVC.startPage = @"index.html";
    //[self presentViewController:mainVC animated:YES completion:NULL];
    [self.navigationController pushViewController:mainVC animated:YES];
}

-(IBAction)clickMsgBtn:(id)sender
{
    MessageViewController* msgVC = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    msgVC.title = @"消息中心";
    [self.navigationController pushViewController:msgVC animated:YES];
}
-(IBAction)clickAppBtn:(id)sender
{
    
}
-(IBAction)clickSettingBtn:(id)sender
{
    SettingViewController* settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    settingVC.title = @"设置";
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
}


#pragma mark AppMarkViewDelegate methods

-(void) clickAppMarkView:(NSString *)appid
{
    
    
    if([appid isEqualToString:@"addApps"])
    {

        //安装应用,进入到应用下载界面
        DownloadAppsViewController* dlAppsVC = [[DownloadAppsViewController alloc] initWithNibName:@"DownloadAppsViewController" bundle:nil];
        dlAppsVC.title = @"应用市场";
        
        MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];

       // [vcs hideBottomBar:YES];
        
        [vcs hideSegmentButton:YES];
        self.hidesBottomBarWhenPushed = YES;
        vcs.tabBar.hidden = NO;
        [self.navigationController pushViewController:dlAppsVC animated:YES];
        
    }
    else
    {
        
        for(int i = 0; i < self.appsList.count; ++i)
        {
            AppInfo* appInfo = [self.appsList objectAtIndex:i];
            if([appInfo.appID isEqualToString:appid])
            {
                self.selectedAppID = appid;
                
                MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                
                if([appid isEqualToString:@"xinwen"]
                   ||
                   [appid isEqualToString:@"gonggao"]
                   ||
                   [appid isEqualToString:@"liuchenggenzong"]
                   ||
                   [appid isEqualToString:@"liuchengfaqi"]
                   ||
                   [appid isEqualToString:@"baobiao"]
                   )
                {
                    //mainVC.bFixedApp = TRUE;
                    mainVC.startPage = [appInfo.appLocalUrl substringFromIndex:1];;
                }
                else
                {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"www"];
                    mainVC.wwwFolderName = [@"file://" stringByAppendingString:documentsDirectory];
                    mainVC.startPage = [appInfo.appLocalUrl substringFromIndex:1];
                    mainVC.startPage = [mainVC.startPage stringByReplacingOccurrencesOfString:@"apps" withString:@"Apps"];
                }
               
  
                NSLog(@"startPage=%@", mainVC.startPage);
                MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];

                [vcs hideSegmentButton:YES];
                
                self.hidesBottomBarWhenPushed = YES;
                vcs.tabBar.hidden = NO;
                
                [self.navigationController pushViewController:mainVC animated:YES];
                
                break;
            }
        }
    }
}

-(void) send_UserDevicetoken_Msg
{
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.deviceApnToken == nil || [appDelegate.deviceApnToken isEqualToString:@""])
    {
        return;
    }
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SaveUserDevicetoken xmlns=\"http://tempuri.org/\">"
                             "<argLoginUser>%@</argLoginUser>"
                             "<argDevicetoken>%@</argDevicetoken>"
                             "<argRemarks></argRemarks>"
                             "<argIsDelete>0</argIsDelete>"
                             "</SaveUserDevicetoken>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, appDelegate.deviceApnToken];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/SaveUserDevicetoken" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=SaveUserDevicetoken", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"SaveUserDevicetokenResponse"] objectForKey:@"SaveUserDevicetokenResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
    }];
    [manager.operationQueue addOperation:operation];
    
}


-(void) send_GetUserInfo_Msg
{
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetUserInfo xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "</GetUserInfo>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode, gOpenID];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetUserInfo" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=GetUserInfo", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetUserInfoResponse"] objectForKey:@"GetUserInfoResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* userInfos = [strJson objectForKey:@"UserInfo"];
            
            gUserInfo = [[UserInfo alloc] init];
            for(int i = 0; i < userInfos.count; ++i)
            {
                gUserInfo.userName = [[userInfos objectAtIndex:i] objectForKey:@"UserName"];
                gUserInfo.userID = [[userInfos objectAtIndex:i] objectForKey:@"UserId"];
                gUserInfo.userEmail = [[userInfos objectAtIndex:i] objectForKey:@"Email"];
                gUserInfo.userIM = [[userInfos objectAtIndex:i] objectForKey:@"IM"];
                gUserInfo.userPhone = [[userInfos objectAtIndex:i] objectForKey:@"Phone"];
                gUserInfo.userPositionName = [[userInfos objectAtIndex:i] objectForKey:@"PositionName"];
                gUserInfo.userTel = [[userInfos objectAtIndex:i] objectForKey:@"Tele"];
                gUserInfo.userHeadImgUrl = [[userInfos objectAtIndex:i] objectForKey:@"Portrait"];

            }
        }
        
        self.userInfoView.userNameLabel_CH.text = gUserInfo.userName;
        self.userInfoView.userNameLabel_EN.text = gUserInfo.userID;
        self.userInfoView.userPostLabel.text = gUserInfo.userPositionName;
        self.userInfoView.strUrl = gUserInfo.userHeadImgUrl;
        self.userInfoView.waitingOpView.myDelegate = self;
        
       // self.userInfoView.unMessageNumberLabel.text = @"09";
       // self.userInfoView.daibanLabel.text = @"待办";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
    }];
    [manager.operationQueue addOperation:operation];
    
}

-(void) send_GetWaitApprovalCount_Msg
{
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetWaitApprovalCount xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "</GetWaitApprovalCount>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode, gOpenID];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetWaitApprovalCount" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/ResourceService.asmx?op=GetWaitApprovalCount", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetWaitApprovalCountResponse"] objectForKey:@"GetWaitApprovalCountResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            int recordNum = [[strJson objectForKey:@"RecordNum"] integerValue];
            if(recordNum >= 0)
            {
               // self.userInfoView.waitingOpView.unMessageNumberLabel.text = [NSString stringWithFormat:@"%d", recordNum];
            }
            else
            {
               // self.userInfoView.waitingOpView.unMessageNumberLabel.text = [NSString stringWithFormat:@"0%d", recordNum];
            }
            
            self.userInfoView.waitingOpView.daibanLabel.text = @"待办";

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
    }];
    [manager.operationQueue addOperation:operation];
    
}

#pragma WaitingOpViewDelegate motheds
- (void)clickWaitingOpView
{
    MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];
    
    [vcs hideSegmentButton:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    vcs.tabBar.hidden = NO;
    
    MessageViewController* msgVC = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    msgVC.title = @"消息中心";
    [self.navigationController pushViewController:msgVC animated:YES];

}
@end
