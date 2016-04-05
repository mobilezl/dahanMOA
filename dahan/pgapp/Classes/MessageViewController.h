//
//  MessageViewController.h
//  pgapp
//  消息界面
//  Created by 陈 利群 on 14-3-18.
//
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) NSMutableArray* msgsList;
@property(nonatomic, retain) IBOutlet UILabel* tipLabel;
@end
