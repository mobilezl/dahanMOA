//
//  TestWebViewViewController.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-29.
//
//

#import "TestWebViewViewController.h"

@interface TestWebViewViewController ()

@end

@implementation TestWebViewViewController
@synthesize myWebView;

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"index.html"];
    //NSURL *url = [NSURL fileURLWithPath:path];
    NSString* resourePath = [[NSBundle mainBundle] resourcePath];
    resourePath = [resourePath stringByAppendingPathComponent:@"fmdb/rights_notice.html"];
    NSURL* url = [NSURL fileURLWithPath:resourePath];
  // NSURL* url = [NSURL URLWithString:@"http://180.173.61.125:25084/file/Backbonejs.pdf"];

  //  NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.myWebView.scalesPageToFit = YES;
    
  //  [self.myWebView loadRequest:request];

    
    [self loadRequestWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestWithURL:(NSURL *)url
{
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:30.0];
    [self.myWebView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    
}

@end
