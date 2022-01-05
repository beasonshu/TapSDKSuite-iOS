//
//  TapFloatingView.m
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import "TapFloatingView.h"
#import "TapFloatingCell.h"
#import "TapSDKSuiteUtils.h"
#import "TapSDKSuite.h"

@interface TapFloatingView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *logoButton;
@property (nonatomic, strong) UIView *scrollContainer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bottomProgressView;
@property (nonatomic, strong) UIView *topProgressView;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *constraintArray;

@end

@implementation TapFloatingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *rootCloseGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithAnimation)];
    [self addGestureRecognizer:rootCloseGR];

    [self addSubview:self.logoButton];
    [self addSubview:self.scrollContainer];
    [self.scrollContainer addSubview:self.scrollView];
    [self.scrollContainer addSubview:self.bottomProgressView];
    [self.bottomProgressView addSubview:self.topProgressView];
    [self.scrollView addSubview:self.contentView];

    [self.logoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.bottomProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [[NSLayoutConstraint constraintWithItem:self.logoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:42] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.logoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:12] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.logoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.logoButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:36] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.scrollContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:250] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.scrollContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[TapSDKSuiteUtils isLandscape] ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width] setActive:YES];
    if ([TapSDKSuiteUtils isLandscape]) {
        [[NSLayoutConstraint constraintWithItem:self.scrollContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.scrollContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-95] setActive:YES];
    }
    [[NSLayoutConstraint constraintWithItem:self.scrollContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0] setActive:YES];

    [[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[TapSDKSuiteUtils screenShortLength]] setActive:YES];

    [[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:250] setActive:YES];

    [[NSLayoutConstraint constraintWithItem:self.bottomProgressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:80] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.bottomProgressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:80] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.bottomProgressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.bottomProgressView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:13] setActive:YES];
}

- (void)setupData {
    NSArray <TapSDKSuiteComponent *> *data = [TapSDKSuiteUtils currentConfig];
    NSInteger count = data.count;
    self.constraintArray = [NSMutableArray array];
    self.itemArray = [NSMutableArray array];

    if ([TapSDKSuiteUtils currentConfig].count < 6) {
        self.bottomProgressView.hidden = YES;
        [[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    } else {
        [[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0] setActive:YES];
    }

    CGFloat contentHeight = 64 * count;
    CGFloat topMargin = ([TapSDKSuiteUtils screenShortLength]  - 64 * 5) / 2;
    if (count >= 6) {
        contentHeight += (topMargin + 32);
    }
    [[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:contentHeight] setActive:YES];

    self.scrollView.contentSize = CGSizeMake(250, contentHeight);

    for (int i = 0; i < count; i++) {
        TapFloatingCell *cell = [TapFloatingCell new];
        [cell setupWithComponent:data[i]];
        [self.contentView addSubview:cell];
        [self.itemArray addObject:cell];
        [cell setTranslatesAutoresizingMaskIntoConstraints:NO];

        CGFloat topY = i * 64;
        CGFloat top = topY;

        if (count >= 6) {
            // 大于5个时起始位置和5个时相同
            topY += [TapSDKSuiteUtils screenShortLength] / 2 - 32 * (5 - 1);
            // 大于5个时不在居中对齐，需要调整上部边距
            top = topY - 32;
        }

        [[NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:top] setActive:YES];

        if (count < 6) {
            topY += [TapSDKSuiteUtils screenShortLength] / 2 - 32 * (count - 1);
        }

        CGFloat leftX = [self getXFromY:topY];

        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftX];
        [constraint setActive:YES];
        [self.constraintArray addObject:constraint];

        [[NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:64] setActive:YES];
    }
    CGFloat angle = (5.0f / count) * 36 / 40;

    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 40) radius:40 startAngle:-0.45 endAngle:angle - 0.45 clockwise:YES];
    [[UIColor whiteColor] set];
    circlePath.lineWidth = 10;
    [circlePath stroke];

    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.topProgressView.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.lineWidth = 2.f;
    bgLayer.strokeColor = [UIColor whiteColor].CGColor;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.lineCap = kCALineCapRound;
    bgLayer.path = circlePath.CGPath;

    [self.topProgressView.layer addSublayer:bgLayer];
}

