//
//  WorkFlowViewController.m
//  pgapp
//
//  Created by Leo on 14-9-18.
//
//

#import "WorkFlowViewController.h"
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
#import "ApprovalTableViewCell.h"
#import "MJRefresh.h"
#import "ProcessInfoViewController.h"
@interface WorkFlowViewController ()

@end

@implementation WorkFlowViewController
@synthesize myTableView;
@synthesize appsList;
@synthesize _delegate;


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
    
    //    [view release];
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    self.myTableView.rowHeight = 90;
//    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.myTableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    self.myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.myTableView];
    

    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];

//    NSLog(@"-------myTableView-------reloadData----%@",navImg);
    [self send_GetWaitApprovalList_Msg];
    
   
    

}
- (void)viewDidLoad
{
  
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
//        IconView.frame = CGRectMake(310, 80, 150, 150);
//        VersionLable.frame = CGRectMake(310, 220, 150, 50);
//        contexLabel.frame = CGRectMake(250, 560, 300, 50);
//        footLabel.frame = CGRectMake(210, 600, 400, 50);
//        
//        contexLabel.font = [UIFont systemFontOfSize:22.0];
//        footLabel.font = [UIFont systemFontOfSize:22.0];
    }
    
    float addHeight = 0.0;
    if(!IS_IPHONE_5)
    {
        addHeight = -88.0;
    }

    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
  
    


//    [self send_GetWaitApprovalList_Msg];
    [self setExtraCellLineHidden:myTableView];
    [self setupRefresh];
    
    
    
//    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
//                                                    
//                                                    initWithTarget:self action:@selector(myHandleTableviewCellLongPressed:)];
//    
//    longPressReger.minimumPressDuration = 1.0;
//    
//    [myTableView addGestureRecognizer:longPressReger];
    

    

    [self send_GetAppVer_Msg];
    
}
//长按事件
int num = 1;
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
     NSLog(@"------myHandleTableviewCellLongPressed------%i",num);
    //解决响应两次的问题
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if(num==1){
        num++;
        self.myTableView.frame = CGRectMake(0.0, 0.0, self.myTableView.frame.size.width,self.myTableView.frame.size.height-55);
        
            leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
            [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
            UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
            self.navigationItem.leftBarButtonItem = barBackBtn;
        button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame = CGRectMake(0, self.myTableView.frame.size.height, self.myTableView.frame.size.width/2, 50);
        button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button1.backgroundColor=[UIColor colorWithRed:(50.0/255) green:(205.0/255) blue:(50.0/255)alpha:1.0];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitle:@"同意" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(self.myTableView.frame.size.width/2, self.myTableView.frame.size.height, self.myTableView.frame.size.width/2, 50);
        button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button2.backgroundColor=[UIColor colorWithRed:(255.0/255) green:(0.0/255) blue:(0.0/255)alpha:1.0];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitle:@"拒绝" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(clickRefuseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button2];

        self.myTableView.allowsMultipleSelectionDuringEditing = YES;
        [self.myTableView setEditing: YES animated: YES];
        }else{
            return;
        }
    }
    
  
}



