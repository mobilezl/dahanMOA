//
//  DocFile.h
//  pgapp
//
//  Created by Leo on 15-1-15.
//
//

#import <Foundation/Foundation.h>

@interface DocFile : NSObject
@property(nonatomic, retain) NSString* AttachmentId;
@property(nonatomic, retain) NSString* FileName;
@property(nonatomic, retain) NSString* UploadUserName;
@property(nonatomic, retain) NSString* FileExtensionName;
@end
