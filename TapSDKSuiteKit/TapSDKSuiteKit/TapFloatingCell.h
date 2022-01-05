//
//  TapFloatingCell.h
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import <UIKit/UIKit.h>
#import <TapSDKSuiteKit/TapSDKSuiteComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface TapFloatingCell : UIView
@property (nonatomic, strong) UIImageView *itemIcon;
@property (nonatomic, strong) UILabel *itemTitle;

- (void)setupWithComponent:(TapSDKSuiteComponent *)component;
@end

NS_ASSUME_NONNULL_END
