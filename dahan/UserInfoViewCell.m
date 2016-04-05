//
//  UserInfoViewCell.m
//  pgapp
//
//  Created by 陈 利群 on 14-7-19.
//
//

#import "UserInfoViewCell.h"
#import "CommonTool.h"
@implementation UserInfoViewCell

@synthesize titleNameLabel;
@synthesize userInfoNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    


    
    if (self) {
        // Initialization code
        titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 3.0, 160.0, 20.0)];
        titleNameLabel.textColor = [[CommonTool commonToolManager] UIColorFromRGB:0x3795ff];
        titleNameLabel.font = [UIFont systemFontOfSize:12.0];
        
        [self.contentView addSubview:titleNameLabel];
        
        userInfoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 3.0+16.0, 160.0, 20.0)];
        userInfoNameLabel.textColor = [UIColor grayColor];
        userInfoNameLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:userInfoNameLabel];
        
    }
    return self;
}

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
