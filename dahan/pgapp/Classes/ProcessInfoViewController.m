//
//  ProcessInfoViewController.m
//  pgapp
//
//  Created by Leo on 14-9-25.
//
//

#import "ProcessInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "Approval.h"
#import "ProcessAddViewController.h"
#import "WorkFlowViewController.h"
#import "UIWindow+YzdHUD.h"
#import "ProcessRedirectViewController.h"
#import "ApprovalHistory.h"
#import "DocViewController.h"
#import "ApprovalDetailTableViewCell.h"
#import "ApprovalDetalles.h"
#import "KxMenu.h"
#import "DocFile.h"
#import "OpenTxtViewController.h"
#import "MainViewController.h"
@interface ProcessInfoViewController ()

@end

@implementation ProcessInfoViewController


@synthesize Submitter;
@synthesize SubmintDate;
@synthesize imageLine;
@synthesize myTableView;
@synthesize appsList;
@synthesize popupList;
@synthesize ProcInstID;
@synthesize ProcessDetailID;
@synthesize menuItems;
@synthesize DetallesArryList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         appsList = [[NSMutableArray alloc] initWithCapacity:5];
        popupList= [[NSMutableArray alloc] initWithCapacity:5];
        DetallesArryList =[[NSMutableArray alloc] initWithCapacity:5];

        
    
        
    }

    return self;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    //    [view release];
    
}



-(void)viewDidLayoutSubviews {

    float addHeight = 88.0;
    if(!IS_IPHONE_5)
    {
        addHeight = 0.0;
        
    }
if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){

    self.myTableView.frame =CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-200);
    self.myTableView.rowHeight = 60;
}else{
    self.myTableView.frame =CGRectMake(0, 33, self.view.frame.size.width, self.view.frame.size.height-189);
    self.myTableView.rowHeight = 40;
}
//    [self.view addSubview:self.myTableView];
    
    
    
    
    
    

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float addHeight = 0.0;
 
   
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;
    
    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.imageLine.hidden=YES;
        self.Submitter.frame = CGRectMake(20, 10, screenWidth/2, 30);
        self.SubmintDate.frame = CGRectMake(screenWidth/2, 10, screenWidth/2, 30);
       
    

        
         self.Submitter.font = [UIFont fontWithName:@"Arial" size:18];
         self.SubmintDate.font = [UIFont fontWithName:@"Arial" size:18];
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
    

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarStyleDefault target:self action:@selector(showMenu:)];
////     UIBarButtonItem *DocButton = [[UIBarButtonItem alloc] initWithTitle:@"附件" style:UIBarStyleDefault target:self action:@selector(clickDocBarBackBtn:)];
    [self.navigationItem setRightBarButtonItem:anotherButton];
  
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0, self.view.frame.size.height-(172+addHeight), self.view.frame.size.width/2, 50);


    button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button1.backgroundColor=[UIColor colorWithRed:(50.0/255) green:(205.0/255) blue:(50.0/255)alpha:1.0];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:@"同意" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    button2.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-(172+addHeight), self.view.frame.size.width/2, 50);
    button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button2.backgroundColor=[UIColor colorWithRed:(255.0/255) green:(0.0/255) blue:(0.0/255)alpha:1.0];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitle:@"拒绝" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickRefuseBtn:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 6;
    [self.view addSubview:button2];
     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
          textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-(280+addHeight), self.view.frame.size.width-20, 50)];
     }else{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-(260+addHeight), 300, 50)];
     }
    textView.layer.borderColor=UIColor.grayColor.CGColor;
    textView.layer.borderWidth = 1;

    [self.view addSubview:textView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.frame =CGRectMake(textView.frame.origin.x+5.0, textView.frame.origin.y-4, 270.0, 40.0);
    self.placeholderLabel.text = @"您的审批意见";
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    self.placeholderLabel.numberOfLines = 1;
    self.placeholderLabel.enabled = NO;//lable必须设置为不可用
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.placeholderLabel];

    
    
     textView.delegate = self;
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [self send_GetWaitApprovalList_Msg];

    [self setExtraCellLineHidden:myTableView];
    
    
 
    tlab = [[UILabel alloc] init];
    tlab.frame = CGRectMake(10, self.view.frame.size.height-(182+addHeight), self.view.frame.size.width-20, 50);
    tlab.numberOfLines=2;
    tlab.text=@"*本流程当前节点不支持移动审批，请至PC端做审批处理。";
    
    tlab.textColor = [UIColor redColor];
    tlab.font = [UIFont fontWithName:@"Arial" size:14];
    //                lab.textAlignment = UITextAlignmentCenter;
    [tlab setHidden:YES];
    [self.view addSubview:tlab];
    
   

}
- (void)showMenu:(UIBarButtonItem *)sender
{
    if([ProcessDetailID isEqualToString:@""] || ProcessDetailID == nil){
        [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-24, 0.0, 24.0,41.0) menuItems:menuItems];
    }else{
        [self send_GetDetail_Msg];
    }
}

