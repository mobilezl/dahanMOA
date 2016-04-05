//
//  ShareAppViewController.h
//  pgapp
//  二维码分享界面
//  Created by 陈 利群 on 14-7-19.
//
//

#import <UIKit/UIKit.h>

@interface ShareAppViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UIImageView* shareImgView;


@property (strong, nonatomic) IBOutlet UILabel *TitleLable;
@end
