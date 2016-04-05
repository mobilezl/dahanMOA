//
//  SettingViewController.h
//  pgapp
//  设置界面
//  Created by 陈 利群 on 14-3-18.
//
//

#import <UIKit/UIKit.h>
#import "StyleSettingViewController.h"
@interface SettingViewController : UIViewController<StyleSettingVCDelegate, UIAlertViewDelegate>{
UIButton *button ;
}

@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property (nonatomic, retain) NSMutableArray* settingMArray;
@property (nonatomic, retain) IBOutlet UIButton* logoutBtn;

-(IBAction)logoutBtn:(id)sender;
@end
