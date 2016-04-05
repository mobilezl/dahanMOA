//
//  CDVLogoutPlugins.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-15.
//
//

#import "CDVLogoutPlugins.h"
#import "AppDefine.h"
#import "AppDelegate.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "CommonTool.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"

@implementation CDVLogoutPlugins

-(void) logoutApp:(CDVInvokedUrlCommand *)command
{
    [self send_UserLogout_Msg];
}


-(void) send_UserLogout_Msg
{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UserLogin xmlns=\"http://tempuri.org/\">"
                             "<userId>%@</userId>"
                             "<authorizeCode>%@</authorizeCode>"
                             "</UserLogin>"
                             "</soap:Body>"
                             "</soap:Envelope>", gUserAccout, gAuthorizeCode];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERADDRESS]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/UserLogout" forHTTPHeaderField:@"SOAPAction"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/UserService.asmx?op=UserLogout", SERVERADDRESS];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [XMLHelper dictionaryForXMLData:responseObject error:nil];//调用解析方法
        
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            //返回登录界面
            ipadLoginViewController* loginVC = [[ipadLoginViewController alloc] initWithNibName:@"ipadLoginViewController" bundle:nil];
            loginVC.bFromSettingVC = TRUE;
            [self.viewController presentViewController:loginVC animated:YES completion:nil];
        }else{
        //回到登录界面
        LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.bFromSettingVC = TRUE;
        [self.viewController presentViewController:loginVC animated:YES completion:nil];
        }
        
        // NSLog(@"--------------%@", strJson);
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

@end
