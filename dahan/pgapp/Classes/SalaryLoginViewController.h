//
//  SalaryLoginViewController.h
//  pgapp
//
//  Created by Leo on 14-10-13.
//
//

#import <UIKit/UIKit.h>

@interface SalaryLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userID;
@property (strong, nonatomic) IBOutlet UITextField *TfPassWord;
- (IBAction)LoginSend:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end
