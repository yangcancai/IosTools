//
//  AppDelegate.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 设置启动动画视图控制器
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    self.window.rootViewController = launchVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}
@end
