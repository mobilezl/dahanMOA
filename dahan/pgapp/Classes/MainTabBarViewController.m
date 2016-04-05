//
//  MainTabBarViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-18.
//
//

#import "MainTabBarViewController.h"
#import "MarketViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
#import "CommonTool.h"
#import "SegmentedButton.h"
#import "AppDefine.h"
#import "WorkFlowViewController.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "SalaryLoginViewController.h"

@interface MainTabBarViewController (){
    NSInteger _defauleBadgeNumber;
}

@end

@implementation MainTabBarViewController

@synthesize settingBarItem;
@synthesize segmentedBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ////获取用户信息
//                [self send_GetUserInfo_Msg];
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBar.hidden = YES;
//    _defauleBadgeNumber=10;
//
//    [self.segmentedBtn setItemBadgeNumber:_defauleBadgeNumber];
    
    //  [self hideSegmentButton:NO];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
    
    [self initSegmentedButton];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"----gUserPassword------%@",gUserPassword);
    // Do any additional setup after loading the view from its nib.
//    MarketViewController* marketVC = [[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil];
//    marketVC.title = @"移动办公平台";

    
       WorkFlowViewController* marketVC = [[WorkFlowViewController alloc] initWithNibName:@"WorkFlowViewController" bundle:nil];
    marketVC.title = @"流程待办";
    
    UINavigationController* navMarketVC = [[UINavigationController alloc] initWithRootViewController:marketVC];
    
    UITabBarItem* tabBarItem_Market = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"main_app.png" ] selectedImage:[UIImage imageNamed:@"main_app_sel.png" ]];
    [tabBarItem_Market setTag:0];
    // marketVC.myDelegate = self;
    [navMarketVC setTabBarItem:tabBarItem_Market];
    navMarketVC.tabBarController.tabBar.delegate = self;
    
    //流程
    
    SalaryLoginViewController* lc = [[SalaryLoginViewController alloc] initWithNibName:@"SalaryLoginViewController" bundle:nil];
    lc.title = @"查看工资";
//    [self.navigationController pushViewController:aboutDHVC animated:YES];
    
    
//    MainViewController* lc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//    lc.title = @"流程";
    UINavigationController* navlc = [[UINavigationController alloc] initWithRootViewController:lc];
