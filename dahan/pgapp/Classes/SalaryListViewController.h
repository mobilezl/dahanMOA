//
//  SalaryListViewController.h
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface SalaryListViewController : UIViewController<PassValueVCDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSMutableArray* appsList;
@property (assign,nonatomic) id<PassValueVCDelegate> _delegate;




@end
