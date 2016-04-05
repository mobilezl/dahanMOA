//
//  ProcessRedirectViewController.m
//  pgapp
//
//  Created by Leo on 14-10-11.
//
//

#import "ProcessRedirectViewController.h"
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
#import "SearchUser.h"
#import "SearchTableViewCell.h"
#import "UIWindow+YzdHUD.h"

@interface ProcessRedirectViewController ()
@end
@implementation ProcessRedirectViewController
@synthesize myTableView;
@synthesize appsList;
 NSString *userID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appsList = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    self.myTableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    self.myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    self.myTableView.frame =CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-160);
    _index = -1;
    [self.view addSubview:self.myTableView];
    
    
    
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
        self.SearchText.frame = CGRectMake(10, 10, screenWidth-80, 30);
        self.SeaBtn.frame = CGRectMake(screenWidth-80, 10, 80, 30);
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
    [self setExtraCellLineHidden:myTableView];
//    [self send_SearchRedirectTosByKey_Msg:@"钟"];
    
//    self.myTableView.allowsMultipleSelectionDuringEditing = YES;
//    [self.myTableView setEditing: YES animated: YES];
    
    
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0, self.view.frame.size.height-(172+addHeight), self.view.frame.size.width/2, 50);
    button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button1.backgroundColor=[UIColor colorWithRed:(50.0/255) green:(205.0/255) blue:(50.0/255)alpha:1.0];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:@"确认" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button2.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-(172+addHeight), self.view.frame.size.width/2, 50);
    button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button2.backgroundColor=[UIColor colorWithRed:(176.0/255) green:(196.0/255) blue:(222.0/255)alpha:1.0];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitle:@"取消" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-(228+addHeight), self.view.frame.size.width-20, 50)];
    }else{
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-(228+addHeight), 300, 50)];
        
    }

    textView.layer.borderColor=UIColor.grayColor.CGColor;
    textView.layer.borderWidth = 1;
    
    [self.view addSubview:textView];
    textView.returnKeyType=UIReturnKeyDone;
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.frame =CGRectMake(textView.frame.origin.x+5.0, textView.frame.origin.y-4, 270.0, 40.0);
    self.placeholderLabel.text = @"您的转签意见";
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
    
    
    //    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    //    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    //    tapGestureRecognizer.cancelsTouchesInView = NO;
    //    //将触摸事件添加到当前view
    //    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
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
    [textView resignFirstResponder];
    [self.SearchText resignFirstResponder];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.SearchText resignFirstResponder];
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
        self.placeholderLabel.text = @"您的转签意见";
    }else{
        self.placeholderLabel.text = @"";
    }
}
-(void) clickAgreeBtn:(id)sender
{
    NSLog(@"-----------clickAgreeBtn------%@---------%@",app.ProcessSN,userID);
    if ( [[userID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        NSLog(@"userID is null.........");
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择转签人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
    }else{
        NSString *txtContext =  [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([txtContext isEqualToString:@""]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入转签意见后执行确认" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            return;
            
        }

            NSString *actionName = @"转签";
            int actionValue = 3;
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=RedirectProcess&loginName=%@&accesc_Token=%@&openId=%@&ProcessSN=%@&RedirectAction=%@&RedirectValue=%i&RedirectComment=%@&RedirectTos=%@",SERVERADDRESS,app.ApproverLoginName,gAuthorizeCode,gOpenID,app.ProcessSN,actionName,actionValue,textView.text,userID];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
                {
                    //            NSLog(@"------同意------成功");
                    [self.view.window showHUDWithText:@"转签成功" Type:ShowPhotoYes Enabled:YES];
                    
                    int index=[[self.navigationController viewControllers]indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                    
                    
                    
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
Approval * app=nil;
-(void) passValue:(id)value {
    
    app = value;
    NSLog(@"-----approval = %@-----",app.ProcessSN);
}

- (void) send_SearchRedirectTosByKey_Msg:(NSString *)key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=SearchRedirectTosByKey&loginName=%@&accesc_Token=%@&openId=%@&Key=%@",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID,key];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* arry = [responseObject objectForKey:@"ResultList"];
            [self.appsList removeAllObjects];
            
            for(int i = 0; i < arry.count; ++i)
            {
                
                SearchUser * user = [[SearchUser alloc] init];
                user.UserID = [[arry objectAtIndex:i] objectForKey:@"UserID"];
                user.UserName = [[arry objectAtIndex:i] objectForKey:@"UserName"];
                user.DeptName = [[arry objectAtIndex:i] objectForKey:@"DeptName"];
                user.Title = [[arry objectAtIndex:i] objectForKey:@"Title"];
                [self.appsList addObject:user];
                //                          NSLog(@"-------approval-------%@",   approval.SubmitDate);
            }
            
            
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
        
        //           NSLog(@"--------------%i@",  [self.appsList count]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
        
    }];
    
    
    //    [manager.operationQueue addOperation:operation];
    
}

#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [appsList count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 40.0f;
    return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchTableViewCell *cell;
    //定义CustomCell的复用标识,这个就是刚才在CustomCell.xib中设置的那个Identifier,一定要相同,否则无法复用
    static NSString *identifier = @"SearchCellIdentifier";
    //根据复用标识查找TableView里是否有可复用的cell,有则返回给cell
    cell = (SearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //判断是否获取到复用cell,没有则从xib中初始化一个cell
    if (!cell) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
        
    }
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        cell.UserName.font = [UIFont fontWithName:@"Arial" size:16];
        cell.Title.font = [UIFont fontWithName:@"Arial" size:16];
    }
    
    SearchUser* user = (SearchUser*)[self.appsList objectAtIndex:indexPath.row];
    cell.UserID=user.UserID;
    cell.UserName.text=user.UserName;
    cell.Title.text=user.DeptName;
    
    if (_index == indexPath.row) {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }else{
    cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //上一选择
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
     SearchTableViewCell *lastcell = [tableView cellForRowAtIndexPath:lastIndex];
    lastcell.accessoryType = UITableViewCellAccessoryNone;
    //当前选择
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    _index = indexPath.row;
    
    [myTableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.5];
    
    userID=cell.UserID;
    NSLog(@"----UserID--%@",cell.UserID);
}





- (IBAction)SearchBtn:(id)sender {
    if ( [[self.SearchText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        NSLog(@"-----SearchText--- true----%@",self.SearchText.text);
  
        [self.SearchText resignFirstResponder];
        return;
    }else{
        
        NSLog(@"-----SearchText----flase---%@",self.SearchText.text);
        [self send_SearchRedirectTosByKey_Msg:self.SearchText.text];
        

               [self.SearchText resignFirstResponder];
    }
    
    
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
