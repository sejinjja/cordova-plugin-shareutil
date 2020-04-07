#import "KSJShareutil.h"
#import <Cordova/CDV.h>

@implementation KSJShareutil

- (void) shareText:(CDVInvokedUrlCommand*)command{
    // Get the call back ID and echo argument
    NSString *text = [command.arguments objectAtIndex:0];

    if (text != nil && [text length] > 0) {
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

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };

        [self.getTopPresentedViewController presentViewController:activityViewController animated:YES completion:NULL];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

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

- (void)rememberRect:(CDVInvokedUrlCommand*)command{
    CGRect frameRect = self.webView.frame;
    CGRect boundsRect = self.webView.bounds;

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat: @"{frameSizeHeight : %f, frameSizeWidth : %f, frameOriginX : %f, frameOriginY : %f, boundSizeHeight : %f, boundSizeWidth : %f, boundOriginX : %f, boundOriginY : %f}", frameRect.size.height, frameRect.size.width, frameRect.origin.x, frameRect.origin.y, boundsRect.size.height boundsRect.size.width boundsRect.origin.x boundsRect.origin.y]]
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)resetRect:(CDVInvokedUrlCommand*)command{
  NSString *frameSizeHeight = [command.arguments objectAtIndex:0];
  float = frameSizeHeightFloat = [frameSizeHeight floatValue];
  NSString *frameSizeWidth = [command.arguments objectAtIndex:1];
  float = frameSizeWidthFloat = [frameSizeWidth floatValue];
  NSString *frameOriginX = [command.arguments objectAtIndex:2];
  float = frameOriginXFloat = [frameOriginX floatValue];
  NSString *frameOriginY = [command.arguments objectAtIndex:3];
  float = frameOriginYFloat = [frameOriginY floatValue];
  NSString *boundSizeHeight = [command.arguments objectAtIndex:4];
  float = boundSizeHeightFloat = [boundSizeHeight floatValue];
  NSString *boundSizeWidth = [command.arguments objectAtIndex:5];
  float = boundSizeWidthFloat = [boundSizeWidth floatValue];
  NSString *boundOriginX = [command.arguments objectAtIndex:6];
  float = boundOriginXFloat = [boundOriginX floatValue];
  NSString *boundOriginY = [command.arguments objectAtIndex:7];
  float = boundOriginYFloat = [boundOriginY floatValue];

  CGRect frameRect = self.webView.frame;
  frameRect.size.height = frameSizeHeightFloat;
  frameRect.size.width = frameSizeWidthFloat;
  frameRect.origin.x = frameOriginXFloat;
  frameRect.origin.y = frameOriginYFloat;
  self.webView.frame = frameRect;

  CGRect boundsRect = self.webView.bounds;
  boundsRect.size.height = boundsSizeHeightFloat;
  boundsRect.size.width = boundsSizeWidthFloat;
  boundsRect.origin.x = boundsOriginXFloat;
  boundsRect.origin.y = boundsOriginYFloat;
  self.webView.bounds = boundsRect;

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
