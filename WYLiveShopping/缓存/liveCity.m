//
//  liveCity.m
//  yunbaolive
//
//  Created by 王敏欣 on 2016/12/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "liveCity.h"
@implementation liveCity
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