//    lc.bFixedApp = TRUE;
//    lc.startPage = @"apps/approval/index.html";
    
    
    UITabBarItem* tabBarItem_lc = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"Salary.png" ] selectedImage:[UIImage imageNamed:@"Salary_sel.png" ]];
    [tabBarItem_lc setTag:1];
    
    [navlc setTabBarItem:tabBarItem_lc];
    navlc.tabBarController.tabBar.delegate = self;
    
    
    //通讯录
    MainViewController* txl = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    txl.title = @"通讯录";
    UINavigationController* navtxl = [[UINavigationController alloc] initWithRootViewController:txl];
    txl.bFixedApp = TRUE;
    txl.bRightTongxunluBtn = TRUE;
    txl.startPage = @"apps/contact/index.html";
    UITabBarItem* tabBarItem_txl = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tongxunlu.png" ] selectedImage:[UIImage imageNamed:@"tongxunlu_sel.png" ]];
    [tabBarItem_txl setTag:2];
    
    [navtxl setTabBarItem:tabBarItem_txl];
    navtxl.tabBarController.tabBar.delegate = self;
    
    
    SettingViewController* settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    settingVC.title = @"设置";
    UINavigationController* navSettingVC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    UITabBarItem* tabBarItem_Setting = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"main_setting.png" ] selectedImage:[UIImage imageNamed:@"main_setting_sel.png" ]];
    
    [tabBarItem_Setting setTag:3];
    
    [navSettingVC setTabBarItem:tabBarItem_Setting];
    self.settingBarItem = tabBarItem_Setting;
    
    /*
     MessageViewController* messageVC = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
     messageVC.title = @"消息";
     UINavigationController* navMessageVC = [[UINavigationController alloc] initWithRootViewController:messageVC];
     UITabBarItem* tabBarItem_Message = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"main_message.png" ] tag:0];
     
     [navMessageVC setTabBarItem:tabBarItem_Message];
     */
    
    NSArray* arry = [NSArray arrayWithObjects:navMarketVC, navlc, navSettingVC, nil];
    [self setViewControllers:arry animated:YES];
    self.selectedIndex = 0;
    
    
    [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    
    /*
     CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
     UIGraphicsBeginImageContext(rect1.size);
     CGContextRef context1 = UIGraphicsGetCurrentContext();
     CGContextSetFillColorWithColor(context1, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
     CGContextFillRect(context1, rect1);
     UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     */
    UIImage* image1 = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.tabBar setBackgroundImage:image1];
    

    [self.tabBar setShadowImage:[UIImage imageNamed:@"line_w.png"]];//隐藏那条黑线
    
    //self.tabBar.appearance
    //self.tabBar.backgroundColor = [UIColor blueColor];
    //[self.tabBar setTintColor: [UIColor blueColor]];
    //[self.tabBarController.tabBar setTintColor:[UIColor blueColor] ];
    //self.tabBar.alpha = 0.1;
    //navMarketVC.tabBarController.tabBar.hidden = YES;
    //navMarketVC.tabBarController.view.frame = CGRectZero;
    
    [self initSegmentedButton];
    
    UIImage* bgImg = [[CommonTool commonToolManager] getAppMenuBarBgPic];
    [self.tabBar setBackgroundImage:bgImg];
    self.tabBar.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITabBarDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    return;
    switch (item.tag)
    {
        case 0:
            break;
        case 1:
        {
            /*
             CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
             UIGraphicsBeginImageContext(rect1.size);
             CGContextRef context1 = UIGraphicsGetCurrentContext();
             CGContextSetFillColorWithColor(context1, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
             CGContextFillRect(context1, rect1);
             UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             */
            UIImage* image1 = [[CommonTool commonToolManager] getAppNavBgPic];
            [self.tabBar setBackgroundImage:image1];
            [self.tabBar setShadowImage:[UIImage imageNamed:@"line_w.png"]];//隐藏那条黑线
            [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
        }
            break;
        case 2:
        {
            CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
            UIGraphicsBeginImageContext(rect1.size);
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context1, [[UIColor whiteColor]  CGColor]);
            CGContextFillRect(context1, rect1);
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self.tabBar setBackgroundImage:image1];
            [self.tabBar setSelectedImageTintColor:[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]];
            
            //[settingBarItem setImage:[UIImage imageNamed:@"main_setting_sel.png" ]];
            /*
             NSArray* arr = self.viewControllers;
             UINavigationController* navSettingVC = (UINavigationController*)[arr objectAtIndex:2];
             
             UITabBarItem* tabBarItem_Setting = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"main_setting_sel.png" ] tag:2];
             [navSettingVC setTabBarItem:tabBarItem_Setting];
             */
        }
            break;
        case 3:
            break;
        default:
            break;
    }
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


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGSize s = reSizeImage.size;
    return reSizeImage;
    
}

- (void) initSegmentedButton
{
    
    self.segmentedBtn = [[SegmentedButton alloc] initWithFrame:CGRectMake(0.0, 421.0-4.0, 320.0, 64.0)];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.segmentedBtn = [[SegmentedButton alloc] initWithFrame:CGRectMake(0.0, 960.0, 768.0, 64.0)];

    }
    if(IS_IPHONE_5)
    {
        self.segmentedBtn.frame = CGRectMake(0.0, 421.0+88.0-4.0, 320.0, 64.0);
    }
    
    
    UIImage* bgImg = [[CommonTool commonToolManager] getAppMenuBarBgPic];
    
    self.segmentedBtn.layer.contents = (id) bgImg.CGImage;
    
    [self.view addSubview:self.segmentedBtn];
    
    [self.segmentedBtn initWithImages:[NSArray arrayWithObjects:@"0", @"1", @"2", nil] ButtonTitles:[NSArray arrayWithObjects:@"", @"", @"", nil] buttonTintNormal:[[CommonTool commonToolManager] UIColorFromRGB:0xCECECE] buttonTintPressed:[[CommonTool commonToolManager] UIColorFromRGB:0xF3F3F3] buttonImgBk: nil FirstButtonIsSelected:TRUE actionHandler:^(int buttonIndex) {
        NSLog(@"Button pressed at index %i", buttonIndex);}];
    
    [self setTabBarBtnImg:0];
    
    self.segmentedBtn.myDelegate = self;
    //self.segmentedBtn.hidden = TRUE;
}

