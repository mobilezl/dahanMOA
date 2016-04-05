//
//  UserInfoView.h
//  pgapp
//
//  Created by 陈 利群 on 14-7-12.
//
//

#import <UIKit/UIKit.h>

#import "WaitingOpView.h"
@interface UserInfoView : UIView

@property(nonatomic, retain) UIImageView* headImgView;
@property(nonatomic, retain) UILabel* userNameLabel_CH;
@property(nonatomic, retain) UILabel* userNameLabel_EN;
@property(nonatomic, retain) UILabel* userPostLabel;
@property(nonatomic, retain) UILabel* unMessageNumberLabel;
@property(nonatomic, retain) UILabel* daibanLabel;
@property(nonatomic, retain) UILabel* lineLable;

@property(nonatomic, retain) WaitingOpView* waitingOpView;

@property(nonatomic, retain) NSString* strUrl;
@end
