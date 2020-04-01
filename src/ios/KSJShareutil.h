#import <Cordova/CDV.h>

@interface KSJShareutil : CDVPlugin

- (void)shareText:(CDVInvokedUrlCommand*)command;
- (void)shareImg:(CDVInvokedUrlCommand*)command;

@end
