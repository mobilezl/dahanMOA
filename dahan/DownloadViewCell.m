//
//  DownloadViewCell.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-24.
//
//

#import "DownloadViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AppDefine.h"
#import "ZipArchive.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "XMLHelper.h"

@implementation DownloadViewCell

@synthesize appImgView;
@synthesize appNameLabel;
@synthesize appSatateBtn;
@synthesize appSizeLabel;
@synthesize appID;
@synthesize myDelegate;
@synthesize appSatate;
@synthesize strAppUrl;
@synthesize pgComPkgVer;
@synthesize bDownLoadPgComPkg;

-(NSString* )pathInDocumentDirectory:(NSString *)fileName
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    if([fileName isEqualToString:@""])
    {
        return  docPath;
    }

    return [docPath stringByAppendingPathComponent:fileName];
}

//创建文件夹
-(BOOL) createDirInDoc:(NSString *)dirName
{
    NSString *docDir = [self pathInDocumentDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:docDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}


-(NSString*) getFileName:(NSString*) filePath
{
    NSString* str = self.strAppUrl;
    NSRange r = [str rangeOfString:@"http://dahanis.eicp.net:25084/Resource/app/"];
    NSString* str1 = [str substringFromIndex:r.length];
    
    //获得压缩文件名
    NSArray* speArry = [str1 componentsSeparatedByString:@"/"];
    int totalCount = speArry.count;
    NSString* str2 = [speArry objectAtIndex:totalCount-1];
    return str2;//[filePath stringByAppendingPathComponent:str2];
    
}

- (void) send_GetPgComPkgUrl_Msg:(NSString*) pgComVer
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
                             "<GetPgComPkgUrlByTerminal xmlns=\"http://tempuri.org/\">"
                             "<userID>%@</userID>"
                             "<versionCode>%@</versionCode>"
                             "<accesc_Token>%@</accesc_Token>"
                             "<terminal>2</terminal>"
                             "<openId>%@</openId>"
                             "</GetPgComPkgUrlByTerminal>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, self.pgComPkgVer, gAuthorizeCode, gOpenID];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/GetPgComPkgUrlByTerminal" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/ResourceService.asmx?op=GetPgComPkgUrlByTerminal", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        NSString* textDic = [[[[[dic objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"GetPgComPkgUrlByTerminalResponse"] objectForKey:@"GetPgComPkgUrlByTerminalResult"] objectForKey:@"text"];
        
        NSDictionary* strJson = [textDic JSONValue];
        
        if([[strJson objectForKey:@"Result"] isEqualToString:@"1"])
        {
            NSString* pgComUrl = [strJson objectForKey:@"Url"];
            if(USEIP)
            {
                pgComUrl = [pgComUrl stringByReplacingOccurrencesOfString:@"http://dahanis.eicp.net:25084" withString:@"http://180.173.162.211:25084"];
            }

            [self downloadPgCom:pgComUrl];
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


-(void) downloadPgCom:(NSString*) pgUrl
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
   // [self createDirInDoc:@"Framework"];
    NSString* filePath = [self pathInDocumentDirectory:@""];
    
    NSString* fileName = [self getFileName:filePath];
    NSString* downloadDocPath = [filePath stringByAppendingPathComponent:@"Framework.zip"];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:pgUrl parameters:nil error:nil];
    
    //@"http://180.173.162.211:25084/Resource/app/approval.zip"
    
    __weak __typeof(self)weakSelf = self;
    
    BOOL b = self.appDownLoadOK;
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解压缩
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        ZipArchive* zip = [[ZipArchive alloc] init];
        if( [zip UnzipOpenFile:downloadDocPath] )
        {
            BOOL ret = [zip UnzipFileTo:filePath overWrite:YES];
            if( NO==ret )
            {
                NSLog(@"解压文件%@发生错误", downloadDocPath);
            }
            else
            {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:strongSelf.pgComPkgVer forKey:@"pgComPgkVer"];
                strongSelf.bDownLoadPgComPkg = FALSE;
                
                 NSLog(@"PGCOM已经下载好");
                //下载成功
                strongSelf.appSatate = 3;
                [strongSelf backDelegate];
             
                
            }
            [zip UnzipCloseFile];
        }
        //删除压缩包
        [[NSFileManager defaultManager] removeItemAtPath:downloadDocPath error:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        weakSelf.bDownLoadPgComPkg = FALSE;
        NSLog(@"%@", error);
        
    }];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDocPath append:NO];
    [manager.operationQueue addOperation:operation];
    
}


