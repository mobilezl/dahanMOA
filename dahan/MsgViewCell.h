//
//  MsgViewCell.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-18.
//
//

#import <UIKit/UIKit.h>

@interface MsgViewCell : UITableViewCell

@property(nonatomic, retain) UIImageView* appImgView;
@property(nonatomic, retain) UILabel* appNameLabel;
@property(nonatomic, retain) UILabel* msgContentLabel;
@property(nonatomic, retain) NSString* msgID;
@property(nonatomic, retain) NSString* strMsgIconUrl;
@property(nonatomic, retain) UIImageView* readMark;
@property(nonatomic, retain) UILabel* markLabel;
-(void) clearData;

@end
