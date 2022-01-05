//
//  TDSFriends.h
//  TapFriendSDK
//
//  Created by pzheng on 2021/09/23.
//

#import <Foundation/Foundation.h>
#import <LeanCloudObjc/Foundation.h>
#import <TapBootstrapSDK/TapBootstrapSDK.h>

@class TDSFriendInfo;

NS_ASSUME_NONNULL_BEGIN

/// Notification Event.
@protocol TDSFriendsNotificationDelegate <NSObject>

@optional

/// New request is coming.
/// @param request The friendship request.
- (void)onNewRequestComing:(LCFriendshipRequest *)request;

/// The request sent from current user is accepted by other.
/// @param request The friendship request.
- (void)onRequestAccepted:(LCFriendshipRequest *)request;

/// The request sent from current user is declined by other.
/// @param request The friendship request.
- (void)onRequestDeclined:(LCFriendshipRequest *)request;

/// New friend.
/// @param friendInfo The info of the new friend.
- (void)onFriendAdded:(TDSFriendInfo *)friendInfo;

/// Friend is online.
/// @param userId The object id of the user.
- (void)onFriendOnline:(NSString *)userId;

/// Friend is offline.
/// @param userId The object id of the user.
- (void)onFriendOffline:(NSString *)userId;

/// The rich presence of the user has been changed.
/// @param userId The object id of the user.
/// @param dictionary The rich presence of the user.
- (void)onRichPresenceChanged:(NSString *)userId dictionary:(NSDictionary * _Nullable)dictionary;

/// The connection has been established.
- (void)onConnected;

/// The connection has been disconnected.
/// The common scenario in which this event occurs:
///     1. network unreachable or interface changed
///     2. app in background for a long time
/// When the app environment back to normal, the connection will resume automatically.
/// @param error The cause of disconnection.
- (void)onDisconnectedWithError:(NSError * _Nullable)error;

/// Connecting failed or the connection encountered error and will not try resume automatically.
/// @param error The error.
- (void)onConnectionError:(NSError *)error;

@end

/// Query Option.
@interface TDSFriendsQueryOption : NSObject

/// Start index of the results.
@property (nonatomic) NSInteger from;

/// Count of the results.
@property (nonatomic) NSInteger limit;

@end

/// Link Info
@interface TDSFriendsLinkInfo : NSObject

/// Nickname of user.
@property (nonatomic, nullable) NSString *nickname;

@end

/// Friends
@interface TDSFriends : NSObject

/// Current user online.
+ (void)online;

/// Current user offline.
+ (void)offline;

/// Register notification delegate.
/// @param delegate See `TDSFriendsNotificationDelegate`.
+ (void)registerNotificationDelegate:(id <TDSFriendsNotificationDelegate>)delegate;

/// Unregister notification delegate.
+ (void)unregisterNotificationDelegate;

/// Apply new friendship to someone.
/// @param userId The ID of the target user.
/// @param callback Result callback.
+ (void)addFriendWithUserId:(NSString *)userId
                   callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Apply new friendship to someone.
/// @param userId The ID of the target user.
/// @param attributes The additional attributes.
/// @param callback Result callback.
+ (void)addFriendWithUserId:(NSString *)userId
                 attributes:(NSDictionary * _Nullable)attributes
                   callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Apply new friendship to someone by short code.
/// @param shortCode The short code of the target user.
/// @param callback Result callback.
+ (void)addFriendWithShortCode:(NSString *)shortCode
                      callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Apply new friendship to someone by short code.
/// @param shortCode The short code of the target user.
/// @param attributes The additional attributes.
/// @param callback Result callback.
+ (void)addFriendWithShortCode:(NSString *)shortCode
                    attributes:(NSDictionary * _Nullable)attributes
                      callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Query friendship request.
/// @param status See `TDSUserFriendshipRequestStatus`.
/// @param option See `TDSFriendsQueryOption`.
/// @param callback Result callback.
+ (void)queryFriendRequestWithStatus:(TDSUserFriendshipRequestStatus)status
                              option:(TDSFriendsQueryOption * _Nullable)option
                            callback:(void (^)(NSArray<LCFriendshipRequest *> * _Nullable requests, NSError * _Nullable error))callback;

