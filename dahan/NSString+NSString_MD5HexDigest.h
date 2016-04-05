//
//  NSString+NSString_MD5HexDigest.h
//  dfgy
//
//  Created by 陈 利群 on 13-5-28.
//  Copyright (c) 2013年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"

@interface NSString (NSString_MD5HexDigest)

-(NSString *) md5HexDigest;

@end
