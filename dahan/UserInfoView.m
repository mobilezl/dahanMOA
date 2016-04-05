//
//  UserInfoView.m
//  pgapp
//
//  Created by 陈 利群 on 14-7-12.
//
//

#import "UserInfoView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/CALayer.h>

@implementation UserInfoView

@synthesize headImgView;
@synthesize userNameLabel_CH;
@synthesize userNameLabel_EN;
@synthesize userPostLabel;
@synthesize unMessageNumberLabel;
@synthesize daibanLabel;
@synthesize lineLable;

@synthesize waitingOpView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width/2)-55, frame.origin.y+80, 100.0, 100.0)];
//        headImgView.frame = CGRectMake(20.f, 20.f, 80.f, 80.f);
        headImgView.layer.masksToBounds = YES;
        headImgView.layer.cornerRadius = 50;
        [self addSubview:headImgView];
        
        
        userNameLabel_CH = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 175.0+4.0+2.0, 140.0, 24.0)];
        userNameLabel_CH.textColor = [UIColor whiteColor];
        userNameLabel_CH.font = [UIFont systemFontOfSize:22.0];
        userNameLabel_CH.textAlignment = NSTextAlignmentRight;
            
        [self addSubview:userNameLabel_CH];
            
            
            lineLable = [[UILabel alloc] initWithFrame:CGRectMake(245.0, 176.0+4.0+2.0, 140.0, 33.0)];
            lineLable.textColor = [UIColor whiteColor];
            lineLable.font = [UIFont systemFontOfSize:43.0];
            lineLable.textAlignment = NSTextAlignmentRight;
            lineLable.text=@"|";
            [self addSubview:lineLable];

        
        userNameLabel_EN = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 180.0+4.0+2.0+18.0, 140.0, 16.0)];
        userNameLabel_EN.textColor = [UIColor whiteColor];
        userNameLabel_EN.textAlignment = NSTextAlignmentRight;
        userNameLabel_EN.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:userNameLabel_EN];
        
        userPostLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 185.0+4.0+2.0+18.0*2, 140.0, 16.0)];
        userPostLabel.textColor = [UIColor whiteColor];
        userPostLabel.textAlignment = NSTextAlignmentRight;
        userPostLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:userPostLabel];
        
        unMessageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 80.0+4.0+4.0, 40.0, 24.0)];
        unMessageNumberLabel.textColor = [UIColor whiteColor];
        unMessageNumberLabel.textAlignment = NSTextAlignmentLeft;
        unMessageNumberLabel.font = [UIFont systemFontOfSize:18.0];
//        [self addSubview:unMessageNumberLabel];
        
        daibanLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0+20.0, 80.0+4.0+2.0, 40.0, 24.0)];
        daibanLabel.textColor = [UIColor whiteColor];
        daibanLabel.textAlignment = NSTextAlignmentLeft;
        daibanLabel.font = [UIFont systemFontOfSize:10.0];
//       [self addSubview:daibanLabel];
            
//            waitingOpView = [[WaitingOpView alloc] initWithFrame:CGRectMake(170.0, 80.0+4.0+4.0, 40.0, 24.0)];
//            
//            [self addSubview:waitingOpView];

        
        waitingOpView = [[WaitingOpView alloc] initWithFrame:CGRectMake(400.0, 175.0+4.0+4.0, 40.0, 24.0)];
        
        [self addSubview:waitingOpView];
        }else{
            headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-80.0)/2, frame.origin.y+2, 80.0, 80.0)];
            //headImgView.frame = CGRectMake(20.f, 20.f, 80.f, 80.f);
            headImgView.layer.masksToBounds = YES;
            headImgView.layer.cornerRadius = 40;
            [self addSubview:headImgView];
            
            
            
            userNameLabel_CH = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0+4.0+2.0, 140.0, 24.0)];
            userNameLabel_CH.textColor = [UIColor whiteColor];
            userNameLabel_CH.font = [UIFont systemFontOfSize:18.0];
            userNameLabel_CH.textAlignment = NSTextAlignmentRight;
            [self addSubview:userNameLabel_CH];
            
            userNameLabel_EN = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0+4.0+2.0+18.0, 140.0, 16.0)];
            userNameLabel_EN.textColor = [UIColor whiteColor];
            userNameLabel_EN.textAlignment = NSTextAlignmentRight;
            userNameLabel_EN.font = [UIFont systemFontOfSize:10.0];
            [self addSubview:userNameLabel_EN];
            
            userPostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0+4.0+2.0+18.0*2, 140.0, 16.0)];
            userPostLabel.textColor = [UIColor whiteColor];
            userPostLabel.textAlignment = NSTextAlignmentRight;
            userPostLabel.font = [UIFont systemFontOfSize:11.0];
            [self addSubview:userPostLabel];
            
            unMessageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 80.0+4.0+4.0, 40.0, 24.0)];
            unMessageNumberLabel.textColor = [UIColor whiteColor];
            unMessageNumberLabel.textAlignment = NSTextAlignmentLeft;
            unMessageNumberLabel.font = [UIFont systemFontOfSize:18.0];
            //[self addSubview:unMessageNumberLabel];
        
            daibanLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0+20.0, 80.0+4.0+2.0, 40.0, 24.0)];
            daibanLabel.textColor = [UIColor whiteColor];
            daibanLabel.textAlignment = NSTextAlignmentLeft;
            daibanLabel.font = [UIFont systemFontOfSize:10.0];
            // [self addSubview:daibanLabel];
            
            
            waitingOpView = [[WaitingOpView alloc] initWithFrame:CGRectMake(170.0, 80.0+4.0+4.0, 40.0, 24.0)];
            
            [self addSubview:waitingOpView];

        }
    }
    
    return self;
}

-(void) setStrUrl:(NSString *)strUrl
{
    
    if([strUrl isEqualToString:@""])
    {
       // headImgView.image = [UIImage imageNamed:@"defaulHead.png"];
        headImgView.hidden = TRUE;
    }
    else
    {
        headImgView.hidden = FALSE;
      [self.headImgView setImageWithURL:[NSURL URLWithString:strUrl]];
        
    }
    
}

-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
    
    }else{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 159.5f, 80.0+10.0f);
    CGContextAddLineToPoint(context, 159.5f, 80.0+10.0+26.0f);
    

    CGContextSetShouldAntialias(context, NO);

    CGContextStrokePath(context);
    }
    
}
@end
