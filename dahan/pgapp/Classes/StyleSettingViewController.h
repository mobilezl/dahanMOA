//
//  StyleSettingViewController.h
//  pgapp
//  样式设置界面
//  Created by 陈 利群 on 14-3-23.
//
//

#import <UIKit/UIKit.h>

@class StyleSettingViewController;
@protocol StyleSettingVCDelegate <NSObject>
-(void) backFromStyleSettingVC:(id) sender;
@end

@interface StyleSettingViewController : UIViewController

@property(nonatomic, assign) id<StyleSettingVCDelegate> myDelegate;
@property(nonatomic, retain) IBOutlet UIImageView* defaultStyleImg;
@property(nonatomic, retain) IBOutlet UIImageView* zakerStyleImg;
@property(nonatomic, retain) IBOutlet UIImageView* selectDStyleImg;
@property(nonatomic, retain) IBOutlet UIImageView* selectZStyleImg;
@property(nonatomic, retain) IBOutlet UIButton* defaultStyleBtn;
@property(nonatomic, retain) IBOutlet UIButton* zakerStyleBtn;

@property(nonatomic, assign) BOOL bMove;
@property(nonatomic, assign) NSInteger appStyle;
-(IBAction)clickBtn1:(id)sender;
-(IBAction)clickBtn2:(id)sender;
@end
