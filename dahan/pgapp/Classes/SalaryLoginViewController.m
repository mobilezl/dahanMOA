//
//  SalaryLoginViewController.m
//  pgapp
//
//  Created by Leo on 14-10-13.
//
//

#import "SalaryLoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "MainTabBarViewController.h"
#import "SalaryDateViewController.h"
@interface SalaryLoginViewController ()

@end

@implementation SalaryLoginViewController
@synthesize imageView;
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



    UIImage* navBgImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navBgImg forBarMetrics:UIBarMetricsDefault];

    
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppBgPic];
//    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    [self.imageView setImage:navImg];
    self.userName.textColor = [[UIColor whiteColor] init];
     self.userID.textColor = [[UIColor whiteColor] init];
    self.LoginBtn.backgroundColor = [[CommonTool commonToolManager] UIColorFromRGB:0x3795ff];
    self.LoginBtn.layer.cornerRadius = 8.0;
    [self.view bringSubviewToFront:self.LoginBtn];
    
    


 
      
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
 
    
    float addHeight = 88.0;
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;
 self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        self.imageView.frame = CGRectMake(0, 0, screenWidth, 450);
        self.userName.frame = CGRectMake(0, 100, screenWidth, 50);
          self.userID.frame = CGRectMake(0, 140, screenWidth, 50);
         self.TfPassWord.frame = CGRectMake(250, 220, 280, 30);
          self.LoginBtn.frame = CGRectMake(250, 480, 280, 30);
    }else{
   
     self.imageView.frame = CGRectMake(0, 0, screenWidth, screenHeight/2+addHeight);
    }
    
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line_w.png"]];
    }


    
   
  
    
    self.userName.text = gUserAccout;
    self.userID.text = [NSString stringWithFormat:@"工号: %@",gUserName];
    self.TfPassWord.secureTextEntry = YES;
    
 
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];


}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.TfPassWord resignFirstResponder];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.TfPassWord resignFirstResponder];

    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) send_UserLogin_Msg:(NSString*) uuPD
{
  NSString *pwd = [self.TfPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SalaaryCheckPwd xmlns=\"http://tempuri.org/\">"
                             "<Action>SalaaryCheckPwd</Action>"
                             "<loginName><![CDATA[%@]]></loginName>"
                             "<passWord><![CDATA[%@]]></passWord>"
                             "<imei>%@</imei>"
                             "<appList>%@</appList>"
                             "</SalaaryCheckPwd>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, pwd,  gUUID,@"0003"];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/SalaaryCheckPwd" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/Authentication.asmx?op=SalaaryCheckPwd", SERVERADDRESS];
    
   
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
     
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"SalaaryCheckPwdResponse"] objectForKey:@"SalaaryCheckPwdResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"])
        {

            [self.TfPassWord setValue:[[UIColor grayColor] init] forKeyPath:@"_placeholderLabel.textColor"];
            SalaryDateViewController* feedbackVC = [[SalaryDateViewController alloc] initWithNibName:@"SalaryDateViewController" bundle:NULL];
            feedbackVC.title = @"日期选择";
            
            [self.navigationController pushViewController:feedbackVC animated:YES];
            
            NSLog(@"登录成功");

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

#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001)
    {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            //返回登录界面
            ipadLoginViewController* loginVC = [[ipadLoginViewController alloc] initWithNibName:@"ipadLoginViewController" bundle:nil];
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            //返回登录界面
            LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    }
}
- (IBAction)LoginSend:(id)sender {

    
if([self.TfPassWord.text length]>0){
//    if([gUserPassword isEqualToString:self.TfPassWord.text]){
//        [self.TfPassWord setValue:[[UIColor grayColor] init] forKeyPath:@"_placeholderLabel.textColor"];
//        SalaryDateViewController* feedbackVC = [[SalaryDateViewController alloc] initWithNibName:@"SalaryDateViewController" bundle:NULL];
//        feedbackVC.title = @"选择日期";
//        
//        [self.navigationController pushViewController:feedbackVC animated:YES];
//    }else{
//        [self.TfPassWord setValue:[[UIColor redColor] init] forKeyPath:@"_placeholderLabel.textColor"];
//    }
    
    [self send_UserLogin_Msg:@""];
}else{
    [self.TfPassWord setValue:[[UIColor redColor] init] forKeyPath:@"_placeholderLabel.textColor"];

}
 self.TfPassWord.text=nil;
}
@end
