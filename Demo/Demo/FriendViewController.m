//
//  FriendViewController.m
//  Demo
//
//  Created by Bottle K on 2022/1/4.
//

#import "FriendViewController.h"
#import <TapFriendSDK/TapFriendSDK.h>
#import <TapCommonSDK/TapCommonSDK.h>

@interface FriendViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *offlineButton;
@property (nonatomic, strong) UIButton *addFriendButton;
@property (nonatomic, strong) UIButton *deleteFriendButton;
@property (nonatomic, strong) UIButton *friendListButton;
@property (nonatomic, strong) UIButton *followTapUserButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *getPendRequestButton;
@property (nonatomic, strong) UIButton *getDeclineRequestButton;
@property (nonatomic, strong) UIButton *setRichButton;
@property (nonatomic, strong) UIButton *clearRichButton;
@property (nonatomic, strong) UIButton *acceptRequestButton;
@property (nonatomic, strong) UIButton *declineRequestButton;
@property (nonatomic, strong) UIButton *deleteRequestButton;
@property (nonatomic, strong) UIButton *searchUserByCodeButton;
@property (nonatomic, strong) UIButton *addFriendByCodeButton;
@property (nonatomic, strong) UIButton *taptapFriendListButton;
@property (nonatomic, strong) UIButton *taptapFriendListFromServerButton;

@property (nonatomic, strong) UITextField *idField;
@property (nonatomic, strong) UITextField *friendIdField;
@property (nonatomic, strong) UITextField *keyField;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITextField *requestField;
@property (nonatomic, strong) UITextField *searchShortIdField;
@property (nonatomic, strong) UITextField *thirdPartyFriendCursorField;
@property (nonatomic, strong) NSArray<LCFriendshipRequest *> *requests;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                              self.view.frame.origin.y,
                                                                              self.view.frame.size.width,
                                                                              self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 2);
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];

    [scrollView addSubview:self.idField];
    [scrollView addSubview:self.friendIdField];
    [scrollView addSubview:self.keyField];
    [scrollView addSubview:self.valueField];
    [scrollView addSubview:self.searchField];
    [scrollView addSubview:self.requestField];
    [scrollView addSubview:self.searchShortIdField];
    [scrollView addSubview:self.thirdPartyFriendCursorField];

    [scrollView addSubview:self.onlineButton];
    [scrollView addSubview:self.offlineButton];
    [scrollView addSubview:self.backButton];
    [scrollView addSubview:self.addFriendButton];
    [scrollView addSubview:self.deleteFriendButton];
    [scrollView addSubview:self.friendListButton];
    [scrollView addSubview:self.followTapUserButton];
    [scrollView addSubview:self.shareButton];
    [scrollView addSubview:self.searchButton];
    [scrollView addSubview:self.getPendRequestButton];
    [scrollView addSubview:self.getDeclineRequestButton];
    [scrollView addSubview:self.setRichButton];
    [scrollView addSubview:self.clearRichButton];
    [scrollView addSubview:self.acceptRequestButton];
    [scrollView addSubview:self.declineRequestButton];
    [scrollView addSubview:self.deleteRequestButton];
    [scrollView addSubview:self.searchUserByCodeButton];
    [scrollView addSubview:self.addFriendByCodeButton];
    [scrollView addSubview:self.taptapFriendListButton];
    [scrollView addSubview:self.taptapFriendListFromServerButton];
}

// MARK: Action

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onlineAction {
    [TDSFriends online];
    NSLog(@"Friend online success");
}

- (void)offlineAction {
    [TDSFriends offline];
    NSLog(@"Friend offline");
}

- (void)addFriendAction {
    [TDSFriends addFriendWithUserId:self.friendIdField.text attributes:NULL callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend add friend error:%@", error);
        } else {
            NSLog(@"Friend success");
        }
    }];
}

