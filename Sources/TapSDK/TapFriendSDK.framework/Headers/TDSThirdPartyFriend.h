//
//  TDSThirdPartyFriend.h
//  TapFriendSDK
//
//  Created by pzheng on 2021/11/15.
//

#import <Foundation/Foundation.h>

@class TDSUser;
@class TDSFriendInfo;
@class TDSThirdPartyFriend;

/// Cache policy for third party friend query.
typedef NS_ENUM(NSUInteger, TDSThirdPartyFriendCachePolicy) {
    /// Query from cache first, if not found, then query from server.
    TDSThirdPartyFriendCachePolicyCacheElseNetwork,
    /// Query from server.
    TDSThirdPartyFriendCachePolicyOnlyNetwork,
};

NS_ASSUME_NONNULL_BEGIN

/// Platform of third party friend.
typedef NSString * TDSThirdPartyFriendPlatform NS_STRING_ENUM;
/// Taptap.
FOUNDATION_EXPORT TDSThirdPartyFriendPlatform const TDSThirdPartyFriendPlatformTaptap;

/// Option for third party friend query.
@interface TDSThirdPartyFriendQueryOption : NSObject

/// Specifies which platform to query.
@property (nonatomic, nullable) TDSThirdPartyFriendPlatform platform;
/// Specifies the limit of the results for each query, default is `50`.
@property (nonatomic) NSUInteger pageSize;
/// Specifies the starting location of the query, if it is `nil`, means always query the latest data from server, default is `nil`.
@property (nonatomic, nullable) NSString *cursor;
/// Specifies cache policy, default is `TDSThirdPartyFriendCachePolicyCacheElseNetwork`.
@property (nonatomic) TDSThirdPartyFriendCachePolicy cachePolicy;

@end

/// Result of third party friend query.
@interface TDSThirdPartyFriendResult : NSObject

/// The list of the third party friend.
@property (nonatomic, nullable, readonly) NSArray<TDSThirdPartyFriend *> *friendList;
/// The location of the last object in `TDSThirdPartyFriendResult.friendList`.
@property (nonatomic, nullable, readonly) NSString *cursor;

@end

/// The object of third party friend.
@interface TDSThirdPartyFriend : NSObject

/// The ID of this friend.
@property (nonatomic, nullable) NSString *userId;
/// The name of this friend.
@property (nonatomic, nullable) NSString *userName;
/// The avatar of this friend.
@property (nonatomic, nullable) NSString *userAvatar;
/// If this friend has bound `TDSUser`, then this property is the relevant information, if not, this property is `nil`.
@property (nonatomic, nullable) TDSFriendInfo *tdsFriendInfo;

/// Query third party friend list.
/// @param option See `TDSThirdPartyFriendQueryOption`.
/// @param callback Result callback.
+ (void)queryThirdPartyFriendListWithOption:(TDSThirdPartyFriendQueryOption *)option
                                   callback:(void (^)(TDSThirdPartyFriendResult * _Nullable result, NSError * _Nullable error))callback;

/// Follow the Taptap User bound to this user.
/// @param user The TDS User which has bound Taptap User.
/// @param callback Result callback.
+ (void)followTapUser:(TDSUser *)user
             callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

@end

NS_ASSUME_NONNULL_END
