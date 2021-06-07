#import "DartFfiiStaticLinkIssuePlugin.h"
#if __has_include(<dart_ffii_static_link_issue/dart_ffii_static_link_issue-Swift.h>)
#import <dart_ffii_static_link_issue/dart_ffii_static_link_issue-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dart_ffii_static_link_issue-Swift.h"
#endif

@implementation DartFfiiStaticLinkIssuePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDartFfiiStaticLinkIssuePlugin registerWithRegistrar:registrar];
}
@end
