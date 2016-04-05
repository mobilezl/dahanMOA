//
//  ProcessInfoViewController.h
//  pgapp
//
//  Created by Leo on 14-9-25.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "UIPopoverListView.h"

@interface ProcessInfoViewController : UIViewController<PassValueVCDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>{
    UIButton *button1;
    UIButton *button2;
    UIButton *addBtn;
    UIButton *forwardBtn;
    UIButton *returnBtn;
    UIButton *moreBtn;
    UIButton *huiBtn;
    UITextView *textView;
    UILabel *tlab;

}

@property (strong, nonatomic) IBOutlet UIImageView *imageLine;
@property (nonatomic, retain) UILabel* placeholderLabel;
@property (assign,nonatomic) id<PassValueVCDelegate> _delegate;  
@property (retain,nonatomic) NSString * ProcInstID;
@property (retain,nonatomic) NSString * ProcessDetailID;

@property (strong, nonatomic) IBOutlet UILabel *Submitter;

@property (strong, nonatomic) IBOutlet UILabel *SubmintDate;


@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSMutableArray* appsList;
@property (strong, nonatomic) IBOutlet UITextField *context;

@property(nonatomic, retain) NSMutableArray* popupList;

@property(nonatomic, retain) NSArray *menuItems;
- (void) pushMenuItem:(NSString *)sender;
@property(nonatomic, retain) NSMutableArray* DetallesArryList;
@end
