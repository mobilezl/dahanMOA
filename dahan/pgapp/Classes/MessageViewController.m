//
//  MessageViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-18.
//
//

#import "MessageViewController.h"
#import "DBManager.h"
#import "MsgViewCell.h"
#import "AppMsgInfo.h"
#import "MainViewController.h"
#import "AppDefine.h"
#import "AppMsgInfo.h"
#import "SBJson.h"
#import "XMLHelper.h"
#import "MainTabBarViewController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize msgsList;
@synthesize myTableView;
@synthesize tipLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         msgsList = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(gStyleType == 0)
    {
       // self.hidesBottomBarWhenPushed = NO;
    }
    [self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:YES];
    
    if(gNotificationDownloadMsg)
    {
        [self send_PullMessage_Msg];
    }
    else
    {
        
        self.msgsList = [[DBManager dbManager] executeFindAppMsgs];
        if([self.msgsList count] == 0)
        {
//            self.tipLabel.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            self.tipLabel.text = @"暂时无消息";
            
            self.tipLabel.hidden = FALSE;
            self.myTableView.hidden = TRUE;
        }
        else
        {
            self.tipLabel.hidden = TRUE;
            self.myTableView.hidden = FALSE;
        }
        [self.myTableView reloadData];
    }
}

-(void) clickBarBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    // Do any additional setup after loading the view from its nib.

    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = barBackBtn;
    
    [self setExtraCellLineHidden:myTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "</PullMessage>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode, gOpenID];
    
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
            
            
            self.msgsList = [[DBManager dbManager] executeFindAppMsgs];
            if([self.msgsList count] == 0)
            {
                self.tipLabel.text = @"暂时无消息";
                self.tipLabel.hidden = FALSE;
                self.myTableView.hidden = TRUE;
            }
            else
            {
                self.tipLabel.hidden = TRUE;
                self.myTableView.hidden = FALSE;
            }
            [self.myTableView reloadData];
            
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


#pragma ViewControllerDelegate Method

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        AppMsgInfo* msgInfo = (AppMsgInfo*)[self.msgsList objectAtIndex:indexPath.row];
        NSMutableArray* muArr = [NSMutableArray arrayWithCapacity:5];
        [muArr addObject:msgInfo];
        BOOL b = [[DBManager dbManager] executeDeleteAppMsgs:muArr];
        if(b)
        {
            
        }
        [self.msgsList removeAllObjects];
        self.msgsList = [[DBManager dbManager] executeFindAppMsgs];
        [self.myTableView reloadData];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CELL = @"MSGCELL";
    MsgViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil)
    {
        cell = [[MsgViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        
    }
    
    [cell clearData];
    
    AppMsgInfo* msgInfo = (AppMsgInfo*)[self.msgsList objectAtIndex:indexPath.row];
    
    cell.msgID = msgInfo.msgID;
    cell.strMsgIconUrl = msgInfo.msgIcon;
    cell.appNameLabel.text = msgInfo.appName;
    cell.msgContentLabel.text = msgInfo.msgContent;
    if(msgInfo.isRead)
    {
        cell.markLabel.text = @"已读";
    }
    else
    {
        cell.markLabel.text = @"未读";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [gParametersForJS removeAllObjects];
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    AppMsgInfo* msgInfo = [self.msgsList objectAtIndex:indexPath.row];
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainVC.title = msgInfo.appName;
    
    //检查该消息是否是未读，如是，则标记为已读
    if(!msgInfo.isRead)
    {
        msgInfo.isRead = TRUE;
        NSMutableArray* muArr = [NSMutableArray arrayWithCapacity:5];
        [muArr addObject:msgInfo];
        [[DBManager dbManager] executeUpdateAppMsgs:muArr];
        
        [self.msgsList removeAllObjects];
        self.msgsList = [[DBManager dbManager] executeFindAppMsgs];
        
    }
    if([msgInfo.appID isEqualToString:@"xinwen"]
       ||
       [msgInfo.appID isEqualToString:@"gonggao"]
       ||
       [msgInfo.appID isEqualToString:@"liuchenggenzong"]
       ||
       [msgInfo.appID isEqualToString:@"liuchengfaqi"]
       ||
       [msgInfo.appID isEqualToString:@"baobiao"]
       )
    {
        mainVC.startPage = [msgInfo.appEntry substringFromIndex:1];
        mainVC.appKey = msgInfo.appKey;
    }
    else if([msgInfo.appID isEqualToString:@"liuchengshenpi"])
    {
        mainVC.startPage = @"apps/approval/index.html";
        mainVC.appKey = msgInfo.appKey;

         }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"www"];
        mainVC.wwwFolderName = [@"file://" stringByAppendingString:documentsDirectory];
        mainVC.startPage = [msgInfo.appEntry substringFromIndex:1];
        mainVC.startPage = [mainVC.startPage stringByReplacingOccurrencesOfString:@"apps" withString:@"Apps"];
        mainVC.appKey = msgInfo.appKey;
    }
    
    NSLog(@"msgID=%@, appKey=%@, startPage=%@", msgInfo.msgID, msgInfo.appKey, mainVC.startPage);
    
    MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];
    
    [vcs hideSegmentButton:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    vcs.tabBar.hidden = NO;

    
    [self.navigationController pushViewController:mainVC animated:YES];
    
}


@end
