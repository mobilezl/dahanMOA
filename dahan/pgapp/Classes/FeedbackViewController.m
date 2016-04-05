//
//  FeedbackViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-7-19.
//
//

#import "FeedbackViewController.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize myTextView;
@synthesize sendBtn;
@synthesize contactTxField;
@synthesize placeholderLabel;
@synthesize TitleLable;
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
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        myTextView.frame = CGRectMake(220, 120, 350, 250);
        contactTxField.frame = CGRectMake(220, 400, 350, 50);
        sendBtn.frame = CGRectMake(220, 470, 350, 40);
        TitleLable.frame = CGRectMake(220, 70, 350, 40);
    }
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = barBackBtn;
    
    self.myTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.myTextView.layer.opacity = 0.5;
    self.myTextView.layer.borderWidth = 2;
    
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendBtn.layer.cornerRadius = 10;
    [self.sendBtn setBackgroundColor:[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.frame =CGRectMake(self.myTextView.frame.origin.x+5.0, self.myTextView.frame.origin.y-4, 270.0, 40.0);
    self.placeholderLabel.text = @"我们会及时给您反馈";
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    self.placeholderLabel.numberOfLines = 1;
    self.placeholderLabel.enabled = NO;//lable必须设置为不可用
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.placeholderLabel];
    
}

-(void) clickBarBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (self.myTextView.text.length == 0) {
        self.placeholderLabel.text = @"我们会及时给您反馈";
    }else{
        self.placeholderLabel.text = @"";
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [myTextView resignFirstResponder];
    [contactTxField resignFirstResponder];
    
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}

-(BOOL) checkInput
{
    BOOL bret = TRUE;
    if(self.myTextView.text.length == 0
       ||
       [self.myTextView.text isEqualToString:@""]
       ||
       self.contactTxField.text.length == 0
       ||
       [self.contactTxField.text isEqualToString:@""]
       )
    {
        bret = FALSE;
    }
    
    return bret;
}

-(IBAction)sendFeedback:(id)sender
{
    [self send_SubimtAdvice_Msg];
}
- (void) send_SubimtAdvice_Msg
{
    
    if(![self checkInput])
    {
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的建议及联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SubimtAdvice xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "<userName>%@</userName>"
                             "<advice>%@</advice>"
                             "<contact>%@</contact>"
                             "</SubimtAdvice>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout,  gAuthorizeCode, gOpenID, gUserName, self.myTextView.text, self.contactTxField.text];
    
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/SubimtAdvice" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=SubimtAdvice", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"SubimtAdviceResponse"] objectForKey:@"SubimtAdviceResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见反馈成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        else
        {
            NSString* errorMsg = [[strJson objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            if([@"-10001" isEqualToString:[[strJson objectForKey:@"ResultMsg"] objectForKey:@"ErrCode"]])
            {
                av.delegate = self;
                //返回登录界面
                [av setTag:1001];
            }
            
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
@end
