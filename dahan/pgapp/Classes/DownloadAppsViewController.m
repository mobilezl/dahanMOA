//
//  DownloadAppsViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-24.
//
//

#import "DownloadAppsViewController.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "AppDefine.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "AppInfo.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
@interface DownloadAppsViewController ()

@end

@implementation DownloadAppsViewController

@synthesize myTableView;
@synthesize appsList;

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
    
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 58.0,28.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = barBackBtn;
    /*
    if(![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
     */
    [self send_GetAppMarketList_Msg];
    [self setExtraCellLineHidden:myTableView];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}
- (void)send_GetAppMarketList_Msg
{
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetAppMarketListByTerminal xmlns=\"http://tempuri.org/\">"
                             "<userID>%@</userID>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<terminal>2</terminal>"
                             "<openId>%@</openId>"
                             "</GetAppMarketListByTerminal>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout,  gAuthorizeCode, gOpenID];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetAppMarketListByTerminal" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/ResourceService.asmx?op=GetAppMarketListByTerminal", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetAppMarketListByTerminalResponse"] objectForKey:@"GetAppMarketListByTerminalResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* installedAppsInfo= [[DBManager dbManager] executeFindAppInfos];
            
            NSArray* arry = [strJson objectForKey:@"AppList"];
            for(int i = 0; i < arry.count; ++i)
            {
                AppInfo* appInfo = [[AppInfo alloc] init];
                appInfo.appDes = [[arry objectAtIndex:i] objectForKey:@"AppDes"];
                appInfo.appIconUrl = [[arry objectAtIndex:i] objectForKey:@"AppIcon"];
                appInfo.homeIcon = [[arry objectAtIndex:i] objectForKey:@"HomeIcon"];
                if(USEIP)
                {
                    appInfo.appIconUrl = [appInfo.appIconUrl stringByReplacingOccurrencesOfString:@"http://dahanis.eicp.net:25084" withString:@"http://180.173.162.211:25084"];
                }

                appInfo.appID = [[arry objectAtIndex:i] objectForKey:@"AppId"];
                appInfo.appLocalUrl = [[arry objectAtIndex:i] objectForKey:@"AppLocalUrl"];
                appInfo.appName = [[arry objectAtIndex:i] objectForKey:@"AppName"];
                appInfo.appSize = [[[arry objectAtIndex:i] objectForKey:@"AppSize"] doubleValue];
                appInfo.appType = [[[arry objectAtIndex:i] objectForKey:@"AppType"] integerValue];
                appInfo.appVersion = [[arry objectAtIndex:i] objectForKey:@"AppVer"];
                appInfo.appAuthoriy = [[arry objectAtIndex:i] objectForKey:@"Authoriy"];
                appInfo.appIndex = i;
                appInfo.appDownLoadUrl = [[arry objectAtIndex:i] objectForKey:@"AppUrl"];
                
                if(USEIP)
                {
                    appInfo.appDownLoadUrl = [appInfo.appDownLoadUrl stringByReplacingOccurrencesOfString:@"http://dahanis.eicp.net:25084" withString:@"http://180.173.162.211:25084"];
                }

                appInfo.appSatate = 1;
                appInfo.pgComPkgVer = [[arry objectAtIndex:i] objectForKey:@"PgComPkgVer"];
                [self.appsList addObject:appInfo];
                
                
                if(appInfo.appType == 1)
                {
                    //检查第三方应用是否已经安装
                    
                }
                bool binstalled = false;
                for(int j = 0; j < installedAppsInfo.count; ++j)
                {
                    AppInfo* installedAppInfo = [installedAppsInfo objectAtIndex:j];
                    if([appInfo.appID isEqualToString:installedAppInfo.appID])
                    {
                        //检查版本号
                        if(![appInfo.appVersion isEqualToString:installedAppInfo.appVersion])
                        {
                            appInfo.appSatate = 4;  //需要更新
                        }
                        else
                        {
                            appInfo.appSatate = 3;
                        }
                        break;
                    }
                }
                
            }
            
            [self.myTableView reloadData];
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
#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 69.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CELL = @"SETCELL";
    DownloadViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil)
    {
        cell = [[DownloadViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        
    }
    
    [cell clearData];
    
    AppInfo* appInfo = (AppInfo*)[self.appsList objectAtIndex:indexPath.row];
    
    cell.appID = appInfo.appID;
    cell.strAppIconUrl = appInfo.appIconUrl;
    cell.appNameLabel.text = appInfo.appName;
    cell.strAppUrl = appInfo.appDownLoadUrl;
    cell.pgComPkgVer = appInfo.pgComPkgVer;
    
    int add = (int)appInfo.appSize;
    NSString* str = @"";
    if(add == 0)
    {
        str = [NSString stringWithFormat:@"大小 %0.2fkb",appInfo.appSize];
    }
    else
    {
        
        str = [NSString stringWithFormat:@"大小:%dkb",(int)(appInfo.appSize)];
    }
    
    cell.appSizeLabel.text = str;
    cell.appSatate = appInfo.appSatate;
    cell.myDelegate = self;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            /*
            StyleSettingViewController* styleSetVC = [[StyleSettingViewController alloc] initWithNibName:@"StyleSettingViewController" bundle:nil];
            styleSetVC.myDelegate = self;
            [self.navigationController pushViewController:styleSetVC animated:YES];
             */
        }
            break;
            
        default:
            break;
    }
}

#pragma DownloadVCDelegate methods
-(void) clickSatateBtn:(DownloadViewCell*) sender
{
    if(sender.appSatate == 1)
    {
        //已经被删除
        for(int i = 0; i < self.appsList.count; ++i)
        {
            AppInfo* appInfo = [self.appsList objectAtIndex:i];
            if([appInfo.appID isEqualToString:sender.appID])
            {
                appInfo.appSatate = 1;
                NSArray* arry = [NSArray arrayWithObject:appInfo];
                [[DBManager dbManager] executeDeleteApps:arry];
                break;
            }
        }
    }
    else if(sender.appSatate == 2)
    {//更新状态
        for(int i = 0; i < self.appsList.count; ++i)
        {
            AppInfo* appInfo = [self.appsList objectAtIndex:i];
            if([appInfo.appID isEqualToString:sender.appID])
            {
                appInfo.appSatate = 2;
                break;
            }
        }

    }
    else if(sender.appSatate == 3)
    {
        //已经安装成功
        for(int i = 0; i < self.appsList.count; ++i)
        {
            NSString* appID = sender.appID;
            AppInfo* appInfo = [self.appsList objectAtIndex:i];
            if([appInfo.appID isEqualToString:sender.appID])
            {
                appInfo.appSatate = 3;
                NSArray* arry = [NSArray arrayWithObject:appInfo];
                //先在数据库中删除这个应用记录，防止更新应用的时候
                [[DBManager dbManager] executeDeleteApps:arry];
                //
                [[DBManager dbManager] executeSaveAppInfos:arry];
                break;
            }
        }
    }
    else if(sender.appSatate == 5)
    {
        for(int i = 0; i < self.appsList.count; ++i)
        {
            AppInfo* appInfo = [self.appsList objectAtIndex:i];
            if([appInfo.appID isEqualToString:sender.appID])
            {
                appInfo.appSatate = 5;
                break;
            }
        }
    }
    
    [self.myTableView reloadData];
}

-(void) backLoginNotification:(DownloadViewCell*) sender
{
    //返回登录界面
    LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:loginVC animated:YES completion:nil];
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
