//
//  OpenTxtViewController.m
//  pgapp
//
//  Created by Leo on 15-1-16.
//
//

#import "OpenTxtViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDefine.h"
#import "CommonTool.h"
#import "AFNetworking.h"
#import "XMLHelper.h"
#import "SBJson.h"
@interface OpenTxtViewController ()

@end

@implementation OpenTxtViewController
NSString * url=nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    
    
    
}
-(void) clickBarBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) passValue:(id)value {
     [self openTxt:value];
}
-(void) openTxt: (NSString *)url
{
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    
    NSURL *docUrl = [NSURL URLWithString:url];
    
    //        if([encodedString hasSuffix:@".txt"]){
    
    NSData* Data = [NSData dataWithContentsOfURL:docUrl];
    NSString* aStr = [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    if (!aStr) {
        aStr=[[NSString alloc] initWithData:Data encoding:0x80000632];
    }
    if (!aStr) {
        aStr=[[NSString alloc] initWithData:Data encoding:0x80000631];
    }
    
    //        NSString* aStr = [[NSString alloc] initWithData:Data encoding:0x80000632];
    NSString* resp = [NSString stringWithFormat:
                      @"<HTML>"
                      "<head>"
                      "<title>Text View</title>"
                      "</head>"
                      "<BODY>"
                      "<pre>"
                      "%@"
                      "</pre>"
                      "</BODY>"
                      "</HTML>",
                      aStr];
    [ webview loadHTMLString:resp baseURL:docUrl];
    
    [self.view addSubview:webview];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
