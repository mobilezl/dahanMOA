//
//  AboutDHViewController.h
//  pgapp
//  关于公司界面
//  Created by 陈 利群 on 14-4-13.
//
//

#import <UIKit/UIKit.h>

@interface AboutDHViewController : UIViewController

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* contexLabel;

@property (strong, nonatomic) IBOutlet UIImageView *IconView;
@property (strong, nonatomic) IBOutlet UILabel *VersionLable;

@end
