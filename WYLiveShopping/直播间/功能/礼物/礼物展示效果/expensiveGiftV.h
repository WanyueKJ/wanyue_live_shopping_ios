//
//  expensiveGiftV.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/9.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exoensiveGifGiftV.h"
#import <SVGAPlayer/SVGA.h>

@protocol haohuadelegate <NSObject>

-(void)expensiveGiftdelegate:(NSDictionary *)giftData;

@end

@interface expensiveGiftV : UIView
{
    NSTimer *expensiveGiftTime;//豪华礼物定时器
    exoensiveGifGiftV *gifView;
    SVGAPlayer *player;
}
@property(nonatomic,assign)id<haohuadelegate>delegate;
@property(nonatomic,strong)NSMutableArray *expensiveGiftCount;
@property(nonatomic,assign)int haohuaCount;
@property(nonatomic, assign)BOOL isplatBool;
-(void)sethaohuacount;
-(void)addArrayCount:(NSDictionary *)dic;
-(void)enGiftEspensive:(BOOL)isplat;
-(void)stopHaoHUaLiwu;

-(instancetype)initWithIsPlat:(BOOL)isPlat;
@end
