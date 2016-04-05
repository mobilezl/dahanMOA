//
//  LogoViewController.m
//

//
//  Created by 陈 利群 on 14-7-29.
//
//

#import "LogoViewController.h"
#import "LoginViewController.h"
#import "ipadLoginViewController.h"
#import "AppDelegate.h"
#import "AppDefine.h"
@interface LogoViewController ()

@end

@implementation LogoViewController

@synthesize myScrollView;
@synthesize myPageControl;
@synthesize pageControlUsed;
@synthesize viewControllers;
@synthesize curPage;

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
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < 3; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;

    
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width * 3, self.myScrollView.frame.size.height);
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.scrollsToTop = NO;
    self.myScrollView.delegate = self;
    
    self.myPageControl.numberOfPages = 3;
    self.myPageControl.currentPage = 0;
    self.myPageControl.hidden = NO;
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    
    self.curPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
    pageControlUsed = NO;
    if(self.myPageControl.currentPage == 2)
    {
        self.curPage = 3;
    }
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NoFirstLoginApp" forKey:@"firstLoginApp"];
        [userDefaults synchronize];
        
        ipadLoginViewController* loginVC = [[ipadLoginViewController alloc] initWithNibName:@"ipadLoginViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.viewController = (UIViewController*)loginVC;
        appDelegate.window.rootViewController = loginVC;
        [appDelegate.window addSubview:loginVC.view];
        [appDelegate.window makeKeyAndVisible];
        return;

    
    }
	
    if(curPage >= 3 )
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NoFirstLoginApp" forKey:@"firstLoginApp"];
        [userDefaults synchronize];
        
        LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.viewController = (UIViewController*)loginVC;
        appDelegate.window.rootViewController = loginVC;
        [appDelegate.window addSubview:loginVC.view];
        [appDelegate.window makeKeyAndVisible];
        return;
        
    }

    
    CGFloat pageWidth = self.myScrollView.frame.size.width;
    int page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    if(page == 2)
    {
   //     curPage = 3;
    }
    
       // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
   // [self loadScrollViewWithPage:page - 1];
   // [self loadScrollViewWithPage:page];
   // [self loadScrollViewWithPage:page + 1];
    
    
}
-(IBAction)changePage:(id)sender
{
    CGRect frame;
    frame.origin.x = self.myScrollView.frame.size.width * self.myPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.myScrollView.frame.size;
    [self.myScrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page > 3)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NoFirstLoginApp" forKey:@"firstLoginApp"];
        [userDefaults synchronize];
        
        LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.viewController = (UIViewController*)loginVC;
        appDelegate.window.rootViewController = loginVC;
        [appDelegate.window addSubview:loginVC.view];
        [appDelegate.window makeKeyAndVisible];
        return;
    }
    
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[UIViewController alloc] init];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.myScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        NSString* imgName = [NSString stringWithFormat:@"MOASanPing%d", page];
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        if(IS_IPHONE_5)
        {
            imgView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0+88.0);
        }
        else
        {
            imgView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
        }
       // controller.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        [controller.view addSubview: imgView];
        
        [self.myScrollView addSubview:controller.view];
    }
}


@end