//同意操作
-(void) clickAgreeBtn:(id)sender
{
   
    // 选中的行
    NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
    
    // 是否删除特定的行
    BOOL deleteSpecificRows = selectedRows.count > 0;
    
    // 删除特定的行
    if (deleteSpecificRows)
    {
        // 将所选的行的索引值放在一个集合中进行批量删除
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        NSMutableArray *arry = [[NSMutableArray alloc] init];
        for (NSIndexPath *selectionIndex in selectedRows)
        {

            ApprovalTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectionIndex.row inSection:selectionIndex.section]];
           

             [arry addObject:cell.ProcessSN];
            
            
             [indicesOfItemsToDelete addIndex:selectionIndex.row];

        }
        
        if(arry.count > 0){
        
        NSString *str = [arry componentsJoinedByString:@","];
        NSString *actionName = @"同意";
                   int actionValue = 0;
        
         NSLog(@"------str------%@",str);

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=BatchActionProcess&loginName=%@&accesc_Token=%@&openId=%@&ProcessSNList=%@&approvalAction=%@&approvalActionValue=%i",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID,str,actionName,actionValue];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
            {
                  NSLog(@"------同意------成功");
                [self.appsList removeObjectsAtIndexes:indicesOfItemsToDelete];
                
                //删除所选的行
                [self.myTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            
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
    else
    {
          NSLog(@"------null--");
        // 删除全部
//        [self.dataArray removeAllObjects];
//        
//        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (self.myTableView.allowsMultipleSelectionDuringEditing == YES) {
        num=1;
        [leftBarBtn setHidden:YES];
        [button1 setHidden:YES];
        [button2 setHidden:YES];
         self.myTableView.frame = CGRectMake(0.0, 0.0, self.myTableView.frame.size.width,self.myTableView.frame.size.height+55);
    }
//
//    // 删除完成，退出编辑状态，并退出多选状态，同时更新导航栏的按钮
    [self.myTableView setEditing:NO animated:YES];
    
    self.myTableView.allowsMultipleSelectionDuringEditing = NO;


}
//拒绝操作
-(void) clickRefuseBtn:(id)sender
{
    // 选中的行
    NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
    
    // 是否删除特定的行
    BOOL deleteSpecificRows = selectedRows.count > 0;
    
    // 删除特定的行
    if (deleteSpecificRows)
    {
        // 将所选的行的索引值放在一个集合中进行批量删除
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        NSMutableArray *arry = [[NSMutableArray alloc] init];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            
            ApprovalTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectionIndex.row inSection:selectionIndex.section]];
            
            
            [arry addObject:cell.ProcessSN];
            
            
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            
        }
        
        if(arry.count > 0){
            
            NSString *str = [arry componentsJoinedByString:@","];
            NSString *actionName = @"拒绝";
            int actionValue = 6;
            
            NSLog(@"------str------%@",str);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=BatchActionProcess&loginName=%@&accesc_Token=%@&openId=%@&ProcessSNList=%@&approvalAction=%@&approvalActionValue=%i",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID,str,actionName,actionValue];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
                {
                    NSLog(@"------拒绝------成功");
                    [self.appsList removeObjectsAtIndexes:indicesOfItemsToDelete];
                    
                    //删除所选的行
                    [self.myTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
                    
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
    else
    {
        NSLog(@"------null--");
        // 删除全部
        //        [self.dataArray removeAllObjects];
        //
        //        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (self.myTableView.allowsMultipleSelectionDuringEditing == YES) {
        num=1;
        [leftBarBtn setHidden:YES];
        [button1 setHidden:YES];
        [button2 setHidden:YES];
        self.myTableView.frame = CGRectMake(0.0, 0.0, self.myTableView.frame.size.width,self.myTableView.frame.size.height+55);
    }
    //
    //    // 删除完成，退出编辑状态，并退出多选状态，同时更新导航栏的按钮
    [self.myTableView setEditing:NO animated:YES];
    
    self.myTableView.allowsMultipleSelectionDuringEditing = NO;

    
}

-(void) clickBarBackBtn:(id)sender
{
    if(self.myTableView.allowsMultipleSelectionDuringEditing == YES){
        [leftBarBtn setHidden:YES];
        [button1 setHidden:YES];
        [button2 setHidden:YES];
        self.myTableView.frame = CGRectMake(0.0, 0.0, self.myTableView.frame.size.width,self.myTableView.frame.size.height+55);
        num=1;
    
    }

    [self.myTableView setEditing:NO animated:YES];
    self.myTableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



int next = 1;
- (void) send_GetWaitApprovalList_Msg
{
    next=1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//     NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetWaitApprovalList&loginName=%@&accesc_Token=%@&openId=%@&startPage=1&pageCount=15",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID];
    
    
      NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetWaitApprovalList&loginName=%@&accesc_Token=%@&openId=%@&startPage=1&pageCount=15",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID];
    NSLog(@"url---%@",url);
   
//    NSDictionary *dict = @{@"":@""};
[manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

    
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {

            NSString * str =[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"TotalPages"] description]];
            TotalPages = [str intValue];
//            if (TotalPages >0  ) {
                self.title=[NSString stringWithFormat:@"流程待办 (%d)",TotalPages];
//            }
            

            

                    NSArray* arry = [responseObject objectForKey:@"WaitApprovalListList"];
            
           

            
                     [self.appsList removeAllObjects];

                       for(int i = 0; i < arry.count; ++i)
                       {
                           
                           Approval* approval = [[Approval alloc] init];
                           approval.ProcessSN = [[arry objectAtIndex:i] objectForKey:@"ProcessSN"];
                           approval.ProcessName = [[arry objectAtIndex:i] objectForKey:@"ProcessName"];
                           approval.Submitter = [[arry objectAtIndex:i] objectForKey:@"Submitter"];
                           approval.SubmitDate = [[arry objectAtIndex:i] objectForKey:@"SubmitDate"];
                           approval.Preview = [[arry objectAtIndex:i] objectForKey:@"Preview"];
                           approval.ProcessType = [[arry objectAtIndex:i] objectForKey:@"processType"];
                           approval.ActionPermit = [[arry objectAtIndex:i] objectForKey:@"ActionPermit"];
                            approval.ApproverLoginName = [[arry objectAtIndex:i] objectForKey:@"ApproverLoginName"];
                        
                           [self.appsList addObject:approval];
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
                   }else{
                       UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"流程数据异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                       [av show];
                   }

        NSLog(@"%@", error);

        
        
    }];
    
   
//    [manager.operationQueue addOperation:operation];
    
}
//加载审批列表数据
- (void) send_GetWaitApprovalList_Msg_pullUp
{
     next++;

   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetWaitApprovalList&loginName=%@&accesc_Token=%@&openId=%@&startPage=%i&pageCount=15",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID,next];
    //    NSDictionary *dict = @{@"":@""};
    
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* arry = [responseObject objectForKey:@"WaitApprovalListList"];
//            [self.appsList removeAllObjects];
            
            for(int i = 0; i < arry.count; ++i)
            {
                
                Approval* approval = [[Approval alloc] init];
                approval.ProcessSN = [[arry objectAtIndex:i] objectForKey:@"ProcessSN"];
                approval.ProcessName = [[arry objectAtIndex:i] objectForKey:@"ProcessName"];
                approval.Submitter = [[arry objectAtIndex:i] objectForKey:@"Submitter"];
                approval.SubmitDate = [[arry objectAtIndex:i] objectForKey:@"SubmitDate"];
                approval.Preview = [[arry objectAtIndex:i] objectForKey:@"Preview"];
                approval.ProcessType = [[arry objectAtIndex:i] objectForKey:@"processType"];
                approval.ActionPermit = [[arry objectAtIndex:i] objectForKey:@"ActionPermit"];
                approval.ApproverLoginName = [[arry objectAtIndex:i] objectForKey:@"ApproverLoginName"];
                
                [self.appsList addObject:approval];
//            NSLog(@"-------approval-------%@",   approval.ProcessSN);
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
        
        //           NSLog(@"--------------%@",  responseObject);
        
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
        
        
    }else if(alertView.tag == 1002 && buttonIndex == 1){
        
                    NSString *urlString = gDownLoadUrl;
        
                    NSURL *url  = [NSURL URLWithString:urlString];
        
                   [[UIApplication sharedApplication] openURL:url];
            
        }
}


#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"-[self.appsList count]---%i",[self.appsList count]);
    
 
    return [appsList count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 40.0f;
    if ([tableView isEqual:self.myTableView]){
        result = 80.0f;
    }
    return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApprovalTableViewCell *cell;
    //定义CustomCell的复用标识,这个就是刚才在CustomCell.xib中设置的那个Identifier,一定要相同,否则无法复用
    static NSString *identifier = @"ApprovalCellIdentifier";
    //根据复用标识查找TableView里是否有可复用的cell,有则返回给cell
    cell = (ApprovalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //判断是否获取到复用cell,没有则从xib中初始化一个cell
    if (!cell) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApprovalTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];

    }

    
    Approval* approval = (Approval*)[self.appsList objectAtIndex:indexPath.row];
    cell.ProcessName.text=approval.ProcessName;
    cell.Submitter.text=approval.Submitter;
    cell.Preview.text= approval.Preview;
    cell.SubmitDate.text=approval.SubmitDate;
    cell.ProcessSN = approval.ProcessSN;
    cell.processType=approval.ProcessType;
    cell.ApproverLoginName = approval.ApproverLoginName;

  


//    NSLog(@"-------approval-------%@",   approval.ProcessType);
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.myTableView.allowsMultipleSelectionDuringEditing == NO) {
    ApprovalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    NSLog(@"------%@--%@", cell.ProcessSN,cell.processType);
    // 发送代理，并把文本框中的值传过去
    
    ProcessInfoViewController* feedbackVC = [[ProcessInfoViewController alloc] initWithNibName:@"ProcessInfoViewController" bundle:NULL];
       
        
        
    feedbackVC.title = cell.ProcessName.text;
     self._delegate = feedbackVC;
    
    Approval *approval = [[Approval alloc] init];
    approval.ProcessSN = cell.ProcessSN;
    approval.ProcessName = cell.ProcessName.text;
    approval.ProcessType = cell.processType;
    approval.ApproverLoginName = cell.ApproverLoginName;
    [self._delegate passValue:approval];

    [self.navigationController pushViewController:feedbackVC animated:YES];
 }
 
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.myTableView headerBeginRefreshing];


  

