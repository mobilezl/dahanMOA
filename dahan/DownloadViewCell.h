//
//  DownloadViewCell.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-24.
//
//

#import <UIKit/UIKit.h>

@class DownloadViewCell;

@protocol DownloadVCDelegate <NSObject>

-(void) clickSatateBtn:(DownloadViewCell*) sender;
-(void) backLoginNotification:(DownloadViewCell*) sender;

@end

@interface DownloadViewCell : UITableViewCell<UIAlertViewDelegate>

@property(nonatomic, retain) UIImageView* appImgView;
@property(nonatomic, retain) UILabel* appNameLabel;
@property(nonatomic, retain) UILabel* appSizeLabel;
@property(nonatomic, retain) UIButton* appSatateBtn;
@property(nonatomic, retain) NSString* appID;
@property(nonatomic, retain) NSString* strAppIconUrl;
@property(nonatomic, retain) NSString* strAppUrl;
@property(nonatomic, assign) int appSatate;
@property(nonatomic, retain) NSString* pgComPkgVer;
@property(nonatomic, assign) BOOL bDownLoadPgComPkg;
@property(nonatomic, assign) BOOL appDownLoadOK;
@property(nonatomic, assign) id<DownloadVCDelegate> myDelegate;

-(void) clearData;
@end