- (CGFloat)getXFromY:(CGFloat)offsetY {
    // 实际y是坐标系平移半个屏幕
    CGFloat realY = offsetY - [TapSDKSuiteUtils screenShortLength] / 2;
    CGFloat realX = 84 * sqrt(fabs(1 - realY * realY / 48400));
    // 实际X是右移53px 且减去圆半径
    return realX + 53 - 20;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger count = [TapSDKSuiteUtils currentConfig].count;
    if (count < 6) {
        return;
    }
    CGFloat scrolly = scrollView.contentOffset.y;

    for (int i = 0; i < self.constraintArray.count; i++) {
        CGFloat y = 0;
        NSLayoutConstraint *constraint = self.constraintArray[i];
        y = i * 64 + [TapSDKSuiteUtils screenShortLength] / 2 - 32 * (5 - 1) - scrolly;
        constraint.constant = [self getXFromY:y];
    }

    CGFloat padding = ([TapSDKSuiteUtils screenShortLength]  - 64 * 5) / 2 + 32;

    CGFloat scrollPercent = scrolly / (padding + 64 * (count - 6));
    CGFloat rotation = scrollPercent * (36 - (5.0f / count) * 36) / 40;

    self.topProgressView.transform = CGAffineTransformMakeRotation(rotation);
}

- (void)showWithAnimation {
    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
    self.bottomProgressView.alpha = 0;
    self.logoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    self.logoButton.alpha = 1;
    for (TapFloatingCell *cell in self.itemArray) {
        cell.itemIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        cell.itemIcon.alpha = 1;
        cell.itemTitle.alpha = 0;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
        self.logoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        for (TapFloatingCell *cell in self.itemArray) {
            cell.itemIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
            cell.itemIcon.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWithAnimation) name:TapFloatCellClickedNotification object:nil];
        [UIView animateWithDuration:0.2 animations:^{
            self.logoButton.transform = CGAffineTransformIdentity;
            self.bottomProgressView.alpha = 1;
            for (TapFloatingCell *cell in self.itemArray) {
                cell.itemIcon.transform = CGAffineTransformIdentity;
                cell.itemTitle.alpha = 1;
            }
        } completion:nil];
    }];
}

- (void)dismissWithAnimation {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:1.2f
                        options:0
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         self.logoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                         self.logoButton.alpha = 0;
                         self.bottomProgressView.alpha = 0;
                         for (TapFloatingCell *cell in self.itemArray) {
                             cell.itemIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                             cell.itemIcon.alpha = 0;
                             cell.itemTitle.alpha = 0;
                         }
                     }
                     completion:^(BOOL finished) {
                         [[NSNotificationCenter defaultCenter] removeObserver:self name:TapFloatCellClickedNotification object:nil];
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                         [self removeFromSuperview];
                     }];
}

- (UIButton *)logoButton {
    if (!_logoButton) {
        _logoButton = [UIButton new];
        [_logoButton setImage:[TapSDKSuiteUtils getImageFromBundle:@"TapLogo"] forState:UIControlStateNormal];
        [_logoButton addTarget:self action:@selector(dismissWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoButton;
}

- (UIView *)scrollContainer {
    if (!_scrollContainer) {
        _scrollContainer = [UIView new];
    }
    return _scrollContainer;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView = [UIView new];

        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 40) radius:40 startAngle:-0.45 endAngle:0.45 clockwise:YES];
        [[UIColor whiteColor] set];
        circlePath.lineWidth = 10;
        [circlePath stroke];

        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.frame = _bottomProgressView.bounds;
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        bgLayer.lineWidth = 1.f;
        bgLayer.strokeColor = [UIColor colorWithWhite:1.0f alpha:0.25].CGColor;
        bgLayer.strokeStart = 0;
        bgLayer.strokeEnd = 1;
        bgLayer.lineCap = kCALineCapRound;
        bgLayer.path = circlePath.CGPath;

        [_bottomProgressView.layer addSublayer:bgLayer];
    }
    return _bottomProgressView;
}

- (UIView *)topProgressView {
    if (!_topProgressView) {
        _topProgressView = [UIView new];
        _topProgressView.frame = CGRectMake(0, 0, 80, 80);
    }
    return _topProgressView;
}

@end
