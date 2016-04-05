//
//  Approval.h
//  pgapp
//
//  Created by Leo on 14-9-18.
//
//

#import <Foundation/Foundation.h>

@interface Approval : NSObject

@property(nonatomic, retain) NSString* ProcessSN;
@property(nonatomic, retain) NSString* ProcessName;
@property(nonatomic, retain) NSString* Submitter;
@property(nonatomic, retain) NSString* SubmitDate;
@property(nonatomic, retain) NSString* Preview;
@property(nonatomic, retain) NSString* ProcessType;
@property(nonatomic, retain) NSString* ActionPermit;
@property(nonatomic, retain) NSString* ApproverLoginName;

@end
