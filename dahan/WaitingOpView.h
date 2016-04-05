//
//  WaitingOpView.h
//  pgapp
//
//  Created by 陈 利群 on 14-7-29.
//
//

#import <UIKit/UIKit.h>

@protocol WaitingOpViewDelegate <NSObject>

-(void) clickWaitingOpView;

@end

@interface WaitingOpView : UIView

@property(nonatomic, retain) UILabel* unMessageNumberLabel;
@property(nonatomic, retain) UILabel* daibanLabel;
@property(nonatomic, assign) id<WaitingOpViewDelegate> myDelegate;

@end
