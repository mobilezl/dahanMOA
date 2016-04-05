//
//  CustomActivityIndicatorView.m
//  pgapp
//
//  Created by 陈 利群 on 14-8-2.
//
//

#import "CustomActivityIndicatorView.h"

@implementation CustomActivityIndicatorView

@synthesize myActiviyIV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){

        // Initialization code
        UIActivityIndicatorView* av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(230.0, 260.0, 40.0, 40.0)];
//        av.center=self.center;
        av.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [av startAnimating];
        av.hidden = FALSE;
        [self addSubview:av];
        
        UILabel* loadingTip = [[UILabel alloc] initWithFrame:CGRectMake(220, 300.0, 80.0, 20.0)];
        loadingTip.text = @"正在加载...";
        loadingTip.textColor = [UIColor grayColor];
        loadingTip.textAlignment = NSTextAlignmentCenter;
        loadingTip.font = [UIFont systemFontOfSize:14.0];
        loadingTip.tag = 101;
        loadingTip.hidden = FALSE;
        [self addSubview:loadingTip];
        }else{
            // Initialization code
            UIActivityIndicatorView* av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 40.0)];
            av.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [av startAnimating];
            av.hidden = FALSE;
            [self addSubview:av];
            
            UILabel* loadingTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 50.0, 80.0, 20.0)];
            loadingTip.text = @"正在加载...";
            loadingTip.textColor = [UIColor grayColor];
            loadingTip.textAlignment = NSTextAlignmentCenter;
            loadingTip.font = [UIFont systemFontOfSize:14.0];
            loadingTip.tag = 101;
            loadingTip.hidden = FALSE;
            [self addSubview:loadingTip];
        }
    }
    return self;
}

-(void) removeActiviyView
{

    for (id subview in self.subviews) {
        if ([[subview class] isSubclassOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView*)subview) removeFromSuperview];
           // ((UIActivityIndicatorView*)subview).hidden = TRUE;
        }
        else if([[subview class] isSubclassOfClass:[UILabel class]])
        {
            if(((UILabel*)subview).tag == 101)
            {
                [((UILabel*)subview) removeFromSuperview];
               // ((UILabel*)subview).hidden = TRUE;
            }
        }
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
