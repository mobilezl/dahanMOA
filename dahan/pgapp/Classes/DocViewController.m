//
//  DocViewController.m
//  pgapp
//
//  Created by Leo on 15-1-14.
//
//

#import "DocViewController.h"
#import "SalaryTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "MainViewController.h"
#import "DocFile.h"
#import "Approval.h"
#import "OpenTxtViewController.h"
@interface DocViewController ()

@end

@implementation DocViewController
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
    tableView.scrollEnabled = NO;
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    //    [view release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    float addHeight = 0.0;
    if(!IS_IPHONE_5)
    {
        addHeight = 88.0;
        
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
    
    [self send_GetAttachmentList_Msg];
    
}

NSString * P_SN=nil;
-(void) passValue:(id)value {
    
    P_SN = value;

}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void) send_GetAttachmentList_Msg
{
    //  NSString *eNumber = @"0000001";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetAttachmentList&loginName=%@&accesc_Token=%@&openId=%@&procInstID=%@",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID,P_SN];
    NSLog(@"send_GetAttachmentList_Msg:%@",url);
    //    NSDictionary *dict = @{@"":@""};
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
            NSArray* arry = [responseObject objectForKey:@"List"];
            if([arry count] ==0){
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"无附件信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil,nil];
                [av show];
                [self performSelector:@selector(dimissAlert:) withObject:av afterDelay:2.0];
                
                return;
            }
            
            
            [self.appsList removeAllObjects];
            
            for(int i = 0; i < arry.count; ++i)
            {

                DocFile *doc = [[DocFile alloc] init];
                doc.AttachmentId =[[arry objectAtIndex:i] objectForKey:@"AttachmentId"];
                doc.FileName =[[arry objectAtIndex:i] objectForKey:@"FileName"];
                doc.FileExtensionName = [[arry objectAtIndex:i] objectForKey:@"FileExtensionName"];
                doc.UploadUserName = [[arry objectAtIndex:i] objectForKey:@"UploadUserName"];
                [self.appsList addObject:doc];
                
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
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -1009 || error.code == -1004)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无法连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
        }
        NSLog(@"%@", error);
        
        
        
    }];
    
    
    
    
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
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [appsList count];
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 70.0f;
    return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SalaryTableViewCell *cell;
    //定义CustomCell的复用标识,这个就是刚才在CustomCell.xib中设置的那个Identifier,一定要相同,否则无法复用
    static NSString *identifier = @"SalaryCellIdentifier";
    //根据复用标识查找TableView里是否有可复用的cell,有则返回给cell
    cell = (SalaryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //判断是否获取到复用cell,没有则从xib中初始化一个cell
    if (!cell) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SalaryTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
        
    }
    
    DocFile* doc = (DocFile*)[self.appsList objectAtIndex:indexPath.row];
    cell.Salary_detail.textColor=[[UIColor grayColor] init];
 
   
        [cell.SalaryImg setImage:[UIImage imageNamed:@"icon_doc.png"]];
        cell.SalaryName.text=[NSString stringWithFormat:@"%@",doc.FileName];
        cell.Salary_detail.text =[NSString stringWithFormat:@"上传人:%@   类型:%@",doc.UploadUserName,doc.FileExtensionName];
        
        cell.type = doc.FileExtensionName;
        cell.sq = doc.AttachmentId;
    
    cell.SalaryBtn.tag=indexPath.row;
    [cell.SalaryBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.5];
}

-(BOOL) clickBtn:(UIButton *)btn{
    
    SalaryTableViewCell *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];

    NSString *url = [NSString stringWithFormat:@"%@/WorkflowService.ashx?Action=GetAttachment&loginName=%@&accesc_Token=%@&openId=%@&attachmentId=%@",SERVERADDRESS,gUserName,gAuthorizeCode,gOpenID,cell.sq];
    NSLog(@"clickBtn-----%@",url);
    

    NSString *docType = cell.type;
    if ([docType isEqualToString:@"zip"] || [docType isEqualToString:@"rar"] || [docType isEqualToString:@"msg"] ) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"当前文件类型不支持在移动端浏览" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
    }else if([docType isEqualToString:@"txt"]){

        OpenTxtViewController* openVC = [[OpenTxtViewController alloc] initWithNibName:@"OpenTxtViewController" bundle:NULL];
        openVC.title=cell.SalaryName.text;
        self._delegate = openVC;
        [self._delegate passValue:url];
        [self.navigationController pushViewController:openVC animated:YES];
        
    }else{
    
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
    mainVC.title=cell.SalaryName.text;
    mainVC.startPage = url;
   [self.navigationController pushViewController:mainVC animated:YES];
 
    }
}



@end