- (void) pushMenuItem:(id *)sender
{
    ProcessDetailID =[NSString stringWithFormat:@"%@",sender];
    [self send_GetDetail_Msg];
    ProcessDetailID = nil;


    
}


//隐藏键盘的方法
-(void)hidenKeyboard
{
    [KxMenu dismissMenu];
    [textView resignFirstResponder];

    [self resumeView];
}
//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 60.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
//UITextView的协议方法，当开始编辑时监听
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移70个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-70,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}
- (IBAction)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    [self resumeView];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"您的审批意见";
    }else{
        self.placeholderLabel.text = @"";
    }
}

-(void) clickBarBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) clickdetailBarBackBtn:(id)sender
{
//    [self send_GetDetail_Msg];

   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Approval * approval=nil;
-(void) passValue:(id)value {

    approval = value;

}


- (void) send_GetDetail_Msg
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetProcessDetailInfoForAndroid&loginName=%@&accesc_Token=%@&openId=%@&procInstID=%@&processDetailID=%@",SERVERADDRESS,approval.ApproverLoginName,gAuthorizeCode,gOpenID,ProcInstID,ProcessDetailID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"--send_GetDetail_Msg---%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {

            [self.popupList removeAllObjects];
            NSArray* arry = [responseObject objectForKey:@"DetailTableContent"];
            for(int i = 0; i < arry.count; ++i)
            {
                
                [self.popupList addObject:[[arry objectAtIndex:i] objectForKey: @"Value"]];
                
            }
            
             NSString *htmlString = [responseObject objectForKey:@"F_DOC"];
            
              htmlString = [htmlString stringByReplacingOccurrencesOfString :@"<img" withString:@"<img width='100%' height='50%' "];
            
            
            CGFloat xWidth = self.view.bounds.size.width - 20.0f;
            CGFloat yHeight = 330.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
            poplistview.delegate = self;
            poplistview.datasource = self;
            poplistview.listView.scrollEnabled = TRUE;
            [poplistview setTitle:@"流程明细"];
            [poplistview setWebView:htmlString];
            [poplistview show];
            
            
            [self setExtraCellLineHidden:poplistview.listView];
            
            
        }else{
            NSString* errorMsg = [[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            if([@"-10001" isEqualToString:[[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrCode"]])
            {
                av.delegate = self;
                //返回登录界面
                [av setTag:1001];
            }
            
            [av show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
        
    }];
 
    
    
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) send_GetWaitApprovalList_Msg
{
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetProcessInfoForAndroid&loginName=%@&accesc_Token=%@&openId=%@&ProcessSN=%@&processType=%@",SERVERADDRESS,approval.ApproverLoginName,gAuthorizeCode,gOpenID,approval.ProcessSN,approval.ProcessType];
     NSLog(@"-----%@",url);
    //    NSDictionary *dict = @{@"":@""};
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
           
           
            NSArray* arry = [responseObject objectForKey:@"ProcessBaseInfo"];
            
            Submitter.text = [NSString stringWithFormat:@"发起人:%@" ,[[arry objectAtIndex:0] objectForKey:@"Submitter"]];
            SubmintDate.text =[[arry objectAtIndex:0] objectForKey:@"SubmitDate"];
            ProcInstID =[[arry objectAtIndex:0] objectForKey:@"procinstid"];
             NSArray* arryls = [responseObject objectForKey:@"ProcessContentList"];
             NSMutableArray *ContentList=[NSMutableArray array];
            for(int i = 0; i < arryls.count; ++i)
            {

                [ContentList addObject:[[arryls objectAtIndex:i] objectForKey: @"Value"]];

            }
            NSArray* HistoryArry = [responseObject objectForKey:@"ApprovalHistoryList"];
            NSMutableArray *HistoryArryList=[NSMutableArray array];
            for(int k = 0; k < HistoryArry.count; ++k)
            {
                [HistoryArryList addObject:[NSString stringWithFormat:@"环节名称:%@                  %@" ,[[HistoryArry objectAtIndex:k] objectForKey:@"ActivityName"],  [[HistoryArry objectAtIndex:k] objectForKey:@"ApproverTime"] ]];
                [HistoryArryList addObject:[NSString stringWithFormat:@"人员姓名:%@" ,[[HistoryArry objectAtIndex:k] objectForKey:@"Approver"]]];
                [HistoryArryList addObject:[NSString stringWithFormat:@"人员职位:%@-%@-%@" ,[[HistoryArry objectAtIndex:k] objectForKey:@"CompanyName"],[[HistoryArry objectAtIndex:k] objectForKey:@"DepartmentName"],[[HistoryArry objectAtIndex:k] objectForKey:@"ApproverTitle"]]];

                [HistoryArryList addObject:[NSString stringWithFormat:@"审批操作:%@" ,[[HistoryArry objectAtIndex:k] objectForKey:@"ApproveActionName"]]];
                [HistoryArryList addObject:[NSString stringWithFormat:@"意见:%@" ,[[HistoryArry objectAtIndex:k] objectForKey:@"ApprovalComment"]]];
//                [HistoryArryList addObject:@""];

                
            }
            
            
            NSArray* DetallesArry = [responseObject objectForKey:@"ProcessDetailList"];
//            NSMutableArray *DetallesArryList=[NSMutableArray array];
            
            if(DetallesArry.count==0){
                self.navigationItem.rightBarButtonItem=nil;
                

            }else{
            for(int z = 0; z < DetallesArry.count; ++z)
            {
                ApprovalDetalles* approval = [[ApprovalDetalles alloc] init];
                approval.ProcessDetailID = [[DetallesArry objectAtIndex:z] objectForKey:@"ProcessDetailID"];
                approval.ProcessDetailName = [[DetallesArry objectAtIndex:z] objectForKey:@"ProcessDetailName"];
                [DetallesArryList addObject:approval ];
               if(DetallesArry.count==1){
                   ProcessDetailID =[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailID"]];
                      menuItems =
                      @[

                      [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailName"]]
                                     image:nil
                                    target:self
                                    action:@selector(pushMenuItem:)
                       param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailID"]]]
                      ];
                    

                }else  if(DetallesArry.count==2){
                    menuItems =
                    @[
                      
                    [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailName"]]
                                           image:nil
                                          target:self
                                          action:@selector(pushMenuItem:)
                     param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailID"]]],
                      
                      [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:1] objectForKey:@"ProcessDetailName"]]
                                     image:nil
                                    target:self
                                    action:@selector(pushMenuItem:)
                       param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:1] objectForKey:@"ProcessDetailID"]]]
                      ];
                    

                }else  if(DetallesArry.count==3){
                    menuItems =
                    @[
                      
                      [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailName"]]
                                     image:nil
                                    target:self
                                    action:@selector(pushMenuItem:)
                                     param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:0] objectForKey:@"ProcessDetailID"]]],
                      
                      [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:1] objectForKey:@"ProcessDetailName"]]
                                     image:nil
                                    target:self
                                    action:@selector(pushMenuItem:)
                                     param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:1] objectForKey:@"ProcessDetailID"]]],
                      [KxMenuItem menuItem:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:2] objectForKey:@"ProcessDetailName"]]
                                     image:nil
                                    target:self
                                    action:@selector(pushMenuItem:)
                                     param:[NSString stringWithFormat:@"%@", [[DetallesArry objectAtIndex:2] objectForKey:@"ProcessDetailID"]]]
                      ];
                    
                    
                }

                
            }
            }
            
           
          
          
            [self.appsList addObject:ContentList];
