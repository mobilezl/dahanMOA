//
//  LoginViewController.h
//  pgapp
//登录界面
//  Created by 陈 利群 on 14-3-17.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UITextField* tfUserName;
@property(nonatomic, retain) IBOutlet UITextField* tfPassword;

@property(nonatomic, assign) BOOL bFromSettingVC;
@property(nonatomic, retain) IBOutlet UIButton* loginBtn;
@property(nonatomic, retain) IBOutlet UISwitch* autoLoginSwitch;
@property(nonatomic, retain) IBOutlet UISwitch* rememberSwitch;

- (IBAction)loginBtn:(id)sender;

- (IBAction)switchAutoLogin:(id)sender;
- (IBAction)switchRemember:(id)sender;
@end
