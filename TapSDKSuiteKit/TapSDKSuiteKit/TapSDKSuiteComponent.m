//
//  TapSDKSuiteComponent.m
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import "TapSDKSuiteComponent.h"
#import "TapSDKSuiteUtils.h"

NSString *const TapFloatCellClickedNotification = @"TapFloatCellClickedNotification";

@implementation TapSDKSuiteComponent
- (instancetype)initWithType:(TapSDKSuiteComponentType)type {
    return [self initWithType:type title:nil];
}

- (instancetype)initWithType:(TapSDKSuiteComponentType)type title:(NSString *_Nullable)title {
    return [self initWithType:type title:nil icon:nil];
}

- (instancetype)initWithType:(TapSDKSuiteComponentType)type title:(NSString *_Nullable)title icon:(UIImage *_Nullable)icon {
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        self.icon = icon;
    }
    return self;
}

- (NSString *)title {
    if (!_title) {
        switch (self.type) {
            case TapSDKSuiteComponentTypeMoment:
                _title = @"Moments";
                break;
            case TapSDKSuiteComponentTypeFirend:
                _title = @"Friends";
                break;
            case TapSDKSuiteComponentTypeAchievement:
                _title = @"Achievement";
                break;
            case TapSDKSuiteComponentTypeChat:
                _title = @"Chat";
                break;
            case TapSDKSuiteComponentTypeLeaderboard:
                _title = @"Leaderboard";
                break;

            default:
                _title = @"title";
                break;
        }
    }
    return _title;
}

- (UIImage *)icon {
    if (!_icon) {
        switch (self.type) {
            case TapSDKSuiteComponentTypeMoment:
                _icon = [TapSDKSuiteUtils getImageFromBundle:@"ic_moment"];
                break;
            case TapSDKSuiteComponentTypeFirend:
                _icon = [TapSDKSuiteUtils getImageFromBundle:@"ic_friend"];
                break;
            case TapSDKSuiteComponentTypeAchievement:
                _icon = [TapSDKSuiteUtils getImageFromBundle:@"ic_achievement"];
                break;
            case TapSDKSuiteComponentTypeChat:
                _icon = [TapSDKSuiteUtils getImageFromBundle:@"ic_chat"];
                break;
            case TapSDKSuiteComponentTypeLeaderboard:
                _icon = [TapSDKSuiteUtils getImageFromBundle:@"ic_leaderboard"];
                break;

            default:
                break;
        }
    }
    return _icon;
}

@end
