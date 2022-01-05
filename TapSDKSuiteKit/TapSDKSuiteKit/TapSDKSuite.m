//
//  TapSDKSuite.m
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import "TapSDKSuite.h"
#import "TapFloatingView.h"
#import "TapSDKSuiteUtils.h"

@interface TapSDKSuite ()
@property (nonatomic, strong) UIImageView *roundLogoView;
@property (nonatomic, strong) UIButton *cornorFloatButton;
@property (nonatomic, strong) TapFloatingView *floatingView;
@property (nonatomic, assign) BOOL opened;
@property (nonatomic, assign) BOOL animating;
@end

@implementation TapSDKSuite

+ (instancetype)shareInstance {
    static TapSDKSuite *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TapSDKSuite alloc] init];
        instance.opened = NO;
        instance.animating = NO;
    });
    return instance;
}

+ (void)enable {
    [[self shareInstance] enableFloatView];
}

+ (void)disable {
    [[self shareInstance] disableFloatView];
}

+ (BOOL)isShowing {
    return ((TapSDKSuite *)[self shareInstance]).opened;
}

#pragma mark- internal methods
- (void)enableFloatView {
    [self enableFloatViewWithAnimation:self.opened];
    self.opened = YES;
}

- (void)enableFloatViewWithAnimation:(BOOL)flag {
    if (self.animating) {
        return;
    }
    [self disableFloatView];
    if (!flag) {
        self.animating = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.roundLogoView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.cornorFloatButton];

        CGFloat leftEdgeInset = 0;
        // add 2px for y because the top padding in image is small than bottom padding
        CGPoint initialCenterPoint = CGPointMake(leftEdgeInset + 22 + ([TapSDKSuiteUtils isLandscape] ? 88 : 56), [self floatCenterY] + 2);
        CGPoint endCenterPoint = CGPointMake(leftEdgeInset, [self floatCenterY]);

        self.cornorFloatButton.alpha = 0;
        self.roundLogoView.alpha = 1;
        self.roundLogoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        self.roundLogoView.center = initialCenterPoint;

        [UIView animateWithDuration:0.3 animations:^{
            self.roundLogoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.roundLogoView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.roundLogoView.alpha = 0;
                    self.roundLogoView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                    self.roundLogoView.center = endCenterPoint;
                    self.cornorFloatButton.alpha = 1;
                } completion:^(BOOL finished) {
                    [self->_roundLogoView removeFromSuperview];
                    self->_roundLogoView = nil;
                    [self.cornorFloatButton addTarget:self action:@selector(showFloatWindow) forControlEvents:UIControlEventTouchUpInside];
                    [self.cornorFloatButton addTarget:self action:@selector(showFloatWindow) forControlEvents:UIControlEventTouchDragExit];
                    self.animating = NO;
                }];
            }];
        }];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.cornorFloatButton];
        [self.cornorFloatButton addTarget:self action:@selector(showFloatWindow) forControlEvents:UIControlEventTouchUpInside];
        [self.cornorFloatButton addTarget:self action:@selector(showFloatWindow) forControlEvents:UIControlEventTouchDragExit];
    }
}

- (void)disableFloatView {
    [_roundLogoView removeFromSuperview];
    [_cornorFloatButton removeFromSuperview];
    [_floatingView removeFromSuperview];

    _roundLogoView = nil;
    _cornorFloatButton = nil;
    _floatingView = nil;
}

- (void)showFloatWindow {
    [self.floatingView setupData];
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatingView];
    [self.floatingView showWithAnimation];
}

- (CGFloat)floatCenterY {
    return [UIScreen mainScreen].bounds.size.height - ([TapSDKSuiteUtils isLandscape] ? 58 : 146);
}

- (UIImageView *)roundLogoView {
    if (!_roundLogoView) {
        _roundLogoView = [UIImageView new];
        _roundLogoView.bounds = CGRectMake(0, 0, 44, 44);
        [_roundLogoView setImage:[TapSDKSuiteUtils getImageFromBundle:@"ic_logo_round"]];
    }
    return _roundLogoView;
}

- (UIButton *)cornorFloatButton {
    if (!_cornorFloatButton) {
        _cornorFloatButton = [UIButton new];
        _cornorFloatButton.backgroundColor = [UIColor clearColor];
        // add 12px on each side for better click experience
        _cornorFloatButton.frame = CGRectMake(-12, [self floatCenterY] - 18 - 12, 6 + 24, 36 + 24);
        _cornorFloatButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        [_cornorFloatButton setImage:[TapSDKSuiteUtils getImageFromBundle:@"ic_cornor_float"] forState:UIControlStateNormal];
    }
    return _cornorFloatButton;
}

- (TapFloatingView *)floatingView {
    if (!_floatingView) {
        _floatingView = [[TapFloatingView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _floatingView;
}

@end
