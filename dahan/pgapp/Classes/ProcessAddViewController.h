//
//  ProcessAddViewController.h
//  pgapp
//
//  Created by Leo on 14-9-29.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface ProcessAddViewController : UIViewController<PassValueVCDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIButton *button1;
    UIButton *button2;
 UITextView *textView;
}
@property (nonatomic, retain) UILabel* placeholderLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic, retain) NSMutableArray* appsList;
@property (strong, nonatomic) IBOutlet UIButton *SeaBtn;
@property (strong, nonatomic) IBOutlet UITextField *SearchText;
- (IBAction)SearchBtn:(id)sender;
@end
