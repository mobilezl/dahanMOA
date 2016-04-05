//
//  UserInfoViewController.h
//  pgapp
//  用户信息界面
//  Created by 陈 利群 on 14-7-19.
//
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) UIImageView* headImgView;
@property(nonatomic, retain) IBOutlet UILabel* userNameCHLabel;
@property(nonatomic, retain) IBOutlet UILabel* userNameENLabel;
@property(nonatomic, retain) IBOutlet UILabel* userPositionNameLabel;

@property(nonatomic, retain) IBOutlet UITableView* myTableView;

@end