//    if (TotalPages > 3) {
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    }
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.myTableView.headerPullToRefreshText = @"下拉刷新";
    self.myTableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.myTableView.headerRefreshingText = @"正在刷新中...";
    
    self.myTableView.footerPullToRefreshText = @"上拉加载更多数据";
    self.myTableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.myTableView.footerRefreshingText = @"正在加载中...";
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
   

    [self send_GetWaitApprovalList_Msg];

    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
    });
}
- (void)footerRereshing
{

    [self send_GetWaitApprovalList_Msg_pullUp];
    


    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView footerEndRefreshing];
    });
    
    
    
}




-(void) send_GetAppVer_Msg
{
    
    
    if([gAppVer isEqualToString:glocalVersion])
    {
        
    }
    else
    {
        
        NSString* msg = [NSString stringWithFormat:@"发现最新版本V%@", gAppVer];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
        av.tag = 1002;
        [av show];
    }
    
}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"more";
//}
//
//
//
//
////	单实现该接口..
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//	return UITableViewCellEditingStyleDelete;
//	//不能是UITableViewCellEditingStyleNone
//}
//
//
////点击删除按钮后, 会触发如下事件. 在该事件中做响应动作就可以了
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath {
////    ApprovalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
////    NSLog(@"-editingStyle-----%@--%@", cell.ProcessSN,cell.processType);
////    
////    
////    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
////        if (indexPath.row<[self.appsList count]) {
////            [self.appsList removeObjectAtIndex:indexPath.row];//移除数据源的数据
////            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
////        }
////    }
//    
//    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Select action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
//    [sheet addButtonWithTitle:@"Reload test"];
//    [sheet addButtonWithTitle:@"Multiselect test"];
//    [sheet addButtonWithTitle:@"Change accessory button"];
////    if (!_testingStoryboardCell) {
////        [sheet addButtonWithTitle:@"Storyboard test"];
////    }
//    
//    
//    [sheet showInView:self.view];
//
//}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//     NSLog(@"buttonIndex--------------%i", buttonIndex);
//    
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    
//    if (buttonIndex == 1) {
//
//        [self.myTableView reloadData];
//    }
//    else if (buttonIndex == 2) {
//        self.myTableView.allowsMultipleSelectionDuringEditing = YES;
//        [self.myTableView setEditing: YES animated: YES];
//        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
//       
//    }}
@end
