#import "KSJShareutil.h"

#import <Cordova/CDV.h>



@implementation KSJShareutil



- (void) shareText:(CDVInvokedUrlCommand*)command{
    NSString *text = [command.arguments objectAtIndex:0];
    if (text != nil && [text length] > 0) {
        NSArray* dataToShare = @[text];
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *error){
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
    NSString *base64 = [command.arguments objectAtIndex:0];
    NSString *mimeType = [command.arguments objectAtIndex:1];

    if (base64 != nil && [base64 length] > 0) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage* img = [UIImage imageWithData:data];
        NSArray* dataToShare = @[img];

        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *error){
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



- (void)rememberRect:(CDVInvokedUrlCommand*)command{

    CGRect frameRect = self.webView.frame;

    CGRect boundsRect = self.webView.bounds;



    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat: @"{\"frameSizeHeight\" : %f, \"frameSizeWidth\" : %f, \"frameOriginX\" : %f, \"frameOriginY\" : %f, \"boundSizeHeight\" : %f, \"boundSizeWidth\" : %f, \"boundOriginX\" : %f, \"boundOriginY\" : %f}", frameRect.size.height, frameRect.size.width, frameRect.origin.x, frameRect.origin.y]];



    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}



- (void)resetRect:(CDVInvokedUrlCommand*)command{

  NSString *frameSizeHeight = [command.arguments objectAtIndex:0];

  float frameSizeHeightFloat = [frameSizeHeight floatValue];

  NSString *frameSizeWidth = [command.arguments objectAtIndex:1];

  float frameSizeWidthFloat = [frameSizeWidth floatValue];

  NSString *frameOriginX = [command.arguments objectAtIndex:2];

  float frameOriginXFloat = [frameOriginX floatValue];

  NSString *frameOriginY = [command.arguments objectAtIndex:3];

  float frameOriginYFloat = [frameOriginY floatValue];

  [UIView animateWithDuration:1.0 animations:^{
              self.webView.frame = CGRectMake(frameOriginXFloat, frameOriginYFloat, frameSizeWidthFloat, frameSizeHeightFloat);
          }];



  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}



-(UIViewController *)getTopPresentedViewController {
    UIViewController *presentingViewController = self.viewController;
    while(presentingViewController.presentedViewController != nil && ![presentingViewController.presentedViewController isBeingDismissed]) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    return presentingViewController;
}



@end
