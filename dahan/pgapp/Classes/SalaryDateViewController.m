//
//  SalaryDateViewController.m
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import "SalaryDateViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "SalaryListViewController.h"
#import "DateForPicker.h"
@interface SalaryDateViewController ()

@end

@implementation SalaryDateViewController
@synthesize picker;
@synthesize _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float addHeight = 88.0;
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;
    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        
        self.picker.frame =CGRectMake(290, 100, 290, 200);
        
        UIImageView *image = [[UIImageView alloc] init];
         image.frame = CGRectMake(0, 0, 290, 400);
        [image setImage:[UIImage imageNamed:@"Default@2x~iphone.png" ]];
        [self.view addSubview:image];
        self.imageHide.frame = CGRectMake(screenWidth-290, 0, 290, 400);
        [self.imageHide setImage:[UIImage imageNamed:@"Default@2x~iphone.png" ]];
         self.selectBtn.frame = CGRectMake(250, 480, 280, 30);
       
    }else{
        
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
    self.selectBtn.backgroundColor = [[CommonTool commonToolManager] UIColorFromRGB:0x3795ff];
    
    self.selectBtn.layer.cornerRadius = 8.0;
    //    [self.LoginBtn setBackgroundImage:navBgImg forState:UIControlStateNormal];

    [self.view bringSubviewToFront:self.selectBtn];

    NSDate *currentTime  = [NSDate date];
    
    [picker setMaximumDate:currentTime];
    
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

- (IBAction)selectSend:(id)sender {
    
    
    
//    SalaryListViewController* feedbackVC = [[SalaryListViewController alloc] initWithNibName:@"SalaryListViewController" bundle:NULL];
//    feedbackVC.title = @"工资单";
//    
//    [self.navigationController pushViewController:feedbackVC animated:YES];
//    
    
    NSDate *select  = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateAndYears = [dateFormatter stringFromDate:select];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM"];
    NSString *dateAndMonth = [dateFormatter2 stringFromDate:select];
    
    SalaryListViewController* SalaryVC = [[SalaryListViewController alloc] initWithNibName:@"SalaryListViewController" bundle:NULL];
    SalaryVC.title = @"工资单";
    DateForPicker * date = [[DateForPicker alloc] init];
    date.Years=dateAndYears;
    date.Month =dateAndMonth;
    self._delegate = SalaryVC;
    [self._delegate passValue:date];
    [self.navigationController pushViewController:SalaryVC animated:YES];
    


    
//    NSDate *select  = [picker date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM"];
//    NSString *dateAndTime = [dateFormatter stringFromDate:select];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" 时间提示" message: dateAndTime delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}
@end
