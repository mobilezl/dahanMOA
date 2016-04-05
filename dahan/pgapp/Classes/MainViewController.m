/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  pgapp
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "MainTabBarViewController.h"
#import "CommonTool.h"
@implementation MainViewController
@synthesize appKey;
@synthesize rightBtn_urlStr;
@synthesize bFixedApp;

@synthesize bRightTongxunluBtn;
@synthesize myView;
@synthesize myCustomAVView;
@synthesize refreshHeaderView;
@synthesize reloading;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
        appKey = @"111111";
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    UIImage* navImg = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    
    [super viewWillAppear:animated];
}

-(void) clickBarBackBtn:(id)sender
{
    if(self.webView.canGoBack)
    {
       // NSString* S = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self.webView goBack];
    }
    else
    {
        if(self.bFixedApp)
        {
            MainTabBarViewController* vcs = (MainTabBarViewController*)[self.navigationController parentViewController];

            [vcs clickBottomBtn:0];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.view.backgroundColor = [UIColor greenColor];
    
    CustomActivityIndicatorView* v = [[CustomActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0, 140.0, 40.0, 40.0)];
    //v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    self.myCustomAVView = v;
    [self.view bringSubviewToFront:v];
    
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    /*
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff]  CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    UIImage* image = [[CommonTool commonToolManager] getAppNavBgPic];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    



    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [leftBarBtn setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(clickBarBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 24.0,41.0);
    UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = barBackBtn;

    if(bRightTongxunluBtn)
    {
        UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [rightBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBarBtn setImage:[UIImage imageNamed:@"man.png"] forState:UIControlStateNormal];
        //[rightBarBtn setTitle:strTitle forState:UIControlStateNormal];
       // [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"nav_smallbtn.png"] forState:UIControlStateNormal];
        [rightBarBtn addTarget:self action:@selector(clickBarRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBarBtn.frame = CGRectMake(0.0, 0.0, 30.0,30.0);
        UIBarButtonItem* barBackBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
        self.navigationItem.rightBarButtonItem = barBackBtn;

    }
    
   // UIActivityIndicatorView* av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150.0, 160.0, 40.0, 40.0)];
  //  av.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
   // [self.webView addSubview:av];
   // av.layer.borderColor = [UIColor redColor].CGColor;
   // av.layer.borderWidth = 2;
   // [self.webView bringSubviewToFront:av];
    
    
    //初始化refreshView，添加到webview 的 scrollView子视图中
    if (self.refreshHeaderView == nil) {
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.webView.scrollView.bounds.size.height, self.webView.scrollView.frame.size.width, self.webView.scrollView.bounds.size.height)];
        self.refreshHeaderView.delegate = self;
        [self.webView.scrollView addSubview:self.refreshHeaderView];
    }
    self.webView.scrollView.delegate = self;
    [self.refreshHeaderView refreshLastUpdatedDate];
    

    
}


-(void) clickBarRightBtn:(id)sender
{

    MainViewController* mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainVC.title = @"常用联系人";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //mainVC.wwwFolderName = [@"file://" stringByAppendingString:documentsDirectory];
    mainVC.startPage = @"apps/contact/www/Collection.html";//((MainViewController*)self.viewController).rightBtn_urlStr;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

#pragma mark UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    // Black base color for background matches the native apps
    //theWebView.backgroundColor = [UIColor blackColor];
    
    //[self.myActiviyIV stopAnimating];
    //self.myActiviyIV.hidden = TRUE;
    
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
    
    for (id subview in self.view.subviews) {
        if ([[subview class] isSubclassOfClass:[CustomActivityIndicatorView class]])
        {
            [((CustomActivityIndicatorView*)subview) removeActiviyView];
        }
    }

    
//    NSString* s = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = s;
    return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */



- (void) webViewDidStartLoad:(UIWebView*)theWebView
{

   // NSString* s = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.reloading = YES;
    return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
    return [super webView:theWebView didFailLoadWithError:error];
}


- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[ self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self.webView reload];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}



@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

/*
   NOTE: this will only inspect execute calls coming explicitly from native plugins,
   not the commandQueue (from JavaScript). To see execute calls from JavaScript, see
   MainCommandQueue below
*/
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

- (NSString*)pathForResource:(NSString*)resourcepath;
{
   return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}




@end