- (void) setTabBarBtnImg:(int) index
{
    switch (index) {
        case 0:
        {
            UIImage* appNormalImg = [UIImage imageNamed:@"liucheng.png" ];
            UIImage* appSelectImg = [UIImage imageNamed:@"liucheng_sel.png"];
            
            UIImage* lcNormalImg = [UIImage imageNamed:@"Salary.png" ];
            UIImage* lcSelectImg = [UIImage imageNamed:@"Salary_sel.png"];
            
            UIImage* txlNormalImg = [UIImage imageNamed:@"main_setting.png" ];
            UIImage* txlSelectImg = [UIImage imageNamed:@"main_setting_sel.png"];
            
//            UIImage* settingNormalImg = [UIImage imageNamed:@"main_setting.png" ];
//            UIImage* settingSelectImg = [UIImage imageNamed:@"main_setting_sel.png"];
            
            if([self.segmentedBtn.btnNormalImgs count] != 0)
            {
                self.segmentedBtn.btnNormalImgs = NULL;
            }
            
            self.segmentedBtn.btnNormalImgs = [NSArray arrayWithObjects:appNormalImg, lcNormalImg, txlNormalImg, nil];
            
            if([self.segmentedBtn.btnSelectImgs count] != 0)
            {
                self.segmentedBtn.btnSelectImgs = NULL;
            }
            self.segmentedBtn.btnSelectImgs = [NSArray arrayWithObjects:appSelectImg, lcSelectImg, txlSelectImg, nil];
            
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appSelectImg forState:UIControlStateNormal];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appSelectImg forState:UIControlStateHighlighted];
            
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcNormalImg forState:UIControlStateNormal];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcSelectImg forState:UIControlStateHighlighted];
            
            
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlNormalImg forState:UIControlStateNormal];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlSelectImg forState:UIControlStateHighlighted];
//            
//            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingNormalImg forState:UIControlStateNormal];
//            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingSelectImg forState:UIControlStateSelected];
//            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingSelectImg forState:UIControlStateHighlighted];
        }
            break;
        case 1:
        case 2:
        case 3:
        {
            UIImage* appNormalImg = [UIImage imageNamed:@"liucheng_grap.png" ];
            UIImage* appSelectImg = [UIImage imageNamed:@"liucheng_sel_grap.png"];
            
            UIImage* lcNormalImg = [UIImage imageNamed:@"Salary_grap.png" ];
            UIImage* lcSelectImg = [UIImage imageNamed:@"Salary_sel_grap.png"];
            
            UIImage* txlNormalImg = [UIImage imageNamed:@"main_setting_grap.png" ];
            UIImage* txlSelectImg = [UIImage imageNamed:@"main_setting_sel_grap.png"];
            
//            UIImage* settingNormalImg = [UIImage imageNamed:@"main_setting_grap.png" ];
//            UIImage* settingSelectImg = [UIImage imageNamed:@"main_setting_sel_grap.png"];
            
            if([self.segmentedBtn.btnNormalImgs count] != 0)
            {
                self.segmentedBtn.btnNormalImgs = NULL;
            }
            self.segmentedBtn.btnNormalImgs = [NSArray arrayWithObjects:appNormalImg, lcNormalImg, txlNormalImg, nil];
            
            if([self.segmentedBtn.btnSelectImgs count] != 0)
            {
                self.segmentedBtn.btnSelectImgs = NULL;
            }
            self.segmentedBtn.btnSelectImgs = [NSArray arrayWithObjects:appSelectImg, lcSelectImg, txlSelectImg, nil];
            
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appNormalImg forState:UIControlStateNormal];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:0])  setImage:appSelectImg forState:UIControlStateHighlighted];
            
            if(index == 1)
            {
                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcSelectImg forState:UIControlStateNormal];
            }
            else
            {
                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcNormalImg forState:UIControlStateNormal];
            }
            
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:1])  setImage:lcSelectImg forState:UIControlStateHighlighted];
            
            
            if(index == 2)
            {
                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlSelectImg forState:UIControlStateNormal];
            }
            else
            {
                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlNormalImg forState:UIControlStateNormal];
            }
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlSelectImg forState:UIControlStateSelected];
            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:2])  setImage:txlSelectImg forState:UIControlStateHighlighted];
            
