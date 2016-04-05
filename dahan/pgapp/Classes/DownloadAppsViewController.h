//
//  DownloadAppsViewController.h
//  pgapp
//  应用下载界面
//  Created by 陈 利群 on 14-3-24.
//
//

#import <UIKit/UIKit.h>

#import "DownloadViewCell.h"

@interface DownloadAppsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DownloadVCDelegate, UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) NSMutableArray* appsList;

@end
