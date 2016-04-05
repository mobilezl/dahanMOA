//
//  SettingAppBgPicViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-28.
//
//

#import "SettingAppBgPicViewController.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "AppDefine.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "AppDefine.h"
#import "AFNetworkReachabilityManager.h"
#import "KeychainItemWrapper.h"
#import "AppBgPicInfo.h"
#import "DBManager.h"
#import "AppBgPicViewCell.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
@interface SettingAppBgPicViewController ()

@end

@implementation SettingAppBgPicViewController

@synthesize myTableView;
@synthesize myPicList;
@synthesize clickCount;
@synthesize selectedIndex;
@synthesize TitleLable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myPicList = [NSMutableArray arrayWithCapacity:5];
        clickCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        myTableView.frame = CGRectMake(225, 40, 320, 300);
        TitleLable.frame = CGRectMake(140, 0, 320, 40);
    }
    
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = barBackBtn;
    
    
    NSArray* arry = [[DBManager dbManager] executeFindAppPics];
    if([arry count] == 0)//第一次
    {
        AppBgPicInfo* defaultBgPic = [[AppBgPicInfo alloc] init];
        defaultBgPic.appBgPicID = @"defaultBgPic";
        defaultBgPic.appBgPicUrl = @"defaultBgPic";
        defaultBgPic.appBgPicPreviewUrl = @"defaultBgPic";
        defaultBgPic.appNavPicUrl = @"defaultNavBgPic";
        defaultBgPic.appMenuBarPicUrl = @"defaultMenuBarBgPic";
        defaultBgPic.bSelected = TRUE;
        self.selectedIndex = 0;
        [self.myPicList addObject:defaultBgPic];
    }
    else
    {
        for(int i = 0; i < [arry count]; ++i)
        {
            AppBgPicInfo* picInfo = [arry objectAtIndex:i];
            [self.myPicList addObject:picInfo];
        }
    }
    
