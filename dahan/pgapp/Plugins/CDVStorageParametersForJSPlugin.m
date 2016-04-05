//
//  CDVStorageParametersForJS.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-26.
//
//

#import "CDVStorageParametersForJSPlugin.h"
#import "AppDelegate.h"
#import "AppDefine.h"
@implementation CDVStorageParametersForJSPlugin

-(void) storageParametersForJS:(CDVInvokedUrlCommand *)command
{
    
    NSString* pKey = [command.arguments objectAtIndex:0];
    NSString* pVal = [command.arguments objectAtIndex:1];
    
    //AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //[ appDelegate.gParametersForJS setObject:pVal forKey:pKey];
    [gParametersForJS setObject:pVal forKey:pKey];
    NSLog(@"key: %@; val: %@", pKey, pVal);
}


@end
