//
//  userPopupView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol userPopupViewDeleagte <NSObject>

- (void)removeUserPopupView;
- (void)doShutupUser:(NSString *)userID andUserName:(NSString *)uname content:(NSString *)content;
- (void)doCancleShutupUser:(NSString *)userID andUserName:(NSString *)uname;
- (void)doKickUser:(NSString *)userID andUserName:(NSString *)uname;
- (void)setAdminUser:(NSString *)userID andUserName:(NSString *)uname;
- (void)cancelAdminUser:(NSString *)userID andUserName:(NSString *)uname;
@end
@interface userPopupView : UIView
-(instancetype)initWithFrame:(CGRect)frame andModel:(chatModel *)model liveUid:(NSString *)uid;
@property (nonatomic,weak) id<userPopupViewDeleagte> delegate;
@property(nonatomic,assign)BOOL isOnlineUser;//点击在线用户的头像有设置管理的功能

@end

NS_ASSUME_NONNULL_END
