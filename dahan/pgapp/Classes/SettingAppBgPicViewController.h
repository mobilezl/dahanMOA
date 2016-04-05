//
//  SettingAppBgPicViewController.h
//  pgapp
//  设置APP背景界面
//  Created by 陈 利群 on 14-3-28.
//
//

#import <UIKit/UIKit.h>

@interface SettingAppBgPicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView* myTableView;
@property (strong, nonatomic) IBOutlet UILabel *TitleLable;

@property (nonatomic, retain) NSMutableArray* myPicList;
@property (nonatomic, assign) NSInteger clickCount;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
