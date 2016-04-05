//
//  LoginViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-17.
//
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "AppDefine.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "ipadMainTabBarViewController.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "AppDefine.h"
#import "MainViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "KeychainItemWrapper.h"
#import "AppMsgInfo.h"
#import "DBManager.h"
#import "TestWebViewViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tfUserName;
@synthesize tfPassword;
@synthesize bFromSettingVC;
@synthesize loginBtn;
@synthesize autoLoginSwitch;
@synthesize rememberSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    // [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  
    
   // [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [self.loginBtn setBackgroundColor:[UIColor whiteColor]];
    [self.loginBtn.layer setCornerRadius:10.0];
    [self.loginBtn.layer setBorderWidth:1.0];
    [self.loginBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userName = [userDefaults stringForKey:@"LastLoginUserName"];
    if(userName == nil || [userName isEqualToString:@""])
    {
        
    }
    else
    {
        self.tfUserName.text = userName;
    }
    
    KeychainItemWrapper* dahanKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"_dahan_keychain_"accessGroup:nil];

    
    if(self.bFromSettingVC)
    {

        
        [userDefaults setObject:@"0" forKey:@"AutoLogin"];
        
        //[dahanKeyChain setObject:@"" forKey:(__bridge id)kSecAttrAccount];
        //[dahanKeyChain setObject:@"" forKey:(__bridge id)kSecValueData];
        //[dahanKeyChain setObject: str forKey:(__bridge id)kSecAttrDescription];
 
        
    }

    
    UIImage* image = nil;
    NSString* filePath = [userDefaults stringForKey:@"AppBgPic"];
    if(filePath == nil || [filePath isEqualToString:@""])
    {
        image = [[CommonTool commonToolManager] getAppBgPic];
    }
    else
    {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    

    self.view.layer.contents = (id)image.CGImage;
    [self.view bringSubviewToFront:self.tfUserName];
    [self.view bringSubviewToFront:self.tfPassword];

    [self autoLogin];
    
    [self checkRememberDate];
    
    
    
   }

