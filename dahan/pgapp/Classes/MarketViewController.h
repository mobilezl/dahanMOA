//
//  MarketViewController.h
//  pgapp
//  首页显示界面
//  Created by 陈 利群 on 14-3-18.
//
//

#import <UIKit/UIKit.h>
#import "AppMarkView.h"
#import "MainViewController.h"
#import "UserInfoView.h"
#import "WaitingOpView.h"

@interface MarketViewController : UIViewController<UIScrollViewDelegate, AppMarkViewDelegate, WaitingOpViewDelegate>

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) UIPageControl* myPageControl;
@property(nonatomic, retain) IBOutlet UILabel* welcomeLabel;
@property(nonatomic, retain) IBOutlet UIImageView* welcomeImgView;
@property(nonatomic, retain) UIView* bgView;
@property(nonatomic, retain) IBOutlet UIButton* msgBtn;
@property(nonatomic, retain) IBOutlet UIButton* appBtn;
@property(nonatomic, retain) IBOutlet UIButton* settingBtn;
@property(nonatomic, retain) UIImage* bgImg;
@property(nonatomic, retain) NSArray* appsList;
@property(nonatomic, retain) NSString* selectedAppID;
@property(nonatomic, retain) UserInfoView* userInfoView;

@property(nonatomic, retain) UIWebView*  phoneCallWebView;
//@property(nonatomic, assign) id<HideBottomBarDelegate> myDelegate;

//@property(nonatomic, retain) MainViewController* mainVC;

-(IBAction)gotoWebBtn:(id)sender;
-(IBAction)clickMsgBtn:(id)sender;
-(IBAction)clickAppBtn:(id)sender;
-(IBAction)clickSettingBtn:(id)sender;

@end
