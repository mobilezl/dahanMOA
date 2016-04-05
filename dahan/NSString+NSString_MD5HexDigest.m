//
//  NSString+NSString_MD5HexDigest.m
//  dfgy
//
//  Created by 陈 利群 on 13-5-28.
//  Copyright (c) 2013年 clq. All rights reserved.
//

#import "NSString+NSString_MD5HexDigest.h"

@implementation NSString (NSString_MD5HexDigest)

-(NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
