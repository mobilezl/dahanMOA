//
//  ApprovalHistory.h
//  pgapp
//
//  Created by Leo on 14-11-28.
//
//

#import <Foundation/Foundation.h>

@interface ApprovalHistory : NSObject
@property(nonatomic, retain) NSString* Approver;
@property(nonatomic, retain) NSString* ApproverTitle;
@property(nonatomic, retain) NSString* ToApproverTime;
@property(nonatomic, retain) NSString* ApproverTime;
@property(nonatomic, retain) NSString* ApprovalComment;

@end
