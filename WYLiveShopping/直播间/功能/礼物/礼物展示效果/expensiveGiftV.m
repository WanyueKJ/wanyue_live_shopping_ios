//
//  expensiveGiftV.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/9.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "expensiveGiftV.h"
#import "SDWebImageManager.h"
@implementation expensiveGiftV
-(instancetype)initWithIsPlat:(BOOL)isPlat{
    self = [super init];
    if (self) {
        _haohuaCount = 0;
        _expensiveGiftCount = [NSMutableArray array];
        _isplatBool = isPlat;
    }
    return self;
}
-(void)sethaohuacount{
    if (_haohuaCount == 0) {
        _haohuaCount =1;
    }
    else{
        _haohuaCount = 0;
    }
}
-(void)addArrayCount:(NSDictionary *)dic{
    [_expensiveGiftCount addObject:dic];
}
-(void)stopHaoHUaLiwu{
    [expensiveGiftTime invalidate];
    expensiveGiftTime = nil;
    _expensiveGiftCount = nil;
}
-(void)enGiftEspensive:(BOOL)isplat{
    if (_expensiveGiftCount.count == 0 || _expensiveGiftCount == nil) {//判断队列中有item且不是满屏
        [expensiveGiftTime invalidate];
        expensiveGiftTime = nil;
        return;
    }
    _isplatBool = isplat;

    NSDictionary *Dic = [_expensiveGiftCount firstObject];
    [_expensiveGiftCount removeObjectAtIndex:0];
    [self expensiveGiftPopView:Dic];
}
-(void)expensiveGiftPopView:(NSDictionary *)giftData{
    CGFloat seconds;
    if (_isplatBool) {
        seconds = 8.0;
    }else{
        seconds = [[giftData valueForKey:@"swftime"] floatValue];

    }
    [self sethaohuacount];

    if ([minstr([giftData valueForKey:@"swftype"]) isEqual:@"1"]) {
        SVGAParser *parser = [[SVGAParser alloc] init];
        [parser parseWithURL:[NSURL URLWithString:minstr([giftData valueForKey:@"swf"])] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            gifView = [[exoensiveGifGiftV alloc]initWithGiftData:giftData andVideoitem:videoItem andIsplat:_isplatBool];
            [self addSubview:gifView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [gifView removeFromSuperview];
                [self sethaohuacount];
                if (_expensiveGiftCount.count >0) {
                    [self.delegate expensiveGiftdelegate:nil];
                }
            });
        } failureBlock:nil];
    }else{
        gifView = [[exoensiveGifGiftV alloc]initWithGiftData:giftData andVideoitem:nil andIsplat:_isplatBool];
        [self addSubview:gifView];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [gifView removeFromSuperview];
            [self sethaohuacount];
            if (_expensiveGiftCount.count >0) {
                [self.delegate expensiveGiftdelegate:nil];
            }
        });
    }
            

}
@end