- (void)delFriendAction {
    [TDSFriends deleteFriendWithUserId:self.friendIdField.text callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend delete error:%@", error);
        } else {
            NSLog(@"Friend delete friend success");
        }
    }];
}

- (void)friendListAction {
    TDSFriendsQueryOption *option = [TDSFriendsQueryOption new];
    option.from = 0;
    option.limit = 20;
    [TDSFriends queryFriendWithOption:option callback:^(NSArray<TDSFriendInfo *> *_Nullable friendInfos, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend query List error:%@", error);
        } else {
            NSString *info = @"";
            if (friendInfos.count > 0) {
                info = [friendInfos objectAtIndex:0].user.objectId;
            }
            NSLog(@"Friend query list success size = %lu  first userId = %@", (unsigned long)[friendInfos count], info);
        }
    }];
}

- (void)taptapFriendListAction {
    TDSThirdPartyFriendQueryOption *option = [TDSThirdPartyFriendQueryOption new];
    option.platform = TDSThirdPartyFriendPlatformTaptap;
    if (self.thirdPartyFriendCursorField.text.length > 0) {
        option.cursor = self.thirdPartyFriendCursorField.text;
    }
    [TDSThirdPartyFriend queryThirdPartyFriendListWithOption:option callback:^(TDSThirdPartyFriendResult *_Nullable result, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 查询Tap好友失败 error = %@", error);
        } else {
            NSMutableArray<NSString *> *strings = [NSMutableArray array];
            for (int i = 0; i < result.friendList.count; i++) {
                TDSThirdPartyFriend *friend = result.friendList[i];
                [strings addObject:[NSString stringWithFormat:@"(thirdPartyId = %@, TDSUserId = %@)", friend.userId, friend.tdsFriendInfo.user.objectId]];
            }
            NSLog(@"Friend 查询Tap好友(缓存)成功 ids = [%@] cursor = %@", [strings componentsJoinedByString:@","], result.cursor);
        }
    }];
}

- (void)taptapFriendListFromServerAction {
    TDSThirdPartyFriendQueryOption *option = [TDSThirdPartyFriendQueryOption new];
    option.platform = TDSThirdPartyFriendPlatformTaptap;
    option.cachePolicy = TDSThirdPartyFriendCachePolicyOnlyNetwork;
    if (self.thirdPartyFriendCursorField.text.length > 0) {
        option.cursor = self.thirdPartyFriendCursorField.text;
    }
    [TDSThirdPartyFriend queryThirdPartyFriendListWithOption:option callback:^(TDSThirdPartyFriendResult *_Nullable result, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 查询Tap好友失败 error = %@", error);
        } else {
            NSMutableArray<NSString *> *strings = [NSMutableArray array];
            for (int i = 0; i < result.friendList.count; i++) {
                TDSThirdPartyFriend *friend = result.friendList[i];
                [strings addObject:[NSString stringWithFormat:@"(thirdPartyId = %@, TDSUserId = %@)", friend.userId, friend.tdsFriendInfo.user.objectId]];
            }
            NSLog(@"Friend 查询Tap好友成功 ids = [%@] cursor = %@", [strings componentsJoinedByString:@","], result.cursor);
        }
    }];
}

- (void)followTapUserAction {
    TDSUser *user = [TDSUser objectWithObjectId:self.friendIdField.text];
    [TDSThirdPartyFriend followTapUser:user callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 关注Tap好友失败 error = %@", error);
        } else {
            NSLog(@"Friend 关注Tap好友成功");
        }
    }];
}

- (void)shareAction {
    [TDSFriends setShareLink:@"https://friend-share.cn-e1.leanapp.cn/"];
    NSLog(@" Friends link = %@", [TDSFriends generateFriendInvitationLinkWithError:NULL]);
}

