//
//  MainTabBarViewController.h
//  pgapp
//  首页主框架界面
//  Created by 陈 利群 on 14-3-18.
//
//

#import <UIKit/UIKit.h>
#import "SegmentedButton.h"

@interface MainTabBarViewController : UITabBarController<UITabBarDelegate, SegmentedButtonDelegate>

@property(nonatomic, retain) IBOutlet UITabBar* myTabBar;

@property (nonatomic, retain) UITabBarItem* settingBarItem;
@property(nonatomic, retain) IBOutlet SegmentedButton* segmentedBtn;

- (void) clickBottomBtn:(int) index;
- (void) hideSegmentButton:(BOOL) hide;
- (void) setSegmentBtnBkImg:(UIImage*) bk;
@end
