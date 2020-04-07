#import <Cordova/CDV.h>

@interface KSJShareutil : CDVPlugin

- (void)shareText:(CDVInvokedUrlCommand*)command;
- (void)shareImg:(CDVInvokedUrlCommand*)command;
- (void)rememberRect:(CDVInvokedUrlCommand*)command;
- (void)resetRect:(CDVInvokedUrlCommand*)command;

@end
