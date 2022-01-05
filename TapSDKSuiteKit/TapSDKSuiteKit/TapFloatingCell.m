//
//  TapFloatingCell.m
//  TapSDKSuiteKit
//
//  Created by Bottle K on 2022/1/4.
//

#import "TapFloatingCell.h"
#import "TapSDKSuite.h"
#import "TapSDKSuiteUtils.h"

@interface TapFloatingCell ()
@property (nonatomic, strong) TapSDKSuiteComponent *component;
@end

@implementation TapFloatingCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.itemIcon];
    [self addSubview:self.itemTitle];
    [self.itemIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.itemTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[NSLayoutConstraint constraintWithItem:self.itemIcon attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.itemIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:2] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.itemIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:50] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.itemIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50] setActive:YES];

    [[NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemIcon attribute:NSLayoutAttributeRight multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0] setActive:YES];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:tap];
}

- (void)onClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:TapFloatCellClickedNotification object:nil];
    
    if ([TapSDKSuite shareInstance].delegate && [[TapSDKSuite shareInstance].delegate respondsToSelector:@selector(onItemClick:)]) {
        [[TapSDKSuite shareInstance].delegate onItemClick:self.component];
    }
}

- (void)setupWithComponent:(TapSDKSuiteComponent *)component {
    self.component = component;
    self.itemIcon.image = component.icon;
    self.itemTitle.text = component.title;
}

- (UIImageView *)itemIcon {
    if (!_itemIcon) {
        _itemIcon = [UIImageView new];
    }
    return _itemIcon;
}

- (UILabel *)itemTitle {
    if (!_itemTitle) {
        _itemTitle = [UILabel new];
        _itemTitle.textColor = [UIColor whiteColor];
        _itemTitle.font = [UIFont systemFontOfSize:10];
        _itemTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _itemTitle.numberOfLines = 1;
    }
    return _itemTitle;
}

@end
