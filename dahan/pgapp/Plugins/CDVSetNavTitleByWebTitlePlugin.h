//
//  CDVSetWebTitlePlugin.h
//  pgapp
//
//  Created by 陈 利群 on 14-4-22.
//
//

#import <Cordova/CDVPlugin.h>

@interface CDVSetNavTitleByWebTitlePlugin : CDVPlugin

-(void) setNavTitleByWebTitle:(CDVInvokedUrlCommand *)command;
@end
