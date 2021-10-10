//
//  WYSuspensionPlayer.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/24.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol WYSuspensionPlayerDelegate <NSObject>

//- (void)playEnd;
//- (void)enterRoomAgain;
//@end
@interface WYSuspensionPlayer : UIView
- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)msg;
- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END
