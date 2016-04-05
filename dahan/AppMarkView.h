//
//  AppMarkView.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-19.
//
//

#import <UIKit/UIKit.h>
@class AppMarkView;
@protocol AppMarkViewDelegate <NSObject>

-(void) clickAppMarkView:(NSString*)appid;

@end

@interface AppMarkView : UIView

@property(nonatomic, retain) UIButton* markBtn;
@property(nonatomic, retain) UILabel* appLabel;
@property(nonatomic, retain) UIImageView* updateMarkImgView;
@property(nonatomic, retain) UILabel* markLabel;
@property(nonatomic, retain) NSString* strUrl;
@property(nonatomic, retain) NSString* appID;
@property(nonatomic, assign) id<AppMarkViewDelegate> myDelegate;

@end
