#import "KSJShareutil.h"
#import <Cordova/CDV.h>

@implementation KSJShareutil

- (void) shareText:(CDVInvokedUrlCommand*)command{

    // Get the call back ID and echo argument
    NSString *text = [command.arguments objectAtIndex:0];

    CDVPluginResult* result = nil;
    if (text != nil && [text length] > 0) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        NSArray* dataToShare = @[text];

        UIActivityViewController* activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];

        [self.viewController presentViewController:activityViewController animated:YES completion:^{}];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

}

- (void) shareImg:(CDVInvokedUrlCommand*)command{

    // Get the call back ID and echo argument
    NSString *base64 = [command.arguments objectAtIndex:0];
    NSString *mimeType = [command.arguments objectAtIndex:1];
    CDVPluginResult* result = nil;
    if (base64 != nil && [base64 length] > 0) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage* img = [UIImage imageWithData:data];
        NSArray* dataToShare = @[img];

        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];

        [self.viewController presentViewController:activityViewController animated:YES completion:^{}];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];

}

@end
