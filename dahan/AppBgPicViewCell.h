//
//  AppBgPicViewCell.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-4.
//
//

#import <UIKit/UIKit.h>

@interface AppBgPicViewCell : UITableViewCell

@property(nonatomic, retain) NSString* bgPicID1;
@property(nonatomic, retain) UIImageView* bgPreviewImgView1;
@property(nonatomic, retain) UIImageView* bgImgView1;
@property(nonatomic, retain) UIImageView* bgNavImgView1;
@property(nonatomic, retain) UIImageView* bgMenuBarImgView1;
@property(nonatomic, retain) UILabel* previewImgNameLabel1;
@property(nonatomic, retain) NSString* bgPicUrl1;
@property(nonatomic, retain) NSString* bgPreviewPicUrl1;
@property(nonatomic, retain) NSString* bgNavPicUrl1;
@property(nonatomic, retain) NSString* bgMenuBarPicUrl1;


@property(nonatomic, retain) NSString* bgPicID2;
@property(nonatomic, retain) UIImageView* bgPreviewImgView2;
@property(nonatomic, retain) UIImageView* bgImgView2;
@property(nonatomic, retain) UIImageView* bgNavImgView2;
@property(nonatomic, retain) UIImageView* bgMenuBarImgView2;
@property(nonatomic, retain) UILabel* previewImgNameLabel2;
@property(nonatomic, retain) NSString* bgPicUrl2;
@property(nonatomic, retain) NSString* bgPreviewPicUrl2;
@property(nonatomic, retain) NSString* bgNavPicUrl2;
@property(nonatomic, retain) NSString* bgMenuBarPicUrl2;

@property(nonatomic, retain) NSString* bgPicID3;
@property(nonatomic, retain) UIImageView* bgPreviewImgView3;
@property(nonatomic, retain) UIImageView* bgImgView3;
@property(nonatomic, retain) UIImageView* bgNavImgView3;
@property(nonatomic, retain) UIImageView* bgMenuBarImgView3;
@property(nonatomic, retain) UILabel* previewImgNameLabel3;
@property(nonatomic, retain) NSString* bgPicUrl3;
@property(nonatomic, retain) NSString* bgPreviewPicUrl3;
@property(nonatomic, retain) NSString* bgNavPicUrl3;
@property(nonatomic, retain) NSString* bgMenuBarPicUrl3;

@property(nonatomic, retain) UIImageView* selectedMark;
@property(nonatomic, retain) NSString* selectedBgPicID;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) bool bMove;

-(void) clearData;
@end