/// Accept a friendship.
/// @param request The friendship request.
/// @param callback Result callback.
+ (void)acceptFriendRequest:(LCFriendshipRequest *)request
                   callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Accept a friendship.
/// @param request The friendship request.
/// @param attributes The additional attributes.
/// @param callback Result callback.
+ (void)acceptFriendRequest:(LCFriendshipRequest *)request
                 attributes:(NSDictionary * _Nullable)attributes
                   callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Decline a friendship.
/// @param request The friendship request.
/// @param callback Result callback.
+ (void)declineFriendRequest:(LCFriendshipRequest *)request
                    callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Delete friendship request directly.
/// @param request The friendship request.
/// @param callback Result callback.
+ (void)deleteFriendRequest:(LCFriendshipRequest *)request
                   callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Delete friendship directly.
/// @param userId The ID of the target user.
/// @param callback Result callback.
+ (void)deleteFriendWithUserId:(NSString *)userId
                      callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Query friends.
/// @param option See `TDSFriendsQueryOption`.
/// @param callback Result callback.
+ (void)queryFriendWithOption:(TDSFriendsQueryOption * _Nullable)option
                     callback:(void (^)(NSArray<TDSFriendInfo *> * _Nullable friendInfos, NSError * _Nullable error))callback;

/// Check if the target user is the friend of the current user.
/// @param userId The ID of the target user.
/// @param callback Result callback. When `isFriend.boolValue` is `true`, means the target user is the friend of the current user.
+ (void)checkFriendshipWithUserId:(NSString *)userId
                         callback:(void (^)(NSNumber * _Nullable isFriend, NSError * _Nullable error))callback;

/// Search user by nickname.
/// @param nickname Nickname to be searched.
/// @param callback Result callback.
+ (void)searchUserWithNickname:(NSString *)nickname
                      callback:(void (^)(NSArray<TDSFriendInfo *> * _Nullable friendInfos, NSError * _Nullable error))callback;

/// Search user by nickname.
/// @param nickname Nickname to be searched.
/// @param option See `TDSFriendsQueryOption`.
/// @param callback Result callback.
+ (void)searchUserWithNickname:(NSString *)nickname
                        option:(TDSFriendsQueryOption * _Nullable)option
                      callback:(void (^)(NSArray<TDSFriendInfo *> * _Nullable friendInfos, NSError * _Nullable error))callback;

/// Search user by short code.
/// @param shortCode Short code to be searched.
/// @param callback Result callback.
+ (void)searchUserWithShortCode:(NSString *)shortCode
                       callback:(void (^)(TDSFriendInfo * _Nullable friendInfo, NSError * _Nullable error))callback;

/// Set rich presence of the current user with key-value pair.
/// @param key Key.
/// @param value Value.
/// @param callback Result callback.
+ (void)setRichPresenceWithKey:(NSString *)key
                         value:(NSString *)value
                      callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Set rich presence of the current user with key-value pairs.
/// @param dictionary Multiple key-value pairs.
/// @param callback Result callback.
+ (void)setRichPresencesWithDictionary:(NSDictionary *)dictionary
                              callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Clear rich presence of the current user with key.
/// @param key Key
/// @param callback Result callback.
+ (void)clearRichPresenceWithKey:(NSString *)key
                        callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Clear rich presence of the current user with keys.
/// @param keys The array of keys.
/// @param callback Result callback.
+ (void)clearRichPresencesWithKeys:(NSArray<NSString *> *)keys
                          callback:(void (^)(BOOL succeeded, NSError * _Nullable error))callback;

/// Set share link.
/// @param link Link.
+ (void)setShareLink:(NSString *)link;

/// Generate friendship invitation link of the current user.
/// @param error The cause of the fail.
+ (NSString * _Nullable)generateFriendInvitationLinkWithError:(NSError * __autoreleasing *)error;

/// Handle other's friendship invitation link, if link is invalid then will return `false`.
/// @param link Link.
/// @param callback Result callback.
+ (BOOL)handleFriendInvitationLink:(NSURL *)link
                          callback:(void (^ _Nullable)(BOOL succeeded, TDSFriendsLinkInfo * _Nullable linkInfo, NSError * _Nullable error))callback;

@end

NS_ASSUME_NONNULL_END
