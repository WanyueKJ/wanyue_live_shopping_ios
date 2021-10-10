//
//  YBCarView.h
//  YBEducation
//
//  Created by IOS1 on 2020/5/5.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYBadgeButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^carButtonClick)(int type);//0加入购物车 1立即购买 2收藏 3客服
@interface WYCarView : UIView
@property (nonatomic,strong) WYBadgeButton *carButton;
@property (nonatomic,strong) UIButton *collectButton;
@property (nonatomic,strong) UIButton *buyButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UILabel *numForCarL;
@property (nonatomic,copy) carButtonClick block;
@property (nonatomic,strong) NSString *goodsIndefiter;

@end

NS_ASSUME_NONNULL_END
