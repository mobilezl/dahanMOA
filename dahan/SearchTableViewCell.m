//
//  SearchTableViewCell.m
//  pgapp
//
//  Created by Leo on 14-10-10.
//
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell
@synthesize UserName;
@synthesize Title;
@synthesize UserID;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
