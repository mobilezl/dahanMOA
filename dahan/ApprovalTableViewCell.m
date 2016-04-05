//
//  ApprovalTableViewCell.m
//  pgapp
//
//  Created by Leo on 14-9-19.
//
//

#import "ApprovalTableViewCell.h"

@implementation ApprovalTableViewCell


@synthesize ProcessName;
@synthesize Submitter;
@synthesize Preview;
@synthesize SubmitDate;
@synthesize processType;
@synthesize ProcessSN;
@synthesize ApproverLoginName;
- (void)awakeFromNib
{
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int screenWidth = size.width;
    int screenHeight = size.height;

    // Initialization code
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        self.SubmitDate.frame = CGRectMake(screenWidth-180, 28.0, 150.0, 21.0);
         self.Preview.frame = CGRectMake(10, 49, 500, 29);
        self.ProcessName.font = [UIFont fontWithName:@"Arial" size:20];
        self.Submitter.font = [UIFont fontWithName:@"Arial" size:17];
        self.SubmitDate.font = [UIFont fontWithName:@"Arial" size:17];
         self.Preview.font = [UIFont fontWithName:@"Arial" size:17];
        
    }
    
      
    [self.Preview setTextColor:[UIColor colorWithRed:105.f/255.f green:105.f/255.f blue:105.f/255.f alpha:1]];
    [self.SubmitDate setTextColor:[UIColor colorWithRed:105.f/255.f green:105.f/255.f blue:105.f/255.f alpha:1]];
    [self.Submitter setTextColor:[UIColor colorWithRed:105.f/255.f green:105.f/255.f blue:105.f/255.f alpha:1]];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    

    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

//#pragma mark 设置Cell的边框宽度
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 10;
//    frame.size.width -= 2 * 10;
//    [super setFrame:frame];
//}


@end