-(void) downloadApp
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* localLastPgVer = [userDefaults stringForKey:@"pgComPgkVer"];
    float localF = [localLastPgVer floatValue];
    float pgComF = [self.pgComPkgVer floatValue];
    
    if(![self.pgComPkgVer isEqualToString:localLastPgVer])
    if(pgComF - localF >= 0.01)
    {
        self.bDownLoadPgComPkg = TRUE;
        //需要更新pgcom包
        [self send_GetPgComPkgUrl_Msg:self.pgComPkgVer];
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    BOOL b = self.bDownLoadPgComPkg;
    // www/apps
    [self createDirInDoc:@"Apps"];
    NSString* filePath = [self pathInDocumentDirectory:@"Apps"];

    NSString* fileName = [self getFileName:filePath];
    NSString* downloadDocPath = [filePath stringByAppendingPathComponent:fileName];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:self.strAppUrl parameters:nil error:nil];
    
    //@"http://180.173.162.211:25084/Resource/app/approval.zip"
    
    __weak __typeof(self)weakSelf = self;
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解压缩
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        ZipArchive* zip = [[ZipArchive alloc] init];
        if( [zip UnzipOpenFile:downloadDocPath] )
        {
            BOOL ret = [zip UnzipFileTo:filePath overWrite:YES];
            if( NO==ret )
            {
                 NSLog(@"解压文件%@发生错误", downloadDocPath);
            }
            else
            {
                 strongSelf.appDownLoadOK = TRUE;
                if(b)
                {
                    //要等PGCOM下载好
                    NSLog(@"要等PGCOM下载好");
                }
                else
                {
                     NSLog(@"不要等PGCOM下载好");
                    //下载成功
                    strongSelf.appSatate = 3;
                    [strongSelf backDelegate];
                }

            }
            [zip UnzipCloseFile];
        }
        //删除压缩包
        [[NSFileManager defaultManager] removeItemAtPath:downloadDocPath error:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);

    }];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDocPath append:NO];
    [manager.operationQueue addOperation:operation];

}
-(void) clickBtn:(id)sender
{
    switch (self.appSatate)
    {
        case 1: //下载
            [self downloadApp];
            self.appSatate = 2;
            [self backDelegate];
            break;
        case 2: //下载中            
            break;
        case 3: //卸载
            [self uninstallApp];
            break;
        case 4: //更新
            //先删除老的版本
            [self deleteApp];
            [self downloadApp];
            self.appSatate = 5;
            [self backDelegate];
        case 5: //更新中
            
            break;
        default:
            break;
    }
}

-(void) deleteApp
{
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [self createDirInDoc:@"Apps"];
    NSString* filePath = [self pathInDocumentDirectory:@"Apps"];
    NSString* str2 = [self getFileName:filePath];
    NSArray* speArry = [str2 componentsSeparatedByString:@"."];
    NSString* fileName = [speArry objectAtIndex:0];
    
    NSString* uninstallAppPath = [filePath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:uninstallAppPath error:nil];
}
-(void) uninstallApp
{
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    //[cache setDiskCapacity:0];
    //[cache setMemoryCapacity:0];
    
    [self createDirInDoc:@"Apps"];
    NSString* filePath = [self pathInDocumentDirectory:@"Apps"];
    NSString* str2 = [self getFileName:filePath];
    NSArray* speArry = [str2 componentsSeparatedByString:@"."];
    NSString* fileName = [speArry objectAtIndex:0];
    
    NSString* uninstallAppPath = [filePath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:uninstallAppPath error:nil];
    
    self.appSatate = 1;
    [self backDelegate];
    
}
-(void) backDelegate
{
    if (self.myDelegate) {
        if ([self.myDelegate respondsToSelector:@selector(clickSatateBtn:)]) {
            [self.myDelegate clickSatateBtn:self];
        }
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        appImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 58.0, 58.0)];
        [self.contentView addSubview:appImgView];
        
        appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0+13.0, 20.0+3, 100.0, 18.0)];
        [self.contentView addSubview:appNameLabel];
        appNameLabel.font = [UIFont systemFontOfSize:16.0];
        appNameLabel.textColor = [UIColor grayColor];
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            appSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(768.0-60.0-80.0+5, 20.0+3, 100.0, 18.0)];
            appSizeLabel.font = [UIFont systemFontOfSize:13.0];
            appSizeLabel.textColor = [UIColor grayColor];
            [self.contentView addSubview:appSizeLabel];
            
            appSatateBtn = [[UIButton alloc] initWithFrame:CGRectMake(768.0-80.0, 0.0+2, 102.0, 62.0)];
            [appSatateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:appSatateBtn];
        }else{
            appSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.0-60.0-80.0+5, 20.0+3, 100.0, 18.0)];
            appSizeLabel.font = [UIFont systemFontOfSize:13.0];
            appSizeLabel.textColor = [UIColor grayColor];
            [self.contentView addSubview:appSizeLabel];
            
            appSatateBtn = [[UIButton alloc] initWithFrame:CGRectMake(320.0-80.0, 0.0+2, 102.0, 62.0)];
            [appSatateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:appSatateBtn];
        }
     
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.appSatate)
    {
        case 1: //下载
             [appSatateBtn setImage:[UIImage imageNamed:@"market_download.png"] forState:UIControlStateNormal];
            break;
        case 2: //下载中
             [appSatateBtn setImage:[UIImage imageNamed:@"market_downloading.png"] forState:UIControlStateNormal];
            break;
        case 3: //卸载
            [appSatateBtn setImage:[UIImage imageNamed:@"market_uninstall.png"] forState:UIControlStateNormal];
            break;
        case 4: //更新
            [appSatateBtn setImage:[UIImage imageNamed:@"market_update.png"] forState:UIControlStateNormal];
            break;
        case 5: //更新中
            [appSatateBtn setImage:[UIImage imageNamed:@"market_updating.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setStrAppIconUrl:(NSString *)strAppIconUrl
{
    [self.appImgView setImageWithURL:[NSURL URLWithString:strAppIconUrl]];
}

- (void) clearData
{
    self.bDownLoadPgComPkg = FALSE;
}

#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001)
    {
        if (self.myDelegate) {
            if ([self.myDelegate respondsToSelector:@selector(backLoginNotification:)]) {
                [self.myDelegate backLoginNotification:self];
            }
        }
        
    }
}

@end
