//
//  WaitingOpView.m
//  pgapp
//
//  Created by 陈 利群 on 14-7-29.
//
//

#import "WaitingOpView.h"

@implementation WaitingOpView

@synthesize unMessageNumberLabel;
@synthesize daibanLabel;
@synthesize myDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
 
    
         if (self) {
             // Initialization code
             unMessageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 24.0)];
             unMessageNumberLabel.textColor = [UIColor whiteColor];
             unMessageNumberLabel.textAlignment = NSTextAlignmentLeft;
             unMessageNumberLabel.font = [UIFont systemFontOfSize:28.0];
             //unMessageNumberLabel.text = @"0";
             [self addSubview:unMessageNumberLabel];
             
             daibanLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 40.0, 24.0)];
             daibanLabel.textColor = [UIColor whiteColor];
             daibanLabel.textAlignment = NSTextAlignmentLeft;
             daibanLabel.font = [UIFont systemFontOfSize:14.0];
             daibanLabel.text = @"待办";
             [self addSubview:daibanLabel];
         }
         return self;
}else{
     if (self) {
    // Initialization code
    unMessageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 24.0)];
    unMessageNumberLabel.textColor = [UIColor whiteColor];
    unMessageNumberLabel.textAlignment = NSTextAlignmentLeft;
    unMessageNumberLabel.font = [UIFont systemFontOfSize:18.0];
    //unMessageNumberLabel.text = @"0";
    [self addSubview:unMessageNumberLabel];
    
    daibanLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 40.0, 24.0)];
    daibanLabel.textColor = [UIColor whiteColor];
    daibanLabel.textAlignment = NSTextAlignmentLeft;
    daibanLabel.font = [UIFont systemFontOfSize:10.0];
    daibanLabel.text = @"待办";
    [self addSubview:daibanLabel];
}
    return self;
}

  }



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"#########################touchesEnded");
    
  //  if(![self.unMessageNumberLabel.text isEqualToString:@"0"])
//    {
        if(self.myDelegate)
        {
            if([self.myDelegate respondsToSelector:@selector(clickWaitingOpView)])
            {
                [self.myDelegate clickWaitingOpView];
            }
        }

//    }
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"xingchen"
//                                                    message:@"message"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"  
//                                          otherButtonTitles:nil];  
//    [alert show];


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