- (void)searchAction {
    TDSFriendsQueryOption *option = [TDSFriendsQueryOption new];
    option.from = 0;
    option.limit = 20;
    [TDSFriends searchUserWithNickname:self.searchField.text option:option callback:^(NSArray<TDSFriendInfo *> *_Nullable friendInfos, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 搜索失败 error = %@", error.description);
        } else {
            NSString *info = @"";
            if (friendInfos.count > 0) {
                info = [friendInfos objectAtIndex:0].user.objectId;
            }
            NSLog(@"Friend 搜索成功 %lu 个 , first userId = %@", friendInfos.count, info);
        }
    }];
}

- (void)setRichAction {
    [TDSFriends setRichPresenceWithKey:self.keyField.text value:self.valueField.text callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 设置失败:%@", error);
        } else {
            NSLog(@"Friend 设置成功");
        }
    }];
}

- (void)clearRichAction {
    [TDSFriends clearRichPresenceWithKey:self.keyField.text callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 清除失败:%@", error);
        } else {
            NSLog(@"Friend 清除成功");
        }
    }];
}

- (void)getDeclineRequestAction {
    TDSFriendsQueryOption *option = [TDSFriendsQueryOption new];
    option.from = 0;
    option.limit = 20;
    [TDSFriends queryFriendRequestWithStatus:TDSUserFriendshipRequestStatusDeclined option:option callback:^(NSArray<LCFriendshipRequest *> *_Nullable requests, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 获取拒绝列表失败 error = %@", error);
        } else {
            self.requests = requests;
            NSLog(@"Friend 获取拒绝列表成功 requests = %@", requests);
        }
    }];
}

- (void)getPendRequestAction {
    TDSFriendsQueryOption *option = [TDSFriendsQueryOption new];
    option.from = 0;
    option.limit = 20;
    [TDSFriends queryFriendRequestWithStatus:TDSUserFriendshipRequestStatusPending option:option callback:^(NSArray<LCFriendshipRequest *> *_Nullable requests, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 获取未处理列表失败 error = %@", error);
        } else {
            self.requests = requests;
            NSLog(@"Friend 获取未处理列表成功 requests = %@", requests);
        }
    }];
}

- (void)acceptRequestAction {
    NSString *reqeustId = self.requestField.text;
    if (reqeustId.length == 0) {
        NSLog(@"Friend 请输入请求 ID");
        return;
    }
    for (LCFriendshipRequest *request in self.requests) {
        if ([request.objectId isEqualToString:reqeustId]) {
            [TDSFriends acceptFriendRequest:request callback:^(BOOL succeeded, NSError *_Nullable error) {
                if (error) {
                    NSLog(@"Friend 接受请求失败 error = %@", error);
                } else {
                    NSLog(@"Friend 接受请求成功");
                }
            }];
            return;
        }
    }
    NSLog(@"Friend 未发现请求");
}

- (void)declineRequestAction {
    NSString *reqeustId = self.requestField.text;
    if (reqeustId.length == 0) {
        NSLog(@"Friend 请输入请求 ID");
        return;
    }
    for (LCFriendshipRequest *request in self.requests) {
        if ([request.objectId isEqualToString:reqeustId]) {
            [TDSFriends declineFriendRequest:request callback:^(BOOL succeeded, NSError *_Nullable error) {
                if (error) {
                    NSLog(@"Friend 拒绝请求失败 error = %@", error);
                } else {
                    NSLog(@"Friend 拒绝请求成功");
                }
            }];
            return;
        }
    }
    NSLog(@"Friend 未发现请求");
}

- (void)deleteRequestAction {
    NSString *reqeustId = self.requestField.text;
    if (reqeustId.length == 0) {
        NSLog(@"Friend 请输入请求 ID");
        return;
    }
    for (LCFriendshipRequest *request in self.requests) {
        if ([request.objectId isEqualToString:reqeustId]) {
            [TDSFriends deleteFriendRequest:request callback:^(BOOL succeeded, NSError *_Nullable error) {
                if (error) {
                    NSLog(@"Friend 删除请求失败 error = %@", error);
                } else {
                    NSLog(@"Friend 删除请求成功");
                }
            }];
            return;
        }
    }
    NSLog(@"Friend 未发现请求");
}

