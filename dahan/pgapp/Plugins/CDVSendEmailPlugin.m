//
//  CDVSendEmailPlugin.m
//  pgapp
//
//  Created by 陈 利群 on 14-4-16.
//
//

#import "CDVSendEmailPlugin.h"


@implementation CDVSendEmailPlugin

-(void) sendEmail:(CDVInvokedUrlCommand *)command
{
    NSString* strSubject = [command.arguments objectAtIndex:0];
    NSString* strRec = [command.arguments objectAtIndex:1];
    NSArray* recArry = [NSArray arrayWithObjects:strRec, nil];
    NSString* emailMsg = [command.arguments objectAtIndex:2];
    
    NSString* body = @"您的设备不支持邮件发送功能,请检查!";
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc ] init];
            mailVC.mailComposeDelegate = self;
            [mailVC setSubject:strSubject];
            [mailVC setTitle:strSubject];
            [mailVC setToRecipients:recArry];
            [mailVC setMessageBody:emailMsg isHTML:FALSE];

            [self.viewController presentViewController:mailVC animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:body delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        
    }
}

#pragma MFMailComposeViewControllerDelegate method

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    NSString* strTip = @"提示";

    
    NSString* strDefinite = @"确定";

    
    NSString* msg = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送已取消！";
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved...");
            msg = @"邮件已经保存！";
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail sent...");
            msg = @"发送成功！";
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"邮件发送错误: %@...", [error localizedDescription]);
            msg = [NSString stringWithFormat:@"邮件发送错误: %@...", [error localizedDescription]];
            break;
        default:
            break;
    }
   
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:strTip message:msg delegate:nil cancelButtonTitle:strDefinite otherButtonTitles:nil];
    [alter show];
    [self.viewController dismissModalViewControllerAnimated:YES];
    
    
}


@end
