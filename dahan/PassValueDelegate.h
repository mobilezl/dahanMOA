//
//  PassValueDelegate.h
//  pgapp
//
//  Created by Leo on 14-9-25.
//
//

#import <UIKit/UIKit.h>
@protocol PassValueVCDelegate <NSObject>

-(void) passValue:(id) value;

@end
@interface PassValueDelegate : UIViewController

@end
