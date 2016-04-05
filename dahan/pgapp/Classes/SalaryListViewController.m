//
//  SalaryListViewController.m
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import "SalaryListViewController.h"
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
#import "DateForPicker.h"
#import "Salary.h"
@interface SalaryListViewController ()

@end

@implementation SalaryListViewController
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
    
    [self send_GetSalaryList_Msg];

}

DateForPicker *date= nil;
-(void) passValue:(id)value {
    date = value;
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


- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
[self.navigationController popViewControllerAnimated:YES];
    }
}



- (void) send_GetSalaryList_Msg
{
//  NSString *eNumber = @"0000001";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/SalaaryService.ashx?Action=GetSalaryList&loginName=%@&accesc_Token=%@&openId=%@&eNumber=%@&yeary=%@&mouth=%@",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID,gUserName,date.Years,date.Month];
    NSLog(@"send_GetSalaryList_Msg:%@",url);
    //    NSDictionary *dict = @{@"":@""};
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"1"] )
        {
             NSArray* arry = [responseObject objectForKey:@"List"];
            if([arry count] ==0){
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无工资单信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil,nil];
                    [av show];
                  [self performSelector:@selector(dimissAlert:) withObject:av afterDelay:2.0];
                
                return;
            }
            
           
            [self.appsList removeAllObjects];
            
            for(int i = 0; i < arry.count; ++i)
            {
                Salary *salary = [[Salary alloc] init];
                salary.SEQUENCENUMBER =[[arry objectAtIndex:i] objectForKey:@"SEQUENCENUMBER"];
                salary.ZPERI =[[arry objectAtIndex:i] objectForKey:@"ZPERI"];
                salary.ZGZLX = [[arry objectAtIndex:i] objectForKey:@"ZGZLX"];

                [self.appsList addObject:salary];

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
    
     Salary* salary = (Salary*)[self.appsList objectAtIndex:indexPath.row];
      cell.Salary_detail.textColor=[[UIColor grayColor] init];
    



    
    
    if([salary.ZGZLX isEqualToString:@"Y"]){
        [cell.SalaryImg setImage:[UIImage imageNamed:@"Salary_include.png"]];
        cell.SalaryName.text=[NSString stringWithFormat:@"%@年度工资单",date.Years];
        cell.Salary_detail.text =[NSString stringWithFormat:@"1月份截至%@月份的工资单",date.Month];
        
        cell.type = salary.ZGZLX;
        cell.sq = salary.SEQUENCENUMBER;
        
    }else if([salary.ZGZLX isEqualToString:@"M"]){
        [cell.SalaryImg setImage:[UIImage imageNamed:@"Salary_list.png"]];
       cell.SalaryName.text=[NSString stringWithFormat:@"%@月份工资单",date.Month];
        cell.Salary_detail.text =[NSString stringWithFormat:@"%@月份您的工资单",date.Month];
        cell.type = salary.ZGZLX;
        cell.sq = salary.SEQUENCENUMBER;
    }

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
//    NSString *eNumber = @"0000001";
    NSString *url = [NSString stringWithFormat:@"%@/SalaaryService.ashx?Action=GetSalaryPdf&loginName=%@&accesc_Token=%@&openId=%@&eNumber=%@&type=%@&sq=%@",SERVERADDRESS,gUserAccout,gAuthorizeCode,gOpenID,gUserName,cell.type,cell.sq];
    NSLog(@"clickBtn-----%@",url);
    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:NULL];
    mainVC.title=cell.SalaryName.text;
    mainVC.startPage = url;
    [self.navigationController pushViewController:mainVC animated:YES];
 }


@end
