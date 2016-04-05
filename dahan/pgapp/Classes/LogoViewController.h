//
//  LogoViewController.h
//  pgapp
//  应用加载界面
//  Created by 陈 利群 on 14-7-29.
//
//

#import <UIKit/UIKit.h>

@interface LogoViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) IBOutlet UIPageControl* myPageControl;

@property (nonatomic, retain) NSMutableArray *viewControllers;

@property(nonatomic, assign) BOOL pageControlUsed;
@property(nonatomic, assign) NSInteger curPage;

-(IBAction)changePage:(id)sender;

@end
