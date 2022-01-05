//
//  ViewController.m
//  Demo
//
//  Created by TapTap on 2022/1/4.
//

#import "ViewController.h"
#import "FriendViewController.h"
#import <TapSDKSuiteKit/TapSDKSuiteKit.h>
#import <TapBootstrapSDK/TapBootStrapSDK.h>
#import <TapMomentSDK/TapMomentSDK.h>
#import <TapAchievementSDK/TapAchievementSDK.h>

@interface ViewController ()<TapSDKSuiteDelegate, TapAchievementDelegate>
@property (nonatomic, strong) UITextField *countField;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"Demo";

    UIButton *loginButton = [UIButton new];
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    [loginButton setBackgroundColor:[UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];

    [[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100] setActive:YES];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.countField = [UITextField new];
    self.countField.backgroundColor = [UIColor whiteColor];
    self.countField.layer.borderWidth = 1;
    self.countField.layer.cornerRadius = 3;
    self.countField.textColor = [UIColor blackColor];
    self.countField.text = @"6";
    self.countField.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.countField];

    [[NSLayoutConstraint constraintWithItem:self.countField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.countField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.countField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.countField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:150] setActive:YES];
    self.countField.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *openButton = [UIButton new];
    openButton.layer.cornerRadius = 6;
    openButton.layer.masksToBounds = YES;
    [openButton setBackgroundColor:[UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1]];
    [openButton setTitle:@"打开浮窗" forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openFloatWindow) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:openButton];

    [[NSLayoutConstraint constraintWithItem:openButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:openButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:openButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:openButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200] setActive:YES];
    openButton.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *closeButton = [UIButton new];
    closeButton.layer.cornerRadius = 6;
    closeButton.layer.masksToBounds = YES;
    [closeButton setBackgroundColor:[UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1]];
    [closeButton setTitle:@"关闭浮窗" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeFloatWindow) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:closeButton];

    [[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:250] setActive:YES];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self initTapSDK];
}

- (void)initTapSDK
{
    TapConfig *config = [TapConfig new];
    config.clientId = @"xxxxx";
    config.clientToken = @"xxxxx";
    config.region = TapSDKRegionTypeCN;
    config.serverURL = @"xxxxx";
    config.dbConfig = [TapDBConfig new];
    config.dbConfig.enable = YES;
    config.dbConfig.advertiserIDCollectionEnabled = NO;
    config.dbConfig.channel = @"tap channel";
    config.dbConfig.gameVersion = @"001";
    [TapBootstrap initWithConfig:config];
    if ([TDSUser currentUser]) {
        [TapAchievement initData];
    }
}

- (void)login {
    [TDSUser loginByTapTapWithPermissions:@[@"public_profile"] callback:^(TDSUser *_Nullable user, NSError *_Nullable error) {
        if (error) {
            [self.view makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
        } else {
            [self.view makeToast:@"登录成功"];
            NSLog(@"session: %@   userid: %@",  user.sessionToken, user.objectId);
            [TapAchievement initData];
        }
    }];
}

- (void)openFloatWindow {
    [self.view endEditing:YES];
    // config with entrance data and delegate
    NSMutableArray<TapSDKSuiteComponent *> *array = [@[[[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeMoment],
                                                    [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeFirend],
                                                    [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeAchievement]] mutableCopy];

    NSInteger count =  [self.countField.text integerValue];
    if (count >= 4) {
        [array addObject:[[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeChat]];
    }
    if (count >= 5) {
        [array addObject:[[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeLeaderboard]];
    }
    if (count >= 6) {
        for (int i = 0; i < count - 5; i++) {
            [array addObject:[[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeLeaderboard]];
        }
    }

    [[TapSDKSuite shareInstance] setComponentArray:array];
    [TapSDKSuite shareInstance].delegate = self;

    [TapSDKSuite enable];
}

- (void)closeFloatWindow {
    [TapSDKSuite disable];
}

- (void)onItemClick:(TapSDKSuiteComponent *)component {
    switch (component.type) {
        case TapSDKSuiteComponentTypeMoment: {
            // open Moment
            TapMomentConfig *config = [[TapMomentConfig alloc] init];
            config.orientation = TapMomentOrientationDefault;
            [TapMoment open:config];
        }
        break;
        case TapSDKSuiteComponentTypeFirend: {
            // open Friend
            FriendViewController *vc = [FriendViewController new];
            [self presentViewController:vc animated:YES completion:nil];
        }
        break;
        case TapSDKSuiteComponentTypeAchievement: {
            // open Achievement
            [TapAchievement showAchievementPage];
        }
        break;
        case TapSDKSuiteComponentTypeChat: {
            // open Chat
            [self.view makeToast:@"点击了 chat"];
        }
        break;
        case TapSDKSuiteComponentTypeLeaderboard: {
            // open Leaderboard
            [self.view makeToast:@"点击了 Leaderboard"];
        }
        break;

        default:
            [self.view makeToast:@"点击了 ???"];
            break;
    }
}

- (void)onAchievementSDKInitFail:(nullable NSError *)error {
    [self.view makeToast:@"成就数据初始化失败"];
}

- (void)onAchievementSDKInitSuccess {
    [self.view makeToast:@"成就数据初始化成功"];
}

- (void)onAchievementStatusUpdate:(nullable TapAchievementModel *)achievement failure:(nullable NSError *)error {
}

@end
