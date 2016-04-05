//
//  ApprovalDetailTableViewCell.m
//  pgapp
//
//  Created by Leo on 15-1-16.
//
//

#import "ApprovalDetailTableViewCell.h"

@implementation ApprovalDetailTableViewCell
@synthesize cellBtn;
@synthesize cellID;
@synthesize cellValue;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.cellBtn.frame = CGRectMake(screenWidth-100, 18, 55, 30);

        
    }
    
}
@end
