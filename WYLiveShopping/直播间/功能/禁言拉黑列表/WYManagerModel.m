//
//  WYManagerModel.m
//  iphoneLive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "WYManagerModel.h"
@implementation WYManagerModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.time = [NSString stringWithFormat:@"%@",[dic valueForKey:@"end_time"]];
        self.name = minstr(dic[@"nickname"]);
        self.stream = minstr(dic[@"stream"]);
       
        self.icon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        self.uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        self.isattention = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isattention"]];
        
       
        
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return  [[self alloc]initWithDic:dic];
}
@end