- (void)searchUserByCodeAction {
    [TDSFriends searchUserWithShortCode:self.searchShortIdField.text callback:^(TDSFriendInfo *_Nullable friendInfo, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 好友码搜索失败 error = %@", error);
        } else {
            NSLog(@"Friend 好友码搜索成功 userId = %@", friendInfo.user.objectId);
        }
    }];
}

- (void)addFriendByCodeAction {
    [TDSFriends addFriendWithShortCode:self.searchShortIdField.text callback:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Friend 好友码申请好友失败 error = %@", error);
        } else {
            NSLog(@"Friend 好友码申请好友成功");
        }
    }];
}

// MARK: TextField

- (UITextField *)idField {
    if (!_idField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.text = [[TDSUser currentUser] objectId];
        textField.textColor = [UIColor blackColor];
        _idField = textField;
    }
    return _idField;
}

- (UITextField *)friendIdField {
    if (!_friendIdField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, 300, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"输入好友 ID" attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                    NSFontAttributeName: textField.font,
        }];
        textField.attributedPlaceholder = attributedString;
        textField.textColor = [UIColor blackColor];
        _friendIdField = textField;
    }
    return _friendIdField;
}

- (UITextField *)keyField {
    if (!_keyField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, 100, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.text = @"display";
        textField.textColor = [UIColor blackColor];
        _keyField = textField;
    }
    return _keyField;
}

- (UITextField *)valueField {
    if (!_valueField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 300, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.text = @"#playing";
        textField.textColor = [UIColor blackColor];
        _valueField = textField;
    }
    return _valueField;
}

- (UITextField *)searchField {
    if (!_searchField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 400, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"输入昵称" attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                    NSFontAttributeName: textField.font,
        }];
        textField.attributedPlaceholder = attributedString;
        textField.textColor = [UIColor blackColor];
        _searchField = textField;
    }
    return _searchField;
}

- (UITextField *)requestField {
    if (!_requestField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 550, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"输入好友请求 ID" attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                    NSFontAttributeName: textField.font,
        }];
        textField.attributedPlaceholder = attributedString;
        textField.textColor = [UIColor blackColor];
        _requestField = textField;
    }
    return _requestField;
}

- (UITextField *)searchShortIdField {
    if (!_searchShortIdField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 650, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"输入好友码" attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                    NSFontAttributeName: textField.font,
        }];
        textField.attributedPlaceholder = attributedString;
        textField.textColor = [UIColor blackColor];
        _searchShortIdField = textField;
    }
    return _searchShortIdField;
}

- (UITextField *)thirdPartyFriendCursorField {
    if (!_thirdPartyFriendCursorField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 750, 250, 30)];
        textField.layer.borderColor = [UIColor.grayColor CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"输入第三方好友查询游标" attributes:@{
                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                    NSFontAttributeName: textField.font,
        }];
        textField.attributedPlaceholder = attributedString;
        textField.textColor = [UIColor blackColor];
        _thirdPartyFriendCursorField = textField;
    }
    return _thirdPartyFriendCursorField;
}

// MARK: Button

- (UIButton *)onlineButton {
    if (!_onlineButton) {
        _onlineButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 150, 40)];
        _onlineButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_onlineButton setTitle:@"上线" forState:UIControlStateNormal];
        [_onlineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_onlineButton addTarget:self action:@selector(onlineAction) forControlEvents:UIControlEventTouchUpInside];
        _onlineButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _onlineButton.layer.cornerRadius = 6;
        _onlineButton.layer.masksToBounds = YES;
    }
    return _onlineButton;
}

- (UIButton *)offlineButton {
    if (!_offlineButton) {
        _offlineButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 50, 150, 40)];
        _offlineButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_offlineButton setTitle:@"下线" forState:UIControlStateNormal];
        [_offlineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_offlineButton addTarget:self action:@selector(offlineAction) forControlEvents:UIControlEventTouchUpInside];
        _offlineButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _offlineButton.layer.cornerRadius = 6;
        _offlineButton.layer.masksToBounds = YES;
    }
    return _offlineButton;
}

