//
//  ApprovalTableViewCell.h
//  pgapp
//
//  Created by Leo on 14-9-19.
//
//

#import <UIKit/UIKit.h>

@interface ApprovalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ProcessName;
@property (strong, nonatomic) IBOutlet UILabel *Submitter;
@property (strong, nonatomic) IBOutlet UILabel *Preview;

@property (strong, nonatomic) IBOutlet UILabel *SubmitDate;

@property(nonatomic, retain) NSString* processType;
@property(nonatomic, retain) NSString* ProcessSN;
@property(nonatomic, retain) NSString* ApproverLoginName;


@end


