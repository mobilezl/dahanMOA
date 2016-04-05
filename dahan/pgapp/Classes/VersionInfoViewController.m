//
//  VersionInfoViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-13.
//
//

#import "VersionInfoViewController.h"
#import "CommonTool.h"
#import "AppDefine.h"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController
@synthesize contexLabel;

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
    float addHeight = 0.0;
    if([[CommonTool commonToolManager] IS_IOS7])
    {
        addHeight = 64.0;
    }
    CGRect r = self.contexLabel.frame;
    self.contexLabel.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
