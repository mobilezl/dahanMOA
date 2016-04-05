//
//  SalaryTableViewCell.m
//  pgapp
//
//  Created by Leo on 14-10-14.
//
//

#import "SalaryTableViewCell.h"

@implementation SalaryTableViewCell

@synthesize SalaryImg;
@synthesize SalaryName;
@synthesize Salary_detail;
@synthesize SalaryBtn;
@synthesize type;
@synthesize sq;
- (void)awakeFromNib
{
    // Initialization code

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
    }
-(void) layoutSubviews
{
    [super layoutSubviews];
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.SalaryBtn.frame = CGRectMake(screenWidth-100, 18, 55, 30);
        self.SalaryImg.frame = CGRectMake(20, 5, 46, 55);
        self.Salary_detail.frame = CGRectMake(74, 32, 255, 21);
        
    }

}

@end
