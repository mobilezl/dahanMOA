//
//  XMLHelper.h
//  pgapp
//
//  Created by 陈 利群 on 14-3-16.
//
//

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) NSMutableArray *dictionaryStackMbAry;
@property(nonatomic, retain) NSMutableString *textInProgressMbStr;
@property(nonatomic, retain) NSError *errorPointer;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;

- (id)initWithError:(NSError *)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end
