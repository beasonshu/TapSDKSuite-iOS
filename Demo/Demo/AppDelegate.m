//
//  AppDelegate.m
//  Demo
//
//  Created by TapTap on 2022/1/4.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <TapBootstrapSDK/TapBootstrapSDK.h>
#import <TapFriendSDK/TapFriendSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [TapBootstrap handleOpenURL:url] || [TDSFriends handleFriendInvitationLink:url callback:nil];
}

@end
