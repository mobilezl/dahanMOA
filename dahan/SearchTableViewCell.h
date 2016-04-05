//
//  SearchTableViewCell.h
//  pgapp
//
//  Created by Leo on 14-10-10.
//
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *UserName;

@property (strong, nonatomic) IBOutlet UILabel *Title;

@property(nonatomic, retain) NSString* UserID;
@end
