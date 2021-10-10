//
//  shareView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/10.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareView : UIView
- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)roomMessage;
- (void)show;
@end

NS_ASSUME_NONNULL_END
