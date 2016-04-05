//
//  AppBgPicViewCell.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-4.
//
//

#import "AppBgPicViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CommonTool.h"
@implementation AppBgPicViewCell

@synthesize bgImgView1;
@synthesize bgImgView2;
@synthesize bgImgView3;
@synthesize bgPicID1;
@synthesize bgPicID2;
@synthesize bgPicID3;
@synthesize bgPreviewImgView1;
@synthesize bgPreviewImgView2;
@synthesize bgPreviewImgView3;
@synthesize previewImgNameLabel1;
@synthesize previewImgNameLabel2;
@synthesize previewImgNameLabel3;
@synthesize bgNavImgView2;
@synthesize bgNavImgView1;
@synthesize bgNavImgView3;
@synthesize bgMenuBarImgView1;
@synthesize bgMenuBarImgView2;
@synthesize bgMenuBarImgView3;

@synthesize selectedMark;
@synthesize selectedBgPicID;
@synthesize selectedIndex;

@synthesize bMove;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bgImgView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        bgNavImgView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgMenuBarImgView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        bgPreviewImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 137.0, 100.0)];
        bgPreviewImgView1.layer.borderWidth = 1;
        bgPreviewImgView1.layer.borderColor = [UIColor grayColor].CGColor;
       // bgPreviewImgView1.layer.cornerRadius = 10;
        
        [self.contentView addSubview:bgPreviewImgView1];
        
        //previewImgNameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15.0+27.0, bgPreviewImgView1.frame.origin.y+bgPreviewImgView1.frame.size.height+5.0, 80.0, 20.0)];
        previewImgNameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(17.0, bgPreviewImgView1.frame.origin.y+bgPreviewImgView1.frame.size.height-22.0, 133.0, 20.0)];
        //previewImgNameLabel1.textAlignment = NSTextAlignmentCenter;
        previewImgNameLabel1.layer.backgroundColor = [UIColor whiteColor].CGColor;//[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff] .CGColor;
        //previewImgNameLabel1.layer.cornerRadius = 4.0;
        previewImgNameLabel1.textColor = [UIColor grayColor];
        previewImgNameLabel1.backgroundColor = [UIColor clearColor];
        previewImgNameLabel1.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:previewImgNameLabel1];
        
        bgImgView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgNavImgView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgMenuBarImgView2 = [[UIImageView alloc] initWithFrame:CGRectZero];

        bgPreviewImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15.0*2+137.0, 5.0, 137.0, 100.0)];
        bgPreviewImgView2.layer.borderWidth = 1;
        bgPreviewImgView2.layer.borderColor = [UIColor grayColor].CGColor;

        [self.contentView addSubview:bgPreviewImgView2];
        
        previewImgNameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(bgPreviewImgView2.frame.origin.x+2.0, bgPreviewImgView2.frame.origin.y+bgPreviewImgView2.frame.size.height-22.0, 133.0, 20.0)];
       // previewImgNameLabel2.textAlignment = NSTextAlignmentCenter;
        previewImgNameLabel2.layer.backgroundColor = [UIColor whiteColor].CGColor;//[[CommonTool commonToolManager] UIColorFromRGB:0x3795ff] .CGColor;
        //previewImgNameLabel2.layer.cornerRadius = 4.0;
        previewImgNameLabel2.textColor = [UIColor grayColor];
        previewImgNameLabel2.backgroundColor = [UIColor clearColor];
        previewImgNameLabel2.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:previewImgNameLabel2];
        
        
        
        bgImgView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgNavImgView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgMenuBarImgView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        bgPreviewImgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0*3+100.0*2, 5.0, 100.0, 120.0)];
        bgPreviewImgView3.layer.borderWidth = 2;
        bgPreviewImgView3.layer.borderColor = [UIColor blueColor].CGColor;

       // [self.contentView addSubview:bgPreviewImgView3];
        
        previewImgNameLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(bgPreviewImgView3.frame.origin.x+10.0, bgPreviewImgView3.frame.origin.y+bgPreviewImgView3.frame.size.height+5.0, 80.0, 20.0)];
        previewImgNameLabel3.textAlignment = NSTextAlignmentCenter;
        previewImgNameLabel3.layer.backgroundColor = [UIColor blueColor].CGColor;
        previewImgNameLabel3.layer.cornerRadius = 4.0;
        previewImgNameLabel3.textColor = [UIColor whiteColor];
        previewImgNameLabel3.backgroundColor = [UIColor clearColor];
        previewImgNameLabel3.font = [UIFont systemFontOfSize:14.0];
       // [self.contentView addSubview:previewImgNameLabel3];
        
        selectedMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectMark"]];
        selectedMark.hidden = FALSE;
        [self.contentView addSubview:selectedMark];
        [self.contentView bringSubviewToFront:selectedMark];
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    
    switch (self.selectedIndex)
    {
        case 0:
            selectedMark.frame = CGRectMake(bgPreviewImgView1.frame.origin.x+bgPreviewImgView1.frame.size.width-17.0, 88.0, 13.0, 13.0);
            break;
        case 1:
            selectedMark.frame = CGRectMake(bgPreviewImgView2.frame.origin.x+bgPreviewImgView2.frame.size.width-17.0, 108.0-20, 13.0, 13.0);
            break;
        case 2:
            selectedMark.frame = CGRectMake(bgPreviewImgView3.frame.origin.x+bgPreviewImgView3.frame.size.width-17.0, 108.0, 13.0, 13.0);
            break;
            
        default:
            break;
    }
    
}
-(void) setBgPreviewPicUrl1:(NSString *)bgPreviewPicUrl
{
    if([bgPreviewPicUrl isEqualToString:@"defaultBgPic"])
    {
        [bgPreviewImgView1 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [bgPreviewImgView1 setImageWithURL:[NSURL URLWithString:bgPreviewPicUrl]];
    }
}
-(void) setBgPreviewPicUrl2:(NSString *)bgPreviewPicUrl
{
    if([bgPreviewPicUrl isEqualToString:@"defaultBgPic"])
    {
        [bgPreviewImgView2 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [bgPreviewImgView2 setImageWithURL:[NSURL URLWithString:bgPreviewPicUrl]];
    }
}
-(void) setBgPreviewPicUrl3:(NSString *)bgPreviewPicUrl
{
    if([bgPreviewPicUrl isEqualToString:@"defaultBgPic"])
    {
        [self.bgPreviewImgView3 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [self.bgPreviewImgView3 setImageWithURL:[NSURL URLWithString:bgPreviewPicUrl]];
    }
}
-(void) setBgPicUrl1:(NSString *)bgPicUrl
{
    if([bgPicUrl isEqualToString:@"defaultBgPic"])
    {
        [bgImgView1 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [bgImgView1 setImageWithURL:[NSURL URLWithString:bgPicUrl]];
    }
}

-(void) setBgPicUrl2:(NSString *)bgPicUrl
{
    if([bgPicUrl isEqualToString:@"defaultBgPic"])
    {
        [bgImgView2 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [bgImgView2 setImageWithURL:[NSURL URLWithString:bgPicUrl]];
    }
}
-(void) setBgPicUrl3:(NSString *)bgPicUrl
{
    if([bgPicUrl isEqualToString:@"defaultBgPic"])
    {
        [bgImgView3 setImage:[UIImage imageNamed:@"main_bg.png"]];
    }
    else
    {
        [bgImgView3 setImageWithURL:[NSURL URLWithString:bgPicUrl]];
    }
}

-(void) setBgNavPicUrl1:(NSString *)bgNavPicUrl1
{
    if([bgNavPicUrl1 isEqualToString:@"defaultNavBgPic"])
    {
        [bgNavImgView1 setImage:[UIImage imageNamed:@"main_Navbg.png"]];
    }
    else
    {
        [bgNavImgView1 setImageWithURL:[NSURL URLWithString:bgNavPicUrl1]];
    }
}

-(void) setBgNavPicUrl2:(NSString *)bgNavPicUrl2
{
    if([bgNavPicUrl2 isEqualToString:@"defaultNavBgPic"])
    {
        [bgNavImgView2 setImage:[UIImage imageNamed:@"main_Navbg.png"]];
    }
    else
    {
        [bgNavImgView2 setImageWithURL:[NSURL URLWithString:bgNavPicUrl2]];
    }
}

-(void) setBgNavPicUrl3:(NSString *)bgNavPicUrl3
{
    if([bgNavPicUrl3 isEqualToString:@"defaultNavBgPic"])
    {
        [bgNavImgView3 setImage:[UIImage imageNamed:@"main_Navbg.png"]];
    }
    else
    {
        [bgNavImgView3 setImageWithURL:[NSURL URLWithString:bgNavPicUrl3]];
    }
}

-(void) setBgMenuBarPicUrl1:(NSString *)bgMenuBarPicUrl1
{
    if([bgMenuBarPicUrl1 isEqualToString:@"defaultMenuBarBgPic"])
    {
        [bgMenuBarImgView1 setImage:[UIImage imageNamed:@"main_MenuBarbg.png"]];
    }
    else
    {
        [bgMenuBarImgView1 setImageWithURL:[NSURL URLWithString:bgMenuBarPicUrl1]];
    }
}

-(void) setBgMenuBarPicUrl2:(NSString *)bgMenuBarPicUrl2
{
    if([bgMenuBarPicUrl2 isEqualToString:@"defaultMenuBarBgPic"])
    {
        [bgMenuBarImgView2 setImage:[UIImage imageNamed:@"main_MenuBarbg.png"]];
    }
    else
    {
        [bgMenuBarImgView2 setImageWithURL:[NSURL URLWithString:bgMenuBarPicUrl2]];
    }
}

-(void) setBgMenuBarPicUrl3:(NSString *)bgMenuBarPicUrl3
{
    if([bgMenuBarPicUrl3 isEqualToString:@"defaultMenuBarBgPic"])
    {
        [bgMenuBarImgView3 setImage:[UIImage imageNamed:@"main_MenuBarbg.png"]];
    }
    else
    {
        [bgMenuBarImgView3 setImageWithURL:[NSURL URLWithString:bgMenuBarPicUrl3]];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.bMove = NO;
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.bMove = YES;
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"#########################touchesEnded");
    self.selectedBgPicID = @"";
    if (!self.bMove) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.bgPreviewImgView1.frame,point)) {
            self.selectedBgPicID = self.bgPicID1;
            self.selectedIndex = 0;
        }
        else if (CGRectContainsPoint(self.bgPreviewImgView2.frame,point)) {
            self.selectedBgPicID = self.bgPicID2;
            self.selectedIndex = 1;
        }
        else if (CGRectContainsPoint(self.bgPreviewImgView3.frame,point)) {
            if(![self.bgPicID3 isEqualToString:@""])
            {
                self.selectedBgPicID = self.bgPicID3;
                self.selectedIndex = 2;
            }
        }
        
        [self setNeedsLayout];
    }
    [self.nextResponder touchesEnded:touches withEvent:event];
    
    //      AppId = 0003;
//    AppVer = "1.8";
//    DownLoadUrl = "itms-services://?action=download-manifest&url=https://dn-dahanoa.qbox.me/cofcoko.plist?1";
//    ForceUpdate = 0;
//    VersionInfo = "\U5927\U542b\U79fb\U52a8\U529e\U516c\U5ba2\U6237\U7aef\U5e73\U53f0";
//    VersionName = "1.8 Beta";
}

-(void) clearData
{
    self.bgPicID1 = @"";
    self.bgPicID2 = @"";
   // self.bgPicID3 = @"";
    self.previewImgNameLabel1.text = @"";
    self.previewImgNameLabel2.text = @"";
   // self.previewImgNameLabel3.text = @"";
    self.bgPicUrl1 = @"";
    self.bgPicUrl2 = @"";
  //  self.bgPicUrl3 = @"";
    self.bgNavPicUrl1 = @"";
    self.bgNavPicUrl2 = @"";
  //  self.bgNavPicUrl3 = @"";
    self.bgMenuBarPicUrl1 = @"";
    self.bgMenuBarPicUrl2 = @"";
  //  self.bgMenuBarPicUrl3 = @"";
    
    self.selectedBgPicID = @"";
    self.selectedIndex = -1;
    self.selectedMark.hidden = TRUE;
    self.bMove = FALSE;
}
@end
