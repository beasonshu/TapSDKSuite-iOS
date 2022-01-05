//
//  TDSFriendInfo.h
//  TapFriendSDK
//
//  Created by pzheng on 2021/09/23.
//

#import <Foundation/Foundation.h>

@class TDSUser;

NS_ASSUME_NONNULL_BEGIN

/// Friend Info.
@interface TDSFriendInfo : NSObject

/// User.
@property (nonatomic, readonly) TDSUser *user;

/// The rich presence of the user.
@property (nonatomic, nullable) NSDictionary *richPresence;

/// The user whether online.
@property (nonatomic) BOOL online;

/// Init with user.
/// @param user The user.
- (instancetype)initWithUser:(TDSUser *)user;

@end

NS_ASSUME_NONNULL_END
