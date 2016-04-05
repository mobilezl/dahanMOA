//
//  AboutDHViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-13.
//
//

#import "AboutDHViewController.h"
#import "CommonTool.h"
#import "AppDefine.h"
@interface AboutDHViewController ()

@end

@implementation AboutDHViewController
@synthesize titleLabel;
@synthesize contexLabel;

@synthesize VersionLable;
@synthesize IconView;

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
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        IconView.frame = CGRectMake(310, 80, 150, 150);
        VersionLable.frame = CGRectMake(310, 220, 150, 50);
        contexLabel.frame = CGRectMake(0, 560, 768, 50);

        
        contexLabel.font = [UIFont systemFontOfSize:22.0];

    }
    
    float addHeight = 0.0;
    if(!IS_IPHONE_5)
    {
        addHeight = -88.0;
    }
    CGRect r = self.titleLabel.frame;
    //self.titleLabel.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.contexLabel.frame;
    self.contexLabel.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);

    
    
    
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
    
    VersionLable.text = [NSString stringWithFormat:@"版本V%@",glocalVersion];

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

@end