- (UIButton *)addFriendButton {
    if (!_addFriendButton) {
        _addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 150, 40)];
        _addFriendButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_addFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
        [_addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addFriendButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
        _addFriendButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _addFriendButton.layer.cornerRadius = 6;
        _addFriendButton.layer.masksToBounds = YES;
    }
    return _addFriendButton;
}

- (UIButton *)deleteFriendButton {
    if (!_deleteFriendButton) {
        _deleteFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 150, 150, 40)];
        _deleteFriendButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_deleteFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
        [_deleteFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteFriendButton addTarget:self action:@selector(delFriendAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteFriendButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _deleteFriendButton.layer.cornerRadius = 6;
        _deleteFriendButton.layer.masksToBounds = YES;
    }
    return _deleteFriendButton;
}

- (UIButton *)friendListButton {
    if (!_friendListButton) {
        _friendListButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 150, 40)];
        _friendListButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_friendListButton setTitle:@"好友列表" forState:UIControlStateNormal];
        [_friendListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_friendListButton addTarget:self action:@selector(friendListAction) forControlEvents:UIControlEventTouchUpInside];
        _friendListButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _friendListButton.layer.cornerRadius = 6;
        _friendListButton.layer.masksToBounds = YES;
    }
    return _friendListButton;
}

- (UIButton *)followTapUserButton {
    if (!_followTapUserButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 150, 40)];
        button.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [button setTitle:@"关注Tap好友" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(followTapUserAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _followTapUserButton = button;
    }
    return _followTapUserButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 150, 40)];
        _shareButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_shareButton setTitle:@"分享链接" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _shareButton.layer.cornerRadius = 6;
        _shareButton.layer.masksToBounds = YES;
    }
    return _shareButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 450, 150, 40)];
        _searchButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _searchButton.layer.cornerRadius = 6;
        _searchButton.layer.masksToBounds = YES;
    }
    return _searchButton;
}

- (UIButton *)getDeclineRequestButton {
    if (!_getDeclineRequestButton) {
        _getDeclineRequestButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 170, 40)];
        _getDeclineRequestButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_getDeclineRequestButton setTitle:@"获取拒绝列表" forState:UIControlStateNormal];
        [_getDeclineRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getDeclineRequestButton addTarget:self action:@selector(getDeclineRequestAction) forControlEvents:UIControlEventTouchUpInside];
        _getDeclineRequestButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _getDeclineRequestButton.layer.cornerRadius = 6;
        _getDeclineRequestButton.layer.masksToBounds = YES;
    }
    return _getDeclineRequestButton;
}

- (UIButton *)getPendRequestButton {
    if (!_getPendRequestButton) {
        _getPendRequestButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 150, 40)];
        _getPendRequestButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_getPendRequestButton setTitle:@"获取申请列表" forState:UIControlStateNormal];
        [_getPendRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getPendRequestButton addTarget:self action:@selector(getPendRequestAction) forControlEvents:UIControlEventTouchUpInside];
        _getPendRequestButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _getPendRequestButton.layer.cornerRadius = 6;
        _getPendRequestButton.layer.masksToBounds = YES;
    }
    return _getPendRequestButton;
}

- (UIButton *)setRichButton {
    if (!_setRichButton) {
        _setRichButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, 150, 40)];
        _setRichButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_setRichButton setTitle:@"设置富信息" forState:UIControlStateNormal];
        [_setRichButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setRichButton addTarget:self action:@selector(setRichAction) forControlEvents:UIControlEventTouchUpInside];
        _setRichButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _setRichButton.layer.cornerRadius = 6;
        _setRichButton.layer.masksToBounds = YES;
    }
    return _setRichButton;
}

