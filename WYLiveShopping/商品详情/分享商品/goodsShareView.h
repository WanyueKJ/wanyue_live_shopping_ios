//
//  goodsShareView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/4.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface goodsShareView : UIView
- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)shareMsg;
- (void)show;
@property (nonatomic,strong) NSString *liveUid;

@end

NS_ASSUME_NONNULL_END
