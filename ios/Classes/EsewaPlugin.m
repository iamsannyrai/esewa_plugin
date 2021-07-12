#import "EsewaPlugin.h"
#if __has_include(<esewa_plugin/esewa_plugin-Swift.h>)
#import <esewa_plugin/esewa_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "esewa_plugin-Swift.h"
#endif

@implementation EsewaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEsewaPlugin registerWithRegistrar:registrar];
}
@end
