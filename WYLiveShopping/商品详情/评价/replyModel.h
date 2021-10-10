//
//  replyModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface replyModel : NSObject
@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSAttributedString *merchant_reply_content;
@property (nonatomic,strong) NSString *merchant_reply_time;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *star;
@property (nonatomic,strong) NSString *suk;
@property (nonatomic,strong) NSArray *pics;
@property (nonatomic,assign) CGFloat rowH;
@property (nonatomic,assign) CGFloat picsH;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