//            if(index == 3)
//            {
//                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingSelectImg forState:UIControlStateNormal];
//            }
//            else
//            {
//                [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingNormalImg forState:UIControlStateNormal];
//            }
//            //[((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingNormalImg forState:UIControlStateNormal];
//            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingSelectImg forState:UIControlStateSelected];
//            [((UIButton*)[self.segmentedBtn.buttons objectAtIndex:3])  setImage:settingSelectImg forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
}
- (void) clickSegmentedButton:(NSInteger) index SegmentedButtonType:(NSInteger) type
{
    [self clickBottomBtn:index];
}

- (void) clickBottomBtn:(int) index
{
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    
    switch (index) {
        case 0:
        {
            UIImage* bgImg = [[CommonTool commonToolManager] getAppMenuBarBgPic];
            self.segmentedBtn.layer.contents = (id) bgImg.CGImage;
            
            [self.tabBar setBackgroundImage:bgImg];
            
            for(UIView* v in self.view.subviews)
            {
                if([v.class isSubclassOfClass:self.segmentedBtn.class])
                {
                    v.layer.contents = (id) bgImg.CGImage;
                }
            }
            
            [self setTabBarBtnImg:0];
            
        }
            break;
        case 1:
        {
            CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
            UIGraphicsBeginImageContext(rect1.size);
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context1, [[UIColor whiteColor]  CGColor]);
            CGContextFillRect(context1, rect1);
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.segmentedBtn.layer.contents = (id) image1.CGImage;
            
            [self setTabBarBtnImg:1];
            
        }
            break;
        case 2:
        {
            CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
            UIGraphicsBeginImageContext(rect1.size);
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context1, [[UIColor whiteColor]  CGColor]);
            CGContextFillRect(context1, rect1);
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.segmentedBtn.layer.contents = (id) image1.CGImage;
            [self setTabBarBtnImg:2];
            
        }
            break;
        case 3:
        {
//            CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//            UIGraphicsBeginImageContext(rect1.size);
//            CGContextRef context1 = UIGraphicsGetCurrentContext();
//            CGContextSetFillColorWithColor(context1, [[UIColor whiteColor]  CGColor]);
//            CGContextFillRect(context1, rect1);
//            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            self.segmentedBtn.layer.contents = (id) image1.CGImage;
//            [self setTabBarBtnImg:3];
            
        }
            break;
        default:
            break;
    }
    
    [self setSelectedIndex:index];
}

- (void) hideSegmentButton:(BOOL) hide
{
    self.segmentedBtn.hidden = hide;
    
    for(UIView* v in self.view.subviews)
    {
        if([v.class isSubclassOfClass:self.segmentedBtn.class])
        {
            v.hidden = hide;
        }
    }
}

- (void) setSegmentBtnBkImg:(UIImage*) bk
{
    for(UIView* v in self.view.subviews)
    {
        if([v.class isSubclassOfClass:self.segmentedBtn.class])
        {
            v.layer.contents = (id) bk.CGImage;
        }
    }
}



//获取用户信息
-(void) send_GetUserInfo_Msg
{
    
    //    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
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

@end