//            [self.appsList addObject:DetallesArry];
            [self.appsList addObject:HistoryArryList];


              NSString *IsApproval =[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"IsApproval"] description]];

            if([IsApproval isEqualToString:@"1"]){
                float addHeight = 0.0;
                
                
                CGRect rect=[[UIScreen mainScreen] bounds];
                CGSize size = rect.size;
                int screenWidth = size.width;
                int screenHeight = size.height;
                
                self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                [button1 setHidden:YES];
                [button2 setHidden:YES];
                
                [tlab setHidden:NO];
                
            }else{
             NSArray* arrys = [responseObject objectForKey:@"ProcessActionList"];
            if(arrys.count > 0){
                
            for(int i = 0; i < arrys.count; ++i)
            {
                
                NSString  *actoin = [[arrys objectAtIndex:i] objectForKey:@"ActionValue"];
                

//                int intString = [actoin intValue];
                if ([actoin isEqualToString:@"1"]) {
                    
                    addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    addBtn.frame = CGRectMake(0, self.view.frame.size.height-95, self.view.frame.size.width/4-30, 35);
                    addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    [addBtn setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];

                    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [addBtn setTitle:@"同意" forState:UIControlStateNormal];
                    [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:addBtn];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-30, self.view.frame.size.height-95, self.view.frame.size.width/4, 35)];
                    label1.text = @"加签";
                    label1.font = [UIFont fontWithName:@"Arial" size:12];
                    [self.view addSubview:label1];
                    
                    
                }else
                if ([actoin isEqualToString:@"3"]) {
                    
//                    button2.tag = 3;
                    forwardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    forwardBtn.frame = CGRectMake(1*(self.view.frame.size.width/4), self.view.frame.size.height-95, self.view.frame.size.width/4-30, 35);
                    forwardBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    [forwardBtn setImage:[UIImage imageNamed:@"icon_forward.png"] forState:UIControlStateNormal];
                    
                    [forwardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [forwardBtn setTitle:@"同意" forState:UIControlStateNormal];
                    [forwardBtn addTarget:self action:@selector(clickforwardBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:forwardBtn];
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(2*(self.view.frame.size.width/4-15), self.view.frame.size.height-95, self.view.frame.size.width/4, 35)];
                    label2.text = @"转签";
                    label2.font = [UIFont fontWithName:@"Arial" size:12];
                    [self.view addSubview:label2];

                }else
                if ([actoin isEqualToString:@"4"]) {
                    returnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    returnBtn.frame = CGRectMake(2*(self.view.frame.size.width/4), self.view.frame.size.height-95, self.view.frame.size.width/4-30, 35);
                    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    [returnBtn setImage:[UIImage imageNamed:@"icon_return.png"] forState:UIControlStateNormal];
                    
                    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [returnBtn setTitle:@"同意" forState:UIControlStateNormal];
                    [returnBtn addTarget:self action:@selector(clickreturnBtn:) forControlEvents:UIControlEventTouchUpInside];
                     [self.view addSubview:returnBtn];
                    
                    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(3*(self.view.frame.size.width/4-10), self.view.frame.size.height-95, self.view.frame.size.width/4, 35)];
                    label3.text = @"退回";
                    label3.font = [UIFont fontWithName:@"Arial" size:12];
                    [self.view addSubview:label3];


                }else
                    if ([actoin isEqualToString:@"-1"]) {
                        float addHeight = 0.0;
                        
                        
                        CGRect rect=[[UIScreen mainScreen] bounds];
                        CGSize size = rect.size;
                        int screenWidth = size.width;
                        int screenHeight = size.height;
                        
                        self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                        
                        [button1 setHidden:YES];
                        [button2 setHidden:YES];
                        huiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        huiBtn.frame = CGRectMake(10, self.view.frame.size.height-(182+addHeight), self.view.frame.size.width-20, 30);
                        huiBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                        huiBtn.backgroundColor=[UIColor colorWithRed:(50.0/255) green:(205.0/255) blue:(50.0/255)alpha:1.0];
                        [huiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [huiBtn setTitle:@"建议" forState:UIControlStateNormal];

                        huiBtn.layer.cornerRadius = 8.0;

                        
                        [huiBtn addTarget:self action:@selector(clickhuiBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [self.view addSubview:huiBtn];
                        
                    }
                else if ([actoin isEqualToString:@"6"]){
                  
                    [button2 setHidden:YES];
                    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    
                    button2.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-textView.frame.size.height-10, self.view.frame.size.width/2, 50);
                    button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    button2.backgroundColor=[UIColor colorWithRed:(255.0/255) green:(0.0/255) blue:(0.0/255)alpha:1.0];
                    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button2 setTitle:@"拒绝" forState:UIControlStateNormal];
                    [button2 addTarget:self action:@selector(clickRefuseBtn:) forControlEvents:UIControlEventTouchUpInside];
                    button2.tag = 6;
                    [self.view addSubview:button2];
                }else if ([actoin isEqualToString:@"0"]){
                    [button1 setHidden:YES];
                    
                    if(arrys.count == 1){
                        [button2 setHidden:YES];
                        button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        button1.frame = CGRectMake(10, self.view.frame.size.height-textView.frame.size.height-10, self.view.frame.size.width-20, 30);
                        button1.layer.cornerRadius = 8.0;
                    }else{
                    
                    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    button1.frame = CGRectMake(0, self.view.frame.size.height-textView.frame.size.height-10, self.view.frame.size.width/2, 50);
                    
                    }
                    button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    button1.backgroundColor=[UIColor colorWithRed:(50.0/255) green:(205.0/255) blue:(50.0/255)alpha:1.0];
                    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button1 setTitle:@"同意" forState:UIControlStateNormal];
                    [button1 addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:button1];
                
                }
                
            }
            }
            }

