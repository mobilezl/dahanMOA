//
//  FeedbackViewController.h
//  pgapp
//  意见反馈界面
//  Created by 陈 利群 on 14-7-19.
//
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UITextView* myTextView;
@property(nonatomic, retain) IBOutlet UITextField* contactTxField;
@property(nonatomic, retain) IBOutlet UIButton* sendBtn;
@property (nonatomic, retain) UILabel* placeholderLabel;
@property (strong, nonatomic) IBOutlet UILabel *TitleLable;

-(IBAction)sendFeedback:(id)sender;
@end
