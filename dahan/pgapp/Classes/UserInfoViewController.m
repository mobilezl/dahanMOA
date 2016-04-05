//
//  UserInfoViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-7-19.
//
//

#import "UserInfoViewController.h"
#import "UserInfoViewCell.h"
#import "AppDefine.h"
#import "UIImageView+AFNetworking.h"
#import "CommonTool.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

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
    
    if(gUserInfo.userHeadImgUrl == nil || [gUserInfo.userHeadImgUrl isEqual:@""])
    {
        
    }
    else
    {
        self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 20.0, 80.0, 80.0)];
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.layer.cornerRadius = 40;
        [self.view addSubview:self.headImgView];
        [self.headImgView setImageWithURL:[NSURL URLWithString:gUserInfo.userHeadImgUrl]];
    }
    if(IS_IPHONE_5)
    {
        CGRect r = self.myTableView.frame;
        self.myTableView.frame = CGRectMake(0.0, r.origin.y, r.size.width, 280.0);
    }

    self.userNameCHLabel.text = gUserInfo.userName;
    self.userNameENLabel.text = gUserInfo.userID;
    self.userPositionNameLabel.text = gUserInfo.userPositionName;

    [self setExtraCellLineHidden:self.myTableView];
    
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

#pragma ViewControllerDelegate Method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CELL = @"SETCELL";
    UserInfoViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil)
    {
        cell = [[UserInfoViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        cell.titleNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.userInfoNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
    }
    switch (indexPath.row) {
        case 1:
            cell.titleNameLabel.text = @"邮箱";
            cell.userInfoNameLabel.text = gUserInfo.userEmail;
            break;
        case 2:
            cell.titleNameLabel.text = @"IM";
            cell.userInfoNameLabel.text = gUserInfo.userIM;
            break;
        case 3:
            cell.titleNameLabel.text = @"移动电话";
            cell.userInfoNameLabel.text = gUserInfo.userPhone;
            break;
        case 4:
            cell.titleNameLabel.text = @"办公电话";
            cell.userInfoNameLabel.text = gUserInfo.userTel;
            break;
        default:
            break;
    }
    
    
    return cell;
}



@end