//
//            NSLog(@"-------arrys-------%@",   [[arrys objectAtIndex:0] objectForKeyedSubscript:@"1"] );
//            
           
            
             [self send_GetAttachmentList_Msg];
            
   [self.myTableView reloadData];
        }else{
            NSString* errorMsg = [[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            
            if([@"-10001" isEqualToString:[[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrCode"]])
            {
                av.delegate = self;
                //返回登录界面
                [av setTag:1001];
            }
            
            [av show];
            [self performSelector:@selector(dimissAlert:) withObject:av afterDelay:3.0];
            
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }        NSLog(@"%@", error);
        
    }];
    
    
    //    [manager.operationQueue addOperation:operation];
    
}



- (void) send_GetAttachmentList_Msg
{
    //  NSString *eNumber = @"0000001";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetAttachmentList&loginName=%@&accesc_Token=%@&openId=%@&procInstID=%@",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID,ProcInstID];
    NSLog(@"send_GetAttachmentList_Msg:%@",url);
    //    NSDictionary *dict = @{@"":@""};
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* arry = [responseObject objectForKey:@"List"];
            if([arry count] ==0){
               
                
                return;
            }
            
            for(int i = 0; i < arry.count; ++i)
            {
                
                DocFile *doc = [[DocFile alloc] init];
                doc.AttachmentId =[[arry objectAtIndex:i] objectForKey:@"AttachmentId"];
                doc.FileName =[[arry objectAtIndex:i] objectForKey:@"FileName"];
                doc.FileExtensionName = [[arry objectAtIndex:i] objectForKey:@"FileExtensionName"];
                doc.UploadUserName = [[arry objectAtIndex:i] objectForKey:@"UploadUserName"];
//                [self.appsList addObject:doc];
                
            }
            
             [self.appsList addObject:arry];
            [self.myTableView reloadData];
        }else{
            
            NSString* errorMsg = [[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            if([@"-10001" isEqualToString:[[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrCode"]])
            {
                av.delegate = self;
                //返回登录界面
                [av setTag:1001];
            }
            
            [av show];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
        
        
        
    }];
    
    
    
    
}





//-(void) clickDocBarBackBtn:(id)sender
//{
//    
//    DocViewController* DocVC = [[DocViewController alloc] initWithNibName:@"DocViewController" bundle:NULL];
//    DocVC.title = @"流程附件";
//    NSString *P_SN = ProcInstID;
//    self._delegate = DocVC;
//    [self._delegate passValue:P_SN];
//    [self.navigationController pushViewController:DocVC animated:YES];
//    
//    
//}
-(void) processAction: (NSString *)actionName actionValue: (NSString *) actionValue
{

   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=ActionProcess&loginName=%@&accesc_Token=%@&openId=%@&ProcessSN=%@&approvalAction=%@&approvalActionValue=%@&approvalComment=%@",SERVERADDRESS,approval.ApproverLoginName,gAuthorizeCode,gOpenID,approval.ProcessSN,actionName,actionValue,textView.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            //            NSLog(@"------同意------成功");
            [self.view.window showHUDWithText:@"审批成功" Type:ShowPhotoYes Enabled:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSString* errorMsg = [[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrMsg"];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            if([@"-10001" isEqualToString:[[responseObject objectForKey:@"ResultMsg"] objectForKey:@"ErrCode"]])
            {
                av.delegate = self;
                //返回登录界面
                [av setTag:1001];
            }
            
            [av show];
        }
         NSLog(@"------url:------%@",url);
        NSLog(@"------responseObject:------%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
        
    }];
    
    

}
NSString *actionName = nil;
NSString *actionValue = nil;
-(void) clickAgreeBtn:(id)sender
{
    actionName=@"同意";
    actionValue=@"0";
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"(同意)确认操作"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
//                                                NSLog(@"确认--%@----%@",@"同意",actionValue);
                                                        [self processAction:actionName actionValue:actionValue];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
//                                                NSLog(@"Action 2 Handler Called");
                                            }]];
[self presentViewController:alert animated:YES completion:nil];
    }else{
    NSLog(@"Action Called");

        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"(同意)确认操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
        [sheet addButtonWithTitle:@"确认"];
    [sheet addButtonWithTitle:nil];
        [sheet showInView:self.view];
        }
  

}

-(void) clickhuiBtn:(id)sender
{
[self processAction:@"建议" actionValue:@"-1"];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"buttonIndex--------------%i", buttonIndex);
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"取消");
        return;
    }
    
    if (buttonIndex == 1) {
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
//        NSLog(@"确认--%@----%@",actionName,actionValue);
        [self processAction:actionName actionValue:actionValue];
    }
}


-(BOOL) clickRefuseBtn:(UIButton *)btn
{
   NSString *txtContext =  [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([txtContext isEqualToString:@""]){
        id obj=NSClassFromString(@"UIAlertController");
        if ( obj!=nil){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"请输入您的审批意见后执行拒绝操作"
                                                                preferredStyle:UIAlertControllerStyleAlert];
               [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                    //                                                    NSLog(@"Action 2 Handler Called");
                                                }]];

         [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入您的审批意见后执行拒绝操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
      
        }

        
    }else{

        NSLog(@"-----clickRefuseBtn:%i",btn.tag);
        actionName=@"拒绝";
        actionValue=[NSString stringWithFormat:@"%i",btn.tag];
        
        id obj=NSClassFromString(@"UIAlertController");
        if ( obj!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"(拒绝)确认操作"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
                                                        //                                                    NSLog(@"确认--%@----%@",@"同意",actionValue);
                                                        [self processAction:actionName actionValue:actionValue];
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        //                                                    NSLog(@"Action 2 Handler Called");
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            
            UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"(拒绝)确认操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
            [sheet addButtonWithTitle:@"确认"];
            [sheet addButtonWithTitle:nil];
            [sheet showInView:self.view];
        }
        

    
    }
    
    
   
   

}



