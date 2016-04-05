//
//  MsgViewCell.m
//  pgapp
//  消息
//  Created by 陈 利群 on 14-4-18.
//
//

#import "MsgViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AppDefine.h"

@implementation MsgViewCell

@synthesize appImgView;
@synthesize appNameLabel;
@synthesize msgContentLabel;
@synthesize msgID;
@synthesize readMark;
@synthesize markLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        appImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
        [self.contentView addSubview:appImgView];
        
        appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 10.0, 100.0, 18.0)];
        [self.contentView addSubview:appNameLabel];
        appNameLabel.font = [UIFont systemFontOfSize:14.0];
        
        msgContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 36.0, 100.0, 18.0)];
        msgContentLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:msgContentLabel];
        
        readMark = [[UIImageView alloc] initWithFrame:CGRectMake(20.0+12.0, 5.0, 22.0, 22.0)];
        readMark.image = [UIImage imageNamed:@"main_message_number.png"];
        [self.contentView addSubview:readMark];
        markLabel = [[UILabel alloc] initWithFrame:CGRectMake(21.0+12.0, 8.0, 28.0, 14.0)];
        markLabel.text = @"未读";
        markLabel.backgroundColor = [UIColor clearColor];
        markLabel.textColor = [UIColor whiteColor];
        markLabel.font = [UIFont systemFontOfSize:10.0];
        [self.contentView addSubview:markLabel];
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

-(void) setStrMsgIconUrl:(NSString *)strMsgIconUrl
{
    [self.appImgView setImageWithURL:[NSURL URLWithString:strMsgIconUrl]];
}

-(void) clearData
{
    
}
@end
