#import "KSJShareutil.h"
#import <Cordova/CDV.h>

@implementation KSJShareutil

- (void) shareText:(CDVInvokedUrlCommand*)command{
    CGRect frameRect = self.webView.frame;
    frameRect.size.height = 548.0f;
    frameRect.size.width = 320.0f;
    frameRect.origin.x = 0.0f;
    frameRect.origin.y = 0.0f;
    self.webView.frame = frameRect;
    NSLog(@"%@", NSStringFromCGRect(self.webView.bounds));
    NSLog(@"%@", NSStringFromCGRect(self.webView.frame));

    // Get the call back ID and echo argument
    NSString *text = [command.arguments objectAtIndex:0];

    CDVPluginResult* result = nil;
    if (text != nil && [text length] > 0) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        NSArray* dataToShare = @[text];

        UIActivityViewController* activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];

        UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
        if (popover) {
            popover.permittedArrowDirections = 0;
            popover.sourceView = self.webView.superview;
            popover.sourceRect = CGRectMake(CGRectGetMidX(self.webView.bounds), CGRectGetMidY(self.webView.bounds), 0, 0);
        }

        activityViewController.completionWithItemsHandler = ^(NSString *activityType,
                                          BOOL completed,
                                          NSArray *returnedItems,
                                          NSError *error){
            CDVPluginResult* pluginResult = NULL;
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            } else {
                NSMutableArray *packageNames = [[NSMutableArray alloc] init];
                if (completed) {
                    [packageNames addObject:activityType];
                }
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:packageNames];
            }

            [self.getTopPresentedViewController sendPluginResult:pluginResult callbackId:command.callbackId];
        };

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

-(UIViewController *)getTopPresentedViewController {
    UIViewController *presentingViewController = self.viewController;
    while(presentingViewController.presentedViewController != nil && ![presentingViewController.presentedViewController isBeingDismissed])
    {
        presentingViewController = presentingViewController.presentedViewController;
    }
    return presentingViewController;
}

@end
