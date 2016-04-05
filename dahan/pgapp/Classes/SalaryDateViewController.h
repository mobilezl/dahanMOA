//
//  SalaryDateViewController.h
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface SalaryDateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
- (IBAction)selectSend:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign,nonatomic) id<PassValueVCDelegate> _delegate; 
@property (strong, nonatomic) IBOutlet UIImageView *imageHide;
@end
