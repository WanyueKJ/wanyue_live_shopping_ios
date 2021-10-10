//
//  HomeLiveModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeLiveModel : NSObject
@property (nonatomic,strong) NSString *uid;
///标题
@property (nonatomic,strong) NSString *titleStr;
///封面
@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *classid;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *stream;
@property (nonatomic,strong) NSString *showid;
///商品数
@property (nonatomic,strong) NSString *goodsnum;
///点赞数
@property (nonatomic,strong) NSString *likes;
///人数
@property (nonatomic,strong) NSString *nums;
///播流地址
@property (nonatomic,strong) NSString *pull;
///主播昵称
@property (nonatomic,strong) NSString *nickname;
///主播头像
@property (nonatomic,strong) NSString *avatar;
///商品图
@property (nonatomic,strong) NSString *goods_img;

@property (nonatomic,strong) NSDictionary *originDic;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
