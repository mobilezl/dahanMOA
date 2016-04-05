//
//  WorkFlowViewController.h
//  pgapp
//
//  Created by Leo on 14-9-18.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"


@interface WorkFlowViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UIButton *button1;
    UIButton *button2;
    UIButton* leftBarBtn;
    
    NSInteger TotalPages;
//    NSString *TotalPages;

}
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@property (assign,nonatomic) id<PassValueVCDelegate> _delegate;  
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) NSMutableArray* appsList;


@end
