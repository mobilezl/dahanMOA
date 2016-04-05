//
//  SegmentedButton.h

//
//  Created by chen liqun on 6/16/13.
//  Copyright (c) 2012年 clq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define itemWH 66 //tabBar里按钮的大小
#define itemTitleColor [UIColor blackColor]    //item里标题默认颜色
#define selectedItemTitleColor [UIColor blueColor]  // item被选中时标题的颜色
#define itemTitleFont [UIFont systemFontOfSize:7]  //item 标题 字体font
#define badgeValueViewImageName @"userinfo_vip_background@2x.png" //小红圈 背景图片名称
#define badgeValueFont [UIFont systemFontOfSize:12]  //小红圈里字体的大小
#define badgeValueColor [UIColor whiteColor] //小红圈里字体的颜色
#define badgeValueViewWH itemWH * 0.3  //小红圈的大小
@protocol SegmentedButtonDelegate <NSObject>

- (void) clickSegmentedButton:(NSInteger) index SegmentedButtonType:(NSInteger) type;

@end

@interface SegmentedButton : UIView {
    UIColor *buttonBackgroundColorForStateNormal;
    UIColor *buttonBackgroundColorForStatePressed;
    NSMutableArray *buttons;

}
@property (nonatomic, copy) void (^buttonPressActionHandler)(int buttonIndex);
@property (nonatomic, retain) UIColor* buttonBkColor;
@property (nonatomic, retain) NSMutableArray* buttonsBkColor;
@property (nonatomic, assign) id<SegmentedButtonDelegate> myDelegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSArray* btnNormalImgs;
@property (nonatomic, retain) NSArray* btnSelectImgs;



@property (nonatomic, assign) NSInteger segmentedButtonType;

- (void)initWithTitles:(NSArray *)buttonTitles buttonTintNormal:(UIColor *)backgroundColorNormal buttonTintPressed:(UIColor *)backgroundColorPressed actionHandler:(void (^)(int buttonIndex))actionHandler;

- (void)initWithImages:(NSArray *)buttonImages ButtonTitles:(NSArray*) titles buttonTintNormal:(UIColor *)backgroundColorNormal buttonTintPressed:(UIColor *)backgroundColorPressed buttonImgBk: (UIImage*) bk FirstButtonIsSelected:(BOOL) selected actionHandler:(void (^)(int buttonIndex))actionHandler;



@property (nonatomic, strong) UIButton *badgeValueView;
- (void)setItemBadgeNumber:(NSInteger)number;
@end
