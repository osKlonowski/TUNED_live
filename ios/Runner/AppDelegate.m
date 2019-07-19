#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [GMSServices provideAPIKey:@"AIzaSyApJ68oY88ZGlshMqtFdcyzl9-jSPDJURA"];
      [GeneratedPluginRegistrant registerWithRegistry:self];
      // Override point for customization after application launch.
      return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
