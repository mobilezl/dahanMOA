//
//  ApprovalDetailTableViewCell.h
//  pgapp
//
//  Created by Leo on 15-1-16.
//
//

#import <UIKit/UIKit.h>

@interface ApprovalDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellValue;
@property (strong, nonatomic) IBOutlet UIButton *cellBtn;
@property(nonatomic, retain) NSString* cellID;
@end
