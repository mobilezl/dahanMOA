//
//  StyleSettingViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-23.
//
//

#import "StyleSettingViewController.h"
#import "SettingViewController.h"
#import "AppDefine.h"
#import "CommonTool.h"

@interface StyleSettingViewController ()

@end

@implementation StyleSettingViewController
@synthesize myDelegate;
@synthesize defaultStyleImg;
@synthesize zakerStyleImg;
@synthesize selectDStyleImg;
@synthesize selectZStyleImg;
@synthesize bMove;
@synthesize appStyle;
@synthesize defaultStyleBtn;
@synthesize zakerStyleBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.appStyle forKey:@"AppStyle"];
    [userDefaults synchronize];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.defaultStyleBtn.layer.borderWidth = 2;
    self.defaultStyleBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.defaultStyleBtn.layer.cornerRadius = 4.0;
    
    
    self.zakerStyleBtn.layer.borderWidth = 2;
    self.zakerStyleBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.zakerStyleBtn.layer.cornerRadius = 4.0;
    
    self.defaultStyleImg.layer.borderWidth = 2;
    self.defaultStyleImg.layer.borderColor = [UIColor blueColor].CGColor;
    
    self.zakerStyleImg.layer.borderWidth = 2;
    self.zakerStyleImg.layer.borderColor = [UIColor blueColor].CGColor;
    
    float addHeight = 0.0;
    if([[CommonTool commonToolManager] IS_IOS7])
    {
        addHeight = 64.0;
    }
    CGRect r = self.view.frame;
    self.view.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.defaultStyleImg.frame;
    self.defaultStyleImg.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.zakerStyleImg.frame;
    self.zakerStyleImg.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.selectDStyleImg.frame;
    self.selectDStyleImg.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.selectZStyleImg.frame;
    self.selectZStyleImg.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.defaultStyleBtn.frame;
    self.defaultStyleBtn.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    r = self.zakerStyleBtn.frame;
    self.zakerStyleBtn.frame = CGRectMake(r.origin.x, r.origin.y+addHeight, r.size.width, r.size.height);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.appStyle = [userDefaults integerForKey:@"AppStyle"];
    if(self.appStyle == 0)
    {
        self.selectDStyleImg.hidden = FALSE;
        self.selectZStyleImg.hidden = TRUE;
    }
    else
    {
        self.selectDStyleImg.hidden = TRUE;
        self.selectZStyleImg.hidden = FALSE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.bMove = NO;
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.bMove = YES;
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"#########################touchesEnded");

    if (!self.bMove) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        if (CGRectContainsPoint(self.defaultStyleImg.frame,point)) {
            self.appStyle = 0;
            self.selectDStyleImg.hidden = FALSE;
            self.selectZStyleImg.hidden = TRUE;
            gStyleType = 0;
        }
        else if (CGRectContainsPoint(self.zakerStyleImg.frame,point)) {
            self.appStyle = 1;
            self.selectDStyleImg.hidden = TRUE;
            self.selectZStyleImg.hidden = FALSE;
            gStyleType = 1;
        }
    }
    [self.nextResponder touchesEnded:touches withEvent:event];
}


-(IBAction)clickBtn1:(id)sender
{
    
    gStyleType = 1;
    
    if(self.myDelegate)
    {
        if([self.myDelegate respondsToSelector:@selector(backFromStyleSettingVC:)])
        {
            [self.myDelegate backFromStyleSettingVC:self];
        }
    }

}
-(IBAction)clickBtn2:(id)sender
{
    gStyleType = 2;
    
    if(self.myDelegate)
    {
        if([self.myDelegate respondsToSelector:@selector(backFromStyleSettingVC:)])
        {
            [self.myDelegate backFromStyleSettingVC:self];
        }
    }

}
@end
