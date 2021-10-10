//
//  WYGiftListView.h
//  WYLiveShopping
//
//  Created by apple on 2020/8/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WYGiftListViewDelegate<NSObject>
-(void)sendGift:(NSMutableArray *_Nullable)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa;
-(void)pushCoinV;
@end
NS_ASSUME_NONNULL_BEGIN

@interface WYGiftListView : UIView
- (instancetype)initWithFrame:(CGRect)frame andZhuboMsg:(NSDictionary *)dic;
@property(nonatomic,weak)id<WYGiftListViewDelegate>delegate;
//重置礼物列表下方的钻石数量
-(void)chongzhiV:(NSString *)coins;
@end

NS_ASSUME_NONNULL_END
