//
//  SalaryTableViewCell.h
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import <UIKit/UIKit.h>



@interface SalaryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *SalaryImg;
@property (strong, nonatomic) IBOutlet UILabel *SalaryName;
@property (strong, nonatomic) IBOutlet UILabel *Salary_detail;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, retain) NSString* sq;

@property (strong, nonatomic) IBOutlet UIButton *SalaryBtn;


@end
