//
//  SettingViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-18.
//
//

#import "SettingViewController.h"
#import "StyleSettingViewController.h"
#import "AppDefine.h"
#import "AppDelegate.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "SettingAppBgPicViewController.h"
#import "AboutDHViewController.h"
#import "VersionInfoViewController.h"
#import "UserInfoViewController.h"
#import "ShareAppViewController.h"
#import "FeedbackViewController.h"
#import "MainTabBarViewController.h"
#import "RMSwipeTableViewCelliOS7UIDemoViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize myTableView;
@synthesize settingMArray;
@synthesize logoutBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    
    
    [self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:YES];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
//    [view release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
//    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
//    [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
//    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
//    self.navigationItem.leftBarButtonItem = barBackBtn;
    
    //self.myTableView.layer.borderColor = [UIColor redColor].CGColor;
    //self.myTableView.layer.borderWidth = 2;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.logoutBtn.frame = CGRectMake(270.0, 360.0, 250.0, 40.0);
    }
    self.logoutBtn.backgroundColor = [[CommonTool commonToolManager] UIColorFromRGB:0x3795ff];
    self.logoutBtn.layer.cornerRadius = 8.0;
   // self.logoutBtn.layer.borderWidth = 2;
   // self.logoutBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view bringSubviewToFront:self.logoutBtn];
    //self.logoutBtn.layer.
    // Do any additional setup after loading the view from its nib.
    NSArray* arry = [NSArray arrayWithObjects: @"推荐给好友", @"更改主题", @"新版本检测", @"关于", @"清除缓存", nil];
    self.settingMArray = [[NSMutableArray alloc] initWithArray:arry];
    if(IS_IPHONE_5)
    {
        self.myTableView.frame = CGRectMake(0.0, 0.0, 320.0, 340.0);
    }
[self setExtraCellLineHidden:myTableView];
    
    
    
}

-(void) clickBarBackBtn:(id)sender
{
    MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];
    
    [vcs clickBottomBtn:0];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingMArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CELL = @"SETCELL";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = @"";
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = @"";
    
   
    
    NSString* data = (NSString*)[self.settingMArray objectAtIndex:indexPath.row];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
       
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    }

    cell.textLabel.text = data;

    
    if([gAppVer isEqualToString:glocalVersion]){
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
   

   if(indexPath.row == 2){
        UIImage *image= [UIImage   imageNamed:@"new.png"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 40, 35);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor= [UIColor clearColor];
        cell.accessoryView= button;
    }else {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor= [UIColor clearColor];
        cell.accessoryView= button;
    }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
//        case 0:
//        {
//            UserInfoViewController* userInfoVC = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:NULL];
//            userInfoVC.title = @"个人资料";
//            [self.navigationController pushViewController:userInfoVC animated:YES];
//        
////            [userInfoVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
////            [userInfoVC setModalPresentationStyle:UIModalPresentationFormSheet];
////            [self presentModalViewController:userInfoVC animated:YES];
////          
//            
//            
//            
//            
//            
//        }
//        break;
        case 0:
        {
            ShareAppViewController* shareAppVC = [[ShareAppViewController alloc] initWithNibName:@"ShareAppViewController" bundle:NULL];
            shareAppVC.title = @"推荐给好友";
            [self.navigationController pushViewController:shareAppVC animated:YES];
            
        }
        break;
//        case 1:
//        {
//            FeedbackViewController* feedbackVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:NULL];
//            feedbackVC.title = @"意见反馈";
//            [self.navigationController pushViewController:feedbackVC animated:YES];
//        }
//        break;
        case 1:
        {
            //设置背景图片
            SettingAppBgPicViewController* settingAppBgPicVC = [[SettingAppBgPicViewController alloc] initWithNibName:@"SettingAppBgPicViewController" bundle:nil];
            settingAppBgPicVC.title = @"更改主题";
            [self.navigationController pushViewController:settingAppBgPicVC animated:YES];
        }
        break;
        case 2:
        {
            
            [self send_GetAppVer_Msg];
            VersionInfoViewController* verInfoVC = [[VersionInfoViewController alloc] initWithNibName:@"VersionInfoViewController" bundle:nil];
            verInfoVC.title = @"版本信息";
           // [self.navigationController pushViewController:verInfoVC animated:YES];
           
        }
        break;
        case 3:
        {
            
//            RMSwipeTableViewCelliOS7UIDemoViewController *swipeTableViewCelliOS7UIDemoViewController = [[RMSwipeTableViewCelliOS7UIDemoViewController alloc] initWithStyle:UITableViewStylePlain];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:swipeTableViewCelliOS7UIDemoViewController];
//            [navigationController.navigationBar setClipsToBounds:YES];
// [self.navigationController pushViewController:swipeTableViewCelliOS7UIDemoViewController animated:YES];


            
                       AboutDHViewController* aboutDHVC = [[AboutDHViewController alloc] initWithNibName:@"AboutDHViewController" bundle:nil];
            aboutDHVC.title = @"关于";
            [self.navigationController pushViewController:aboutDHVC animated:YES];
            
        }
        break;
        case 4:
        {
            [self clearCache];
        }
        break;
        default:
            break;
    }
}

-(void) send_UserLogout_Msg
{
 
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UserLogin xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<authorizeCode>%@</authorizeCode>"
                             "</UserLogin>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/UserLogout" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=UserLogout", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法

        
        //判断是否回到iPad登录界面
          if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
              ipadLoginViewController* ipadloginVC = [[ipadLoginViewController alloc] initWithNibName:@"ipadLoginViewController" bundle:nil];
              ipadloginVC.bFromSettingVC = TRUE;
              [self presentViewController:ipadloginVC animated:YES completion:nil];
          }else{
        //回到登录界面
        LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.bFromSettingVC = TRUE;
        [self presentViewController:loginVC animated:YES completion:nil];
              }
       
       // NSLog(@"--------------%@", strJson);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
    }];
    [manager.operationQueue addOperation:operation];
  //  [appDelegate1 setUserInfo:@"" Password:@"" Code:@""];

}

-(IBAction)logoutBtn:(id)sender
{
    [self send_UserLogout_Msg];
}
#pragma StyleSettingVCDelegate methods
-(void) backFromStyleSettingVC:(id)sender
{
    if(gStyleType == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(gStyleType == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        //self.navigationController.tabBarController.tabBar.hidden = YES;
        //self.navigationController.tabBarController.view.frame = CGRectZero;
        
    }
}

-(void) clearCache
{
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存已清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    //av.tag = 1001;
    //av.delegate = self;
    [av show];
    
}
#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:YES];
    
    if(alertView.tag == 1001 && buttonIndex == 1)
    {

        NSString *urlString = gDownLoadUrl;
        
        NSURL *url  = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:url];

        
    }
}

-(void) send_GetAppVer_Msg
{
    
  
            if([gAppVer isEqualToString:glocalVersion])
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                //av.tag = 1001;
                //av.delegate = self;
                [av show];
           

            }
            else
            {
                NSString* msg = [NSString stringWithFormat:@"发现最新版本V%@", gAppVer];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                av.tag = 1001;
                [av show];
            }

}


@end
