//
//  ProcessRedirectViewController.h
//  pgapp
//
//  Created by Leo on 14-10-11.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface ProcessRedirectViewController :  UIViewController<PassValueVCDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIButton *button1;
    UIButton *button2;
    UITextView *textView;
    NSInteger _index;
   
}


@property (nonatomic, retain) UILabel* placeholderLabel;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic, retain) NSMutableArray* appsList;
@property (strong, nonatomic) IBOutlet UIButton *SeaBtn;

- (IBAction)SearchBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *SearchText;
@end