-(void) autoLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if([[userDefaults stringForKey:@"AutoLogin"] isEqualToString:@"1"])
    {
        KeychainItemWrapper* dahanKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"_dahan_keychain_"accessGroup:nil];

        self.autoLoginSwitch.on = TRUE;
        self.tfUserName.text = [dahanKeyChain objectForKey:(__bridge id) kSecAttrAccount];
        self.tfPassword.text = [dahanKeyChain objectForKey:(__bridge id) kSecValueData];
        
        [self send_UserLogin_Msg:@""];
    }
    else
    {
        self.autoLoginSwitch.on = FALSE;
        
    }
}
-(void) checkRememberDate
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* rememberData = [userDefaults stringForKey:@"RememberDate"];
    if(![rememberData isEqualToString:@""])
    {
        NSTimeInterval nowData = [[NSDate  date] timeIntervalSince1970] * 1000.0;
        
        NSString* str = [NSString stringWithFormat:@"%lld", (long long)nowData];
        if([rememberData compare:str] == NSOrderedDescending)
        {
            KeychainItemWrapper* dahanKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"_dahan_keychain_"accessGroup:nil];
            
            self.rememberSwitch.on = TRUE;
            self.tfUserName.text = [dahanKeyChain objectForKey:(__bridge id) kSecAttrAccount];
            self.tfPassword.text = [dahanKeyChain objectForKey:(__bridge id) kSecValueData];
        }
        else
        {
            self.rememberSwitch.on = FALSE;
        }
    }
    else
    {
        self.rememberSwitch.on = FALSE;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clickhtml:(id)sender
{
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
    mainVC.useSplashScreen = false;
    mainVC.startPage = @"http://180.173.61.125:25084/file/Backbonejs.pdf";//@"newsDetail.html";
    [self presentViewController:mainVC animated:YES completion:NULL];
    // [self.navigationController pushViewController:mainVC animated:YES];
}

- (IBAction)loginBtn:(id)sender
{

   // [self gotoMainTBVC];
   // return;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //[appDelegate setUserInfo:@"zhongliang" Password:@"123456" Code:@"987654321"];
    
    [self.tfUserName resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    
    if([self.tfUserName.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        [self.tfUserName becomeFirstResponder];
        return;
    }
    else if([self.tfPassword.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        [self.tfPassword becomeFirstResponder];
        return;
    }
    
   
    /*
    AFNetworkReachabilityStatus s = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if(![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
    */
    KeychainItemWrapper* dahanKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"_dahan_keychain_"accessGroup:nil];
   // [dahanKeyChain resetKeychainItem];
    gUserAccout = [dahanKeyChain objectForKey:(__bridge id) kSecAttrAccount];
    /*
    [dahanKeyChain setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [dahanKeyChain setObject:@"" forKey:(__bridge id)kSecAttrDescription];
    [dahanKeyChain setObject:@"" forKey:(__bridge id)kSecValueData];
    */
   // gUserAccout = [dahanKeyChain objectForKey:(__bridge id) kSecAttrAccount];
    
    /*
    if(![gUserAccout isEqualToString:tfUserName.text] || gUserAccout == nil)
    {
        NSString* str = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
        [dahanKeyChain setObject:str forKey:(__bridge id)kSecAttrDescription];
        gAuthorizeCode = [dahanKeyChain objectForKey:(__bridge id) kSecAttrDescription];
        gUserAccout = tfUserName.text;
        
    }
    else
    {
        gAuthorizeCode = [dahanKeyChain objectForKey:(__bridge id) kSecAttrDescription];
    }
    */
    [self send_UserLogin_Msg:@""];
    //[self send_GetUserLoginProfile_Msg];
    
    return;
    
    
    
    if(true)//需要输入密保
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密保" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        av.tag = 101;
        [av setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        [av show];
    }
    else
    {
        //不需要输入密保
        //[self gotoMainTBVC];
        
        [self send_PullMessage_Msg];
    }

    
}

- (void) gotoMainTBVC
{
      if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){

          //进入主界面
          ipadMainTabBarViewController* mainTBVC = [[ipadMainTabBarViewController alloc] initWithNibName:@"ipadMainTabBarViewController" bundle:nil];
          AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
          appDelegate.viewController = (UIViewController*)mainTBVC;
          appDelegate.window.rootViewController = mainTBVC;
          [appDelegate.window addSubview:mainTBVC.view];
          [appDelegate.window makeKeyAndVisible];

      }else{
    //进入主界面
    MainTabBarViewController* mainTBVC = [[MainTabBarViewController alloc] initWithNibName:@"MainTabBarViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.viewController = (UIViewController*)mainTBVC;
    appDelegate.window.rootViewController = mainTBVC;
    [appDelegate.window addSubview:mainTBVC.view];
    [appDelegate.window makeKeyAndVisible];
      }
    
    
}

- (void) send_GetUserLoginProfile_Msg
{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetUserLoginProfile xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<authorizeCode>%@</authorizeCode>"
                             "</GetUserLoginProfile>"
                             "</soap:Body>"
                             "</soap:Envelope>", tfUserName.text,  gAuthorizeCode];

    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetUserLoginProfile" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=GetUserLoginProfile", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetUserLoginProfileResponse"] objectForKey:@"GetUserLoginProfileResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            
            NSString* strMoaAccess = [strJson objectForKey:@"MoaAccess"];
            NSString* strPwdProtection = [strJson objectForKey:@"PwdProtection"];
            
            if([strMoaAccess isEqualToString:@"0"])
            {
                //没有移动办公权限
                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有移动办公权限，请确认" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                return ;
            }
            else
            {
                if([strPwdProtection isEqualToString:@"1"])//需要输入密保
                {
                    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密保" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    av.tag = 101;
                    [av setAlertViewStyle:UIAlertViewStyleSecureTextInput];
                    [av show];
                }
                else
                {
                    //不需要输入密保
                    [self send_UserLogin_Msg:@""];
                }

            }
           
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
- (void) send_UserLogin_Msg:(NSString*) uuPD
{
    /*
    if(![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
     */

    
    
//    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                             "<soap:Body>"
//                             "<UserAuthentication xmlns=\"http://tempuri.org/\">"
//                             "<Action>UserAuthentication</Action>"
//                             "<loginName>%@</loginName>"
//                             "<passWord><![CDATA[%@]]></passWord>"
//                             "<imei>%@</imei>"
//                             "<appList>%@</appList>"
//                             "</UserAuthentication>"
//                             "</soap:Body>"
//                             "</soap:Envelope>", tfUserName.text, tfPassword.text,  gUUID,@"0003"];
//    
//    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
//    
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
//    [manager.requestSerializer setValue:@"http://tempuri.org/UserAuthentication" forHTTPHeaderField:@"SOAPAction"];
//    
//    NSString* urlStr = [NSString stringWithFormat:@"%@/Authentication.asmx?op=UserAuthentication", SERVERADDRESS];
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
//    
//    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
//        
//        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"UserAuthenticationResponse"] objectForKey:@"UserAuthenticationResult"] objectForKey:@"text"];
//        
//        NSDictionary* strJson = [textDic JSONValue];
    
    

    NSString *name = [tfUserName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwd = [tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UserAuthenticationInZK xmlns=\"http://tempuri.org/\">"
                             "<Action>UserAuthenticationInZK</Action>"
                             "<loginName><![CDATA[%@]]></loginName>"
                             "<passWord><![CDATA[%@]]></passWord>"
                             "<imei>%@</imei>"
                              "<appList>%@</appList>"
                             "</UserAuthenticationInZK>"
                             "</soap:Body>"
                             "</soap:Envelope>", name, pwd,  gUUID,@"0003"];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
//    NSLog(@"gUUID:%@",gUUID);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/UserAuthenticationInZK" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/Authentication.asmx?op=UserAuthenticationInZK", SERVERADDRESS];
    
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"UserAuthenticationInZKResponse"] objectForKey:@"UserAuthenticationInZKResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
    
    
    
//    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                             "<soap:Body>"
//                             "<UserAuthentication xmlns=\"http://tempuri.org/\">"
//                             "<Action>UserAuthentication</Action>"
//                             "<loginName>%@</loginName>"
//                             "<passWord>%@</passWord>"
//                             "<imei>%@</imei>"
//                              "<appList>%@</appList>"
//                             "</UserAuthentication>"
//                             "</soap:Body>"
//                             "</soap:Envelope>",@"zhongliang", pwd,  gUUID,@"0003"];
//    
//    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
//    
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
//    [manager.requestSerializer setValue:@"http://tempuri.org/UserAuthentication" forHTTPHeaderField:@"SOAPAction"];
//    
//    NSString* urlStr = [NSString stringWithFormat:@"%@/Authentication.asmx?op=UserAuthentication", SERVERADDRESS];
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
//    
//    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
//        
//        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"UserAuthenticationResponse"] objectForKey:@"UserAuthenticationResult"] objectForKey:@"text"];
//        
//        NSDictionary* strJson = [textDic JSONValue];
    
        NSLog(@"%@",strJson);
    
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"])
        {
            gUserPassword = pwd;
//            gUserName = name;
            gUserName = [strJson objectForKey:@"Enumber"];
            gUserAccout = name;
            gAuthorizeCode = [strJson objectForKey:@"AccescToken"];
            gOpenID = [strJson objectForKey:@"OpenID"];
            
             NSArray *array = [strJson objectForKey:@"ListEntity"];
             gAppVer = [[array objectAtIndex:0] objectForKey:@"AppVer"];
            gDownLoadUrl =[[array objectAtIndex:0] objectForKey:@"DownLoadUrl"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            glocalVersion = [infoDictionary objectForKey:@"CFBundleVersion"] ;
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:gUserAccout forKey:@"LastLoginUserName"];
            
            KeychainItemWrapper* dahanKeyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"_dahan_keychain_"accessGroup:nil];
            [dahanKeyChain setObject:tfUserName.text forKey:(__bridge id)kSecAttrAccount];
            [dahanKeyChain setObject:tfPassword.text forKey:(__bridge id)kSecValueData];
            [dahanKeyChain setObject: gAuthorizeCode forKey:(__bridge id)kSecAttrDescription];
            //[dahanKeyChain setObject:gOpenID forKey:(__bridge id) kSecAttrKeyClass];

//            [self send_PullMessage_Msg];
            
            /*
            NSMutableArray* muArry = [NSMutableArray arrayWithCapacity:5];
            for(int i = 0; i < 4; ++i)
            {
                AppMsgInfo* msgInfo = [[AppMsgInfo alloc] init];
                msgInfo.appID = [NSString stringWithFormat:@"%d", i];//[[arry objectAtIndex:i] objectForKey:@"AppId"];
                if(i == 1)
                {
                    msgInfo.appID = @"1023";
                }
                msgInfo.appName = @"测试1";//[[arry objectAtIndex:i] objectForKey:@"AppName"];
                msgInfo.appKey = @"20";//[[arry objectAtIndex:i] objectForKey:@"AppKey"];
                msgInfo.appEntry = @"/apps/news/index.html";//[[arry objectAtIndex:i] objectForKey:@"AppEntry"];
                msgInfo.msgID = [NSString stringWithFormat:@"%d", i];//[[arry objectAtIndex:i] objectForKey:@"Id"];
                msgInfo.msgContent = @"测试消息内容1";//[[arry objectAtIndex:i] objectForKey:@"Message"];
                msgInfo.msgIcon = @"http://180.173.162.211:25084/Resource/app/Icons/news_icon.png";//[[arry objectAtIndex:i] objectForKey:@"MsgIcon"];
                msgInfo.isRead = FALSE;
                
                [muArry addObject:msgInfo];
            }
            if([muArry count] > 0)
            {
                [[DBManager dbManager] executeSaveAppMsgs:muArry];
            }
            */
            //进入主界面
           [self gotoMainTBVC];
        }
        else
        {
            NSString* errorMsg = [[strJson objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        


        NSLog(@"------send_UserLogin_Msg--------%@", strJson);
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



- (void) send_PullMessage_Msg
{
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<PullMessage xmlns=\"http://tempuri.org/\">"
                             "<userID>%@</userID>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "</PullMessage>"
                             "</soap:Body>"
                             "</soap:Envelope>", tfUserName.text, gAuthorizeCode, gOpenID];
    
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
            
            //进入主界面
            [self gotoMainTBVC];
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

//#pragma AlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 1001 && buttonIndex == 1)
//    {
//        NSString* uupd = [alertView textFieldAtIndex:0].text;
//        if([uupd isEqualToString:@""])
//        {
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密保不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            [av show];
//        }
//        else
//        {
//            [self send_UserLogin_Msg:uupd];
//        }
//    }
//}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfUserName resignFirstResponder];
    [tfPassword resignFirstResponder];


    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (IBAction)switchAutoLogin:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(isButtonOn)
    {
        [userDefaults setObject:@"1" forKey:@"AutoLogin"];
    }
    else
    {
        [userDefaults setObject:@"0" forKey:@"AutoLogin"];
    }

    
}
- (IBAction)switchRemember:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(isButtonOn)
    {
        NSTimeInterval nowData = [[NSDate  date] timeIntervalSince1970] * 1000.0 + 30 * 24 * 60 * 60 * 1000.0;
        
        NSString* str = [NSString stringWithFormat:@"%lld", (long long)nowData];
        
        [userDefaults setObject:str forKey:@"RememberDate"];
    }
    else
    {
        [userDefaults setObject:@"" forKey:@"RememberDate"];
    }

}



@end
