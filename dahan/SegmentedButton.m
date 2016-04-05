//
//  SegmentedButton.m
//
//  Created by chen liqun on 6/16/13.
//  Copyright (c) 2012年 clq. All rights reserved.
//

#import "SegmentedButton.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonTool.h"
@implementation SegmentedButton
@synthesize buttonPressActionHandler;
@synthesize buttonsBkColor;
@synthesize buttonBkColor;
@synthesize myDelegate;
@synthesize buttons;
@synthesize segmentedButtonType;
@synthesize btnNormalImgs;
@synthesize btnSelectImgs;


- (void)initWithTitles:(NSArray *)buttonTitles buttonTintNormal:(UIColor *)backgroundColorNormal buttonTintPressed:(UIColor *)backgroundColorPressed actionHandler:(void (^)(int buttonIndex))actionHandler {
    buttons = [[NSMutableArray alloc] init];
    int numberOfButtons = [buttonTitles count];
    for (int i = 0; i < numberOfButtons; i++) {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        newButton.frame = CGRectMake(i * (self.frame.size.width/numberOfButtons), 0, self.frame.size.width/numberOfButtons, 30.0);
        newButton.layer.bounds = CGRectMake(0, 0, self.frame.size.width/numberOfButtons, 30.0);
        newButton.layer.borderWidth = .5;
        newButton.layer.borderColor = [UIColor colorWithWhite:.6 alpha:1].CGColor;
        newButton.backgroundColor = backgroundColorNormal;
        newButton.clipsToBounds = YES;
        newButton.layer.masksToBounds = YES;
        
        CAGradientLayer *shineLayer = [CAGradientLayer layer];
        shineLayer.frame = newButton.layer.bounds;
        shineLayer.colors = [NSArray arrayWithObjects:
        (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
        (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
        (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
        (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
        (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
        nil];
        shineLayer.locations = [NSArray arrayWithObjects:
        [NSNumber numberWithFloat:0.0f],
        [NSNumber numberWithFloat:0.5f],
        [NSNumber numberWithFloat:0.5f],
        [NSNumber numberWithFloat:0.8f],
        [NSNumber numberWithFloat:1.0f],
        nil];
        [newButton.layer addSublayer:shineLayer];
        
        [newButton addTarget:self action:@selector(buttonUp:event:) forControlEvents:(UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchDragExit)];
        [newButton addTarget:self action:@selector(buttonDown:event:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
        [newButton addTarget:self action:@selector(buttonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        newButton.titleLabel.text = [buttonTitles objectAtIndex:i];
        [newButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        newButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        newButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        const CGFloat *componentColors = CGColorGetComponents(backgroundColorNormal.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        if (colorBrightness < 0.5) {
            [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [newButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        } else {
            [newButton setTitleColor:[UIColor colorWithWhite:.2 alpha:1] forState:UIControlStateNormal];
            [newButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        
        [self addSubview:newButton];
        [buttons addObject:newButton];
        buttonBackgroundColorForStateNormal = backgroundColorNormal;
        buttonBackgroundColorForStatePressed = backgroundColorPressed;
    }
    
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor colorWithWhite:.6 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
     
    buttonPressActionHandler = [actionHandler copy];
    
    
  }

- (void)initWithImages:(NSArray *)buttonImages ButtonTitles:(NSArray*) titles buttonTintNormal:(UIColor *)backgroundColorNormal buttonTintPressed:(UIColor *)backgroundColorPressed buttonImgBk: (UIImage*) bk FirstButtonIsSelected:(BOOL) selected actionHandler:(void (^)(int buttonIndex))actionHandler {
    buttons = [[NSMutableArray alloc] init];
    int numberOfButtons = [buttonImages count];
    for (int i = 0; i < numberOfButtons; i++) {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
           newButton.frame = CGRectMake(i * (self.frame.size.width/numberOfButtons), 1, self.frame.size.width/numberOfButtons, self.frame.size.height-2);
        }else{
            newButton.frame = CGRectMake(i * (self.frame.size.width/numberOfButtons), 1, self.frame.size.width/numberOfButtons, self.frame.size.height-2);
            
//            newButton.frame = CGRectMake(i * (self.frame.size.width/4)-40, 1, self.frame.size.width/numberOfButtons, self.frame.size.height-2);

        }
        newButton.layer.bounds = CGRectMake(0, 0, self.frame.size.width/numberOfButtons, self.frame.size.height-3);
        
        
        float newh = newButton.frame.size.height;
        [newButton addTarget:self action:@selector(buttonUp:event:) forControlEvents:(UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchDragExit)];
        [newButton addTarget:self action:@selector(buttonDown:event:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
        [newButton addTarget:self action:@selector(buttonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        newButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [newButton setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:newButton];

        
        
        
        
      
        
        
             // [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //newButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [buttons addObject:newButton];
        //self.buttonBkColor = [newButton backgroundColor];
        //buttonBackgroundColorForStateNormal = backgroundColorPressed;
       // buttonBackgroundColorForStatePressed = backgroundColorNormal;
        if(selected && i == 0)
        {
   //         [newButton setBackgroundColor:buttonBackgroundColorForStatePressed];
        }
    }

   // self.backgroundColor = backgroundColorNormal;
    buttonPressActionHandler = [actionHandler copy];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //nothing
    }
    return self;
}

- (void)buttonUp:(id)aButton event:(id)event {
    UIButton *button = (UIButton *)aButton;
    int selIndex = 0;
    for(int i = 0; i < [buttons count]; ++i)
    {
        UIButton* b = [buttons objectAtIndex:i];
        if(button != b)
        {
           // [b setBackgroundColor:buttonBkColor];
            [b setImage:[btnNormalImgs objectAtIndex:i] forState:UIControlStateNormal];

        }
        else
        {
            selIndex = i;
        }
    }
   // [button setBackgroundColor:buttonBackgroundColorForStateNormal];
    [button setImage:[btnSelectImgs objectAtIndex:selIndex] forState:UIControlStateNormal];

}

- (void)buttonPressed:(id)aButton event:(id)event {
    if (buttonPressActionHandler) {
        for (int i = 0; i < [buttons count]; i++) {
            if (aButton == [buttons objectAtIndex:i]) {
                buttonPressActionHandler(i);
                if(self.myDelegate)
                {
                    if([self.myDelegate respondsToSelector:@selector(clickSegmentedButton:SegmentedButtonType:)])
                    {
                        [self.myDelegate clickSegmentedButton:i SegmentedButtonType:self.segmentedButtonType];
                    }
                }
            }
        }
    }
}


- (void)buttonDown:(id)aButton event:(id)event {
    UIButton *button = (UIButton *)aButton;
    
}

- (void)setButtonPressActionHandler:(void (^)(int buttonIndex))actionHandler {
    buttonPressActionHandler = [actionHandler copy];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
//*/
//#pragma mark -设置小红圈里的数字
//- (void)setItemBadgeNumber:(NSInteger)number
//{
//    
//      NSLog(@"number -------%d",number);
//    if (number != 0) {
//        _badgeValueView = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width/3)-30, 1,badgeValueViewWH, badgeValueViewWH)];
//        [_badgeValueView setBackgroundImage:[UIImage imageNamed:badgeValueViewImageName] forState:(UIControlStateNormal)];
//        _badgeValueView.titleLabel.font = badgeValueFont;
//        [_badgeValueView setTitleColor:badgeValueColor forState:(UIControlStateNormal)];
//        //    _badgeValueView.hidden = NO;
//        _badgeValueView.adjustsImageWhenHighlighted = NO;
//        [self.badgeValueView setTitle:[NSString stringWithFormat:@"11%d",number] forState:(UIControlStateNormal)];
//      
//        [self addSubview:_badgeValueView];
//
////        
////        if (self.badgeValueView.hidden) {
////            
////            self.badgeValueView.hidden = NO;
////        }
////        [self.badgeValueView setTitle:[NSString stringWithFormat:@"%d11",number] forState:(UIControlStateNormal)];
//    }
//    else{
//        
//        self.badgeValueView.hidden = YES;
//    }
//}
//
//
//- (UIButton *)badgeValueView
//{
//    if (_badgeValueView == nil) {
//        
//        CGFloat x = itemWH - badgeValueViewWH + 5;
//        CGFloat y = -5;
//        _badgeValueView = [[UIButton alloc] initWithFrame:CGRectMake(x, y,badgeValueViewWH, badgeValueViewWH)];
//        [_badgeValueView setBackgroundImage:[UIImage imageNamed:badgeValueViewImageName] forState:(UIControlStateNormal)];
//        _badgeValueView.titleLabel.font = badgeValueFont;
//        [_badgeValueView setTitleColor:badgeValueColor forState:(UIControlStateNormal)];
//        _badgeValueView.hidden = NO;
//        _badgeValueView.adjustsImageWhenHighlighted = NO;
//    }
//    return  _badgeValueView;
//}

@end
