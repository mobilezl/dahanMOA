//
//  AppMarkView.m
//  pgapp
// 预装应用模块
//  Created by 陈 利群 on 14-3-19.
//
//

#import "AppMarkView.h"
//#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
@implementation AppMarkView

@synthesize markBtn;
@synthesize appLabel;
@synthesize updateMarkImgView;
@synthesize appID;
@synthesize myDelegate;
@synthesize markLabel;

- (void)clickBtn:(id)sender{
    
    if (self.myDelegate) {
        if ([self.myDelegate respondsToSelector:@selector(clickAppMarkView:)]) {
            [self.myDelegate clickAppMarkView:self.appID];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        if (self) {
            // Initialization code
            
            markBtn = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-64.0)/2, 0, 96.0, 96.0)];
            //[markBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
            [markBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            // markBtn.layer.borderColor = [UIColor redColor].CGColor;
            // markBtn.layer.borderWidth = 1;
            [self addSubview:markBtn];
            
            appLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 100.0+2.0, frame.size.width, 16.0)];
            appLabel.text = @"开心";
            appLabel.font = [UIFont systemFontOfSize:16.0];
            appLabel.textColor = [UIColor whiteColor];
            appLabel.backgroundColor = [UIColor clearColor];
            appLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:appLabel];
            
            updateMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(76.0, 6.0, 8.0, 8.0)];
            updateMarkImgView.image = [UIImage imageNamed:@"main_message_number.png"];
            updateMarkImgView.hidden = TRUE;
            [self addSubview:updateMarkImgView];
            
            markLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 1.0, 28.0, 14.0)];
            //markLabel.text = @"1";
            markLabel.backgroundColor = [UIColor clearColor];
            markLabel.textColor = [UIColor whiteColor];
            markLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:markLabel];
            
            [self bringSubviewToFront:updateMarkImgView];
            [self bringSubviewToFront:markLabel];
        }
        
        return self;

    }else{
    if (self) {
        // Initialization code
       
        markBtn = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-64.0)/2, 0, 64.0, 64.0)];
        //[markBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
       // markBtn.layer.borderColor = [UIColor redColor].CGColor;
       // markBtn.layer.borderWidth = 1;
        [self addSubview:markBtn];
        
        appLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.0+2.0, frame.size.width, 16.0)];
        appLabel.text = @"开心";
        appLabel.font = [UIFont systemFontOfSize:12.0];
        appLabel.textColor = [UIColor whiteColor];
        appLabel.backgroundColor = [UIColor clearColor];
        appLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:appLabel];
        
        updateMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(76.0, 6.0, 8.0, 8.0)];
        updateMarkImgView.image = [UIImage imageNamed:@"main_message_number.png"];
        updateMarkImgView.hidden = TRUE;
        [self addSubview:updateMarkImgView];
        
        markLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 1.0, 28.0, 14.0)];
        //markLabel.text = @"1";
        markLabel.backgroundColor = [UIColor clearColor];
        markLabel.textColor = [UIColor whiteColor];
        markLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:markLabel];
        
        [self bringSubviewToFront:updateMarkImgView];
        [self bringSubviewToFront:markLabel];
    }

    return self;
        }
}

-(void) setStrUrl:(NSString *)strUrl
{
  
    if([strUrl isEqualToString:@"add.png"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    }
    else if([strUrl isEqualToString:@"xinwen"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon_xinwen.png"] forState:UIControlStateNormal];
    }
    else if([strUrl isEqualToString:@"gonggao"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon_gonggao.png"] forState:UIControlStateNormal];
    }
    else if([strUrl isEqualToString:@"liuchenggenzong"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon_liuchenggenzong.png"] forState:UIControlStateNormal];
    }
    else if([strUrl isEqualToString:@"baobiao"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon_baobiao.png"] forState:UIControlStateNormal];
    }
    else if([strUrl isEqualToString:@"liuchengfaqi"])
    {
        [markBtn setBackgroundImage:[UIImage imageNamed:@"AppIcon_liuchengfaqi.png"] forState:UIControlStateNormal];
    }
    else
    {
        [markBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strUrl]];
    }


}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