- (UIButton *)clearRichButton {
    if (!_clearRichButton) {
        _clearRichButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 350, 150, 40)];
        _clearRichButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_clearRichButton setTitle:@"清除富信息" forState:UIControlStateNormal];
        [_clearRichButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearRichButton addTarget:self action:@selector(clearRichAction) forControlEvents:UIControlEventTouchUpInside];
        _clearRichButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _clearRichButton.layer.cornerRadius = 6;
        _clearRichButton.layer.masksToBounds = YES;
    }
    return _clearRichButton;
}

- (UIButton *)acceptRequestButton {
    if (!_acceptRequestButton) {
        _acceptRequestButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 600, 100, 40)];
        _acceptRequestButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_acceptRequestButton setTitle:@"接受请求" forState:UIControlStateNormal];
        [_acceptRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_acceptRequestButton addTarget:self action:@selector(acceptRequestAction) forControlEvents:UIControlEventTouchUpInside];
        _acceptRequestButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _acceptRequestButton.layer.cornerRadius = 6;
        _acceptRequestButton.layer.masksToBounds = YES;
    }
    return _acceptRequestButton;
}

- (UIButton *)declineRequestButton {
    if (!_declineRequestButton) {
        _declineRequestButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 600, 100, 40)];
        _declineRequestButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_declineRequestButton setTitle:@"拒绝请求" forState:UIControlStateNormal];
        [_declineRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_declineRequestButton addTarget:self action:@selector(declineRequestAction) forControlEvents:UIControlEventTouchUpInside];
        _declineRequestButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _declineRequestButton.layer.cornerRadius = 6;
        _declineRequestButton.layer.masksToBounds = YES;
    }
    return _declineRequestButton;
}

- (UIButton *)deleteRequestButton {
    if (!_deleteRequestButton) {
        _deleteRequestButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 600, 100, 40)];
        _deleteRequestButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_deleteRequestButton setTitle:@"删除请求" forState:UIControlStateNormal];
        [_deleteRequestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteRequestButton addTarget:self action:@selector(deleteRequestAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteRequestButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _deleteRequestButton.layer.cornerRadius = 6;
        _deleteRequestButton.layer.masksToBounds = YES;
    }
    return _deleteRequestButton;
}

- (UIButton *)searchUserByCodeButton {
    if (!_searchUserByCodeButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 700, 100, 40)];
        button.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [button setTitle:@"搜索好友" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchUserByCodeAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _searchUserByCodeButton = button;
    }
    return _searchUserByCodeButton;
}

- (UIButton *)addFriendByCodeButton {
    if (!_addFriendByCodeButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 700, 100, 40)];
        button.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [button setTitle:@"申请好友" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addFriendByCodeAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _addFriendByCodeButton = button;
    }
    return _addFriendByCodeButton;
}

- (UIButton *)taptapFriendListButton {
    if (!_taptapFriendListButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 800, 150, 40)];
        button.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [button setTitle:@"查询Tap好友(缓存)" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = true;
        [button addTarget:self action:@selector(taptapFriendListAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _taptapFriendListButton = button;
    }
    return _taptapFriendListButton;
}

- (UIButton *)taptapFriendListFromServerButton {
    if (!_taptapFriendListFromServerButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 800, 150, 40)];
        button.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [button setTitle:@"查询Tap好友" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = true;
        [button addTarget:self action:@selector(taptapFriendListFromServerAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _taptapFriendListFromServerButton = button;
    }
    return _taptapFriendListFromServerButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 15, 50, 40)];
        _backButton.backgroundColor = [UIColor colorWithRed:(85) / 255.0f green:(182) / 255.0f blue:(197) / 255.0f alpha:1];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _backButton.layer.cornerRadius = 6;
        _backButton.layer.masksToBounds = YES;
    }
    return _backButton;
}

@end