-(void) clickreturnBtn:(id)sender
{
    
    
    
    NSString *txtContext =  [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([txtContext isEqualToString:@""]){
        
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入您的审批意见后执行退回发起人操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            
        
        
        
    }else{
        
        actionName=@"退回发起人";
        actionValue=@"4";

        
        id obj=NSClassFromString(@"UIAlertController");
        if ( obj!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"(退回发起人)确认操作"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
                                                        //                                                    NSLog(@"确认--%@----%@",@"同意",actionValue);
                                                        [self processAction:actionName actionValue:actionValue];
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        //                                                    NSLog(@"Action 2 Handler Called");
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            
            UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"(退回发起人)确认操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
            [sheet addButtonWithTitle:@"确认"];
            [sheet addButtonWithTitle:nil];
            [sheet showInView:self.view];
        }
        
        
        
    }
    

    


}
-(void) clickAddBtn:(id)sender
{
    
    ProcessAddViewController* feedbackVC = [[ProcessAddViewController alloc] initWithNibName:@"ProcessAddViewController" bundle:NULL];
    feedbackVC.title = @"流程加签";
    self._delegate = feedbackVC;
    
    [self._delegate passValue:approval];
    [self.navigationController pushViewController:feedbackVC animated:YES];

}




-(void) clickforwardBtn:(id)sender
{
    
    ProcessRedirectViewController* RedirectVC = [[ProcessRedirectViewController alloc] initWithNibName:@"ProcessRedirectViewController" bundle:NULL];
    RedirectVC.title = @"流程转签";
    self._delegate = RedirectVC;
    Approval *app = approval;
    [self._delegate passValue:app];
    [self.navigationController pushViewController:RedirectVC animated:YES];
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


#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return  self.appsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 NSArray *sectionq= self.appsList[section];
    
    return sectionq.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
//    CGFloat result = 50.0f;
//         return result;
//     }else{
//         CGFloat result = 40.0f;
//         return result;
//     }
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.frame.size.height <= 54){
        return 40.0f;
    }
    NSLog(@"cell.frame.size.height:%f",cell.frame.size.height);
     return cell.frame.size.height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ApprovalDetailTableViewCell *cell;
    //定义CustomCell的复用标识,这个就是刚才在CustomCell.xib中设置的那个Identifier,一定要相同,否则无法复用
    static NSString *identifier = @"ApprovalDetailIdentity";
    //根据复用标识查找TableView里是否有可复用的cell,有则返回给cell
    cell = (ApprovalDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //判断是否获取到复用cell,没有则从xib中初始化一个cell
    if (!cell) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovalDetailTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
        
    }
    cell.cellValue.backgroundColor = [UIColor clearColor];
    cell.cellValue.font = [UIFont systemFontOfSize:12];
    cell.cellValue.text = @"";

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
          cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
        
    }
    
     NSArray *section=self.appsList[indexPath.section];
    
    if(indexPath.section ==2){

        cell.cellValue.text =section[indexPath.row][@"FileName"];
        cell.cellID = section[indexPath.row][@"AttachmentId"];

        [cell.cellBtn setHidden:NO];
      
        cell.cellBtn.tag=indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    }else{
          NSString* data = (NSString*)section[indexPath.row];
        if(data.length >60){
//            NSLog(@"data:%i",data.length);
  
            cell.frame = CGRectMake(17, 8, 300, data.length);
            cell.cellValue.frame = CGRectMake(17, 8, 300, data.length);
        }else{
         cell.cellValue.frame = CGRectMake(17, 8, 300, 30);
        }
        cell.cellValue.text =data;
        
//         cell.cellValue.text =[NSString stringWithFormat:@"%@--说的就是贷款是否计算的咖啡喝的咖啡喝的交话费的快速房的恢复快的开发活动快速减肥好看的顺丰快递手放开还打算",data];
        [cell.cellBtn setHidden:YES];
    
    }

   
   
    return cell;
    
}
-(BOOL) clickBtn:(UIButton *)btn{
     NSArray *section=self.appsList[2];
    NSString *AttachmentId =section[btn.tag][@"AttachmentId"];
    NSString *FileName =section[btn.tag][@"FileName"];

    
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetAttachment&loginName=%@&accesc_Token=%@&openId=%@&attachmentId=%@",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID,AttachmentId];
    
    
    NSString *docType = FileName.pathExtension;
    if ([docType isEqualToString:@"zip"] || [docType isEqualToString:@"rar"] || [docType isEqualToString:@"msg"] ) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"当前文件类型不支持在移动端浏览" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
    }else if([docType isEqualToString:@"txt"]){
        
        OpenTxtViewController* openVC = [[OpenTxtViewController alloc] initWithNibName:@"OpenTxtViewController" bundle:NULL];
        openVC.title=FileName;
        self._delegate = openVC;
        [self._delegate passValue:url];
        [self.navigationController pushViewController:openVC animated:YES];
        
    }else{
        
        MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
        mainVC.title=FileName;
        mainVC.startPage = url;
        [self.navigationController pushViewController:mainVC animated:YES];
        
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
       if (section == 0) return @"基本信息";
       if (section == 1) return @"审批日志";
        if (section == 2) return @"流程附件";

    }

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [textView resignFirstResponder];
    [self.context resignFirstResponder];
    [self.nextResponder touchesEnded:touches withEvent:event];
}




#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* data = (NSString*)[self.popupList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.textLabel.text = data;

    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [popupList count];
}

#pragma mark - UIPopoverListViewDelegate
//- (void)popoverListView:(UIPopoverListView *)popoverListView
//     didSelectIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%s : %d", __func__, indexPath.row);
//    // your code here
//}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}



@end