//    [self send_GetBgPic_Msg];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) clickBarBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) clickMoreBgPics:(id)sender
{
    if(self.clickCount == 1)
    {
        [self.myTableView reloadData];
    }
    else
    {
        
        [self send_GetBgPic_Msg];
    }
}
#pragma ViewControllerDelegate Method


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
    //footView.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(110.0, 10.0, 100.0, 30.0)];
    btn.layer.cornerRadius = 12;
    [btn setBackgroundColor:[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitle:@"更多皮肤" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickMoreBgPics:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    return footView;
    
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  30.0;
}
 
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.myPicList count] == 1)
    {
        return 1;
    }

   NSInteger i = ([self.myPicList count]%2) ? ([self.myPicList count]/2+1) : ([self.myPicList count]/2);
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CELL = @"SETCELL";
    AppBgPicViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil)
    {
        cell = [[AppBgPicViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        
    }
    int index = indexPath.row * 2;
    
    [cell clearData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.previewImgNameLabel1.hidden = FALSE;
    cell.bgPreviewImgView2.hidden = FALSE;
    
    AppBgPicInfo* bgPicInfo1 = [self.myPicList objectAtIndex:index];
    cell.bgPicUrl1 = bgPicInfo1.appBgPicUrl;
    cell.bgPreviewPicUrl1 = bgPicInfo1.appBgPicPreviewUrl;
    cell.bgPicID1 = bgPicInfo1.appBgPicID;
    cell.bgNavPicUrl1 = bgPicInfo1.appNavPicUrl;
    cell.bgMenuBarPicUrl1 = bgPicInfo1.appMenuBarPicUrl;
    
    if(bgPicInfo1.bSelected)
    {
        cell.selectedMark.hidden = FALSE;
        cell.selectedIndex = 0;
    }
   
    NSString* str = @"";
    if(index == 0)
    {
        str = @"活波";
    }
    else
    {
        str = bgPicInfo1.appBgPicID;
    }
    cell.previewImgNameLabel1.text = str;
    
    if(index+1 < [self.myPicList count])
    {
        
        cell.previewImgNameLabel2.hidden = FALSE;
        cell.bgPreviewImgView2.hidden = FALSE;
        
        AppBgPicInfo* bgPicInfo2 = [self.myPicList objectAtIndex:index+1];
        cell.bgPicUrl2 = bgPicInfo2.appBgPicUrl;
        cell.bgPreviewPicUrl2 = bgPicInfo2.appBgPicPreviewUrl;
        cell.bgPicID2 = bgPicInfo2.appBgPicID;
        cell.bgNavPicUrl2 = bgPicInfo2.appNavPicUrl;
        cell.bgMenuBarPicUrl2 = bgPicInfo2.appMenuBarPicUrl;
        if(bgPicInfo2.bSelected)
        {
            cell.selectedMark.hidden = FALSE;
            cell.selectedIndex = 1;
        }
       
        str = [NSString stringWithFormat:@"第%d张图片", index+2];
        cell.previewImgNameLabel2.text = bgPicInfo2.appBgPicID;
    }
    else
    {
        cell.previewImgNameLabel2.hidden = TRUE;
        cell.bgPreviewImgView2.hidden = TRUE;
    }
    
    /*
    if(index+2 < [self.myPicList count])
    {
        
        cell.previewImgNameLabel3.hidden = FALSE;
        cell.bgPreviewImgView3.hidden = FALSE;
        
        AppBgPicInfo* bgPicInfo3 = [self.myPicList objectAtIndex:index+2];
        cell.bgPicUrl3 = bgPicInfo3.appBgPicUrl;
        cell.bgPreviewPicUrl3 = bgPicInfo3.appBgPicPreviewUrl;
        cell.bgPicID3 = bgPicInfo3.appBgPicID;
        cell.bgNavPicUrl3 = bgPicInfo3.appNavPicUrl;
        cell.bgMenuBarPicUrl3 = bgPicInfo3.appMenuBarPicUrl;
        if(bgPicInfo3.bSelected)
        {
            cell.selectedMark.hidden = FALSE;
            cell.selectedIndex = 2;
        }
       
        str = [NSString stringWithFormat:@"第%d张图片", index+3];
        cell.previewImgNameLabel3.text = str;
    }
    else
    {
        cell.previewImgNameLabel3.hidden = TRUE;
        cell.bgPreviewImgView3.hidden = TRUE;
    }
    */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //   [self send_GetBgPic_Msg];
    AppBgPicViewCell* cell = (AppBgPicViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell)
    {
        if(![cell.selectedBgPicID isEqualToString:@""])
        {
            for(int i = 0; i < [self.myPicList count]; ++i)
            {
                AppBgPicInfo* appBgInfo = [self.myPicList objectAtIndex:i];
                if([appBgInfo.appBgPicID isEqualToString:cell.selectedBgPicID])
                {
                    appBgInfo.bSelected = TRUE;
                }
                else
                {
                    appBgInfo.bSelected = FALSE;
                }
            }
            
            [[DBManager dbManager] executeUpdateAppPics:self.myPicList];
            
            UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            
            [self.myTableView reloadData];
        }
    }
}

- (void) updateData
{
    [self.myTableView reloadData];
}
- (void) send_GetBgPic_Msg
{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetTheme xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<openId>%@</openId>"
                             "</GetTheme>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout,  gAuthorizeCode, gOpenID];
    
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetTheme" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/ResourceService.asmx?op=GetTheme", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetThemeResponse"] objectForKey:@"GetThemeResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            
            NSArray* appPicsID = [[DBManager dbManager] getAppPicsID];
            NSMutableArray* savePicsInfo = [[NSMutableArray alloc] initWithCapacity:5];
           
            if([appPicsID count] == 0)
            {
                AppBgPicInfo* defaultBgPic = [[AppBgPicInfo alloc] init];
                defaultBgPic.appBgPicID = @"defaultBgPic";
                defaultBgPic.appBgPicUrl = @"defaultBgPic";
                defaultBgPic.appBgPicPreviewUrl = @"defaultBgPic";
                defaultBgPic.appNavPicUrl = @"defaultNavBgPic";
                defaultBgPic.appMenuBarPicUrl = @"defaultMenuBarBgPic";
                [savePicsInfo addObject:defaultBgPic];
            }
            NSArray* arry = [strJson objectForKey:@"PicList"];
            for(int i = 0; i < arry.count; ++i)
            {
                NSDictionary* picInfo = [arry objectAtIndex:i];
                AppBgPicInfo* bgPicInfo = [[AppBgPicInfo alloc] init];
                bgPicInfo.appBgPicID = [picInfo objectForKey:@"PicThemeName"];
                bgPicInfo.appBgPicUrl = [picInfo objectForKey:@"PicBodyUrl"];
                bgPicInfo.appNavPicUrl = [picInfo objectForKey:@"PicTopUrl"];
                bgPicInfo.appMenuBarPicUrl = [picInfo objectForKey:@"PicBottomUrl"];
                
                
                if(USEIP)
                {
                    bgPicInfo.appBgPicUrl = [bgPicInfo.appBgPicUrl stringByReplacingOccurrencesOfString:@"http://dahanis.eicp.net:25084" withString:@"http://180.173.162.211:25084"];
                }

                bgPicInfo.appBgPicPreviewUrl = [picInfo objectForKey:@"PicThemePreviewUrl"];
                
                if(USEIP)
                {
                    bgPicInfo.appBgPicPreviewUrl = [bgPicInfo.appBgPicPreviewUrl stringByReplacingOccurrencesOfString:@"http://dahanis.eicp.net:25084" withString:@"http://180.173.162.211:25084"];
                }
               
                bool bSame = false;
                for(int j = 0; j < [appPicsID count]; ++j)
                {
                    NSString* str = [appPicsID objectAtIndex:j];
                    if([str isEqualToString:bgPicInfo.appBgPicID])
                    {
                        bSame = true;
                        break;
                    }
                }
                if(!bSame)
                {
                    [self.myPicList addObject:bgPicInfo];
                    [savePicsInfo addObject:bgPicInfo];
                }
            }
            
            [[DBManager dbManager] executeSaveAppPics:savePicsInfo];
            [self performSelectorOnMainThread:@selector(updateData) withObject:nil waitUntilDone:YES];
            
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
