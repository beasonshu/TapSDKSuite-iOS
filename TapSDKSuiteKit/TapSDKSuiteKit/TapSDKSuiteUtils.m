//
//  TapSDKSuiteUtils.m
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import "TapSDKSuiteUtils.h"
#import "TapSDKSuite.h"

@implementation TapSDKSuiteUtils

+ (NSArray <TapSDKSuiteComponent *> *)currentConfig {
    return [TapSDKSuite shareInstance].componentArray;
}

+ (UIImage *)getImageFromBundle:(NSString *)imageName {
    NSBundle *bundle = [self getBundleWithName:@"TapSDKSuiteResource" aClass:[self class]];
    NSString *img_path = [bundle.bundlePath stringByAppendingFormat:@"/images/%@", imageName];
    if (img_path && img_path.length > 0) {
        return [UIImage imageWithContentsOfFile:img_path];
    }
    return nil;
}

+ (NSBundle *)getBundleWithName:(NSString *)bundleName aClass:(Class)aClass {
    NSBundle *localizableBundle;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (bundlePath && bundlePath.length > 0) {
        NSBundle *mainBundle = [NSBundle bundleForClass:aClass];
        bundlePath = [mainBundle pathForResource:bundleName ofType:@"bundle"];
    }
    localizableBundle = [NSBundle bundleWithPath:bundlePath];
    return localizableBundle;
}

+ (UIEdgeInsets)safeAreaInset:(UIView *)view {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

+ (UIEdgeInsets)safeAreaInsetOfKeyWindow {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

+ (BOOL)isLandscape {
    if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return NO;
    }
    return YES;
}

+ (CGFloat)screenShortLength {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)screenLongLength {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
