//
//  exoensiveGifGiftV.m
//  yunbaolive
//
//  Created by Boom on 2018/10/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "exoensiveGifGiftV.h"
#import <YYWebImage/YYWebImage.h>

@implementation exoensiveGifGiftV{
}

-(instancetype)initWithGiftData:(NSDictionary *)giftData andVideoitem:(SVGAVideoEntity * _Nullable)videoitem andIsplat:(BOOL)isplat{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self creatUIWithGiftData:giftData andVideoitem:videoitem andIsPlat:isplat];
    }
    return self;
}
- (void)creatUIWithGiftData:(NSDictionary *)giftData andVideoitem:(SVGAVideoEntity * _Nullable)videoitem andIsPlat:(BOOL)ispalat{
    if (videoitem) {
        SVGAPlayer *player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, (_window_height-(_window_width/videoitem.videoSize.width*videoitem.videoSize.height))/2, _window_width, (_window_width/videoitem.videoSize.width*videoitem.videoSize.height))];
        [self addSubview:player];
        player.videoItem = videoitem;
        [player startAnimation];
    }else{
        UIImageView *imgView = [YYAnimatedImageView new];
        imgView.frame = CGRectMake(0, 0, _window_width, _window_height);
        imgView.yy_imageURL = [NSURL URLWithString:minstr([giftData valueForKey:@"swf"])];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
    }
    if (ispalat || [minstr([giftData valueForKey:@"_method_"]) isEqual:@"Sendplatgift"]) {
        CGFloat seconds = 8.0;//[[giftData valueForKey:@"swftime"] floatValue];

        NSString *titleStr = [NSString stringWithFormat:@"%@ 在%@的直播间送出 %@",minstr([giftData valueForKey:@"uname"]),minstr([giftData valueForKey:@"livename"]),minstr([giftData valueForKey:@"giftname"])];
        CGFloat titleWidth = [[WYToolClass sharedInstance] widthOfString:titleStr andFont:[UIFont systemFontOfSize:14] andHeight:30];
        UIImageView *titleBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width, 110, 35+titleWidth+20, 30)];
    //    titleBackImgView.image = [UIImage imageNamed:@"moviePlay_title"];
        titleBackImgView.image = [UIImage imageNamed:@"全站gift背景new"];
        titleBackImgView.alpha = 0.5;
        titleBackImgView.layer.cornerRadius = 15;
        titleBackImgView.layer.masksToBounds = YES;
        [self addSubview:titleBackImgView];
        UIImageView *laba = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
    //    laba.image = [UIImage imageNamed:@"豪华礼物提示.png"];
        laba.image = [UIImage imageNamed:@"全站喇叭"];
        [titleBackImgView addSubview:laba];
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(laba.right+10, 0, titleWidth+20, 30)];
        backview.clipsToBounds = YES;
        [titleBackImgView addSubview:backview];
        
        UILabel *titL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleWidth+20, 30)];
        titL.text = titleStr;
        titL.textColor = [UIColor whiteColor];
        titL.font = [UIFont systemFontOfSize:14];
        [backview addSubview:titL];
        
        UILabel *titl2 = [[UILabel alloc]initWithFrame:CGRectMake(titL.right, 0, titleWidth+20, 30)];
        titl2.text = titleStr;
        titl2.textColor = [UIColor whiteColor];
        titl2.font = [UIFont systemFontOfSize:14];
        [backview addSubview:titl2];
        
        UILabel *titl3 = [[UILabel alloc]initWithFrame:CGRectMake(titl2.right, 0, titleWidth+20, 30)];
        titl3.text = titleStr;
        titl3.textColor = [UIColor whiteColor];
        titl3.font = [UIFont systemFontOfSize:14];
        [backview addSubview:titl3];

        

        [UIView animateWithDuration:seconds/4 animations:^{
            titleBackImgView.alpha = 1;
            titleBackImgView.x = 10;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:2 animations:^{
                titL.frame = CGRectMake(-titleWidth-20, 0, titleWidth+20, 30);
                titl2.frame = CGRectMake(titL.right, 0, titleWidth+20, 30);
                titl3.frame = CGRectMake(titl2.right, 0, titleWidth+20, 30);

            }completion:^(BOOL finished) {
                [UIView animateWithDuration:2 animations:^{
                    titl2.frame = CGRectMake(-titleWidth-20, 0, titleWidth+20, 30);
                    titl3.frame = CGRectMake(titl2.right, 0, titleWidth, 30);

                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:2 animations:^{
                        [titleBackImgView.layer addAnimation:[self opacityForever_Animation:0.35] forKey:nil];

                    }];

                }];

            }];
        }];
    }else{
        if ([minstr([giftData valueForKey:@"isplatgift"])isEqual:@"1"]) {
            return;
        }
        CGFloat seconds = [[giftData valueForKey:@"swftime"] floatValue];

        NSString *titleStr = [NSString stringWithFormat:@"%@ 送了一个%@",minstr([giftData valueForKey:@"nicename"]),minstr([giftData valueForKey:@"giftname"])];
        CGFloat titleWidth = [[WYToolClass sharedInstance] widthOfString:titleStr andFont:[UIFont systemFontOfSize:14] andHeight:30];
        UIImageView *titleBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width, 110, 35+titleWidth+20, 30)];
        titleBackImgView.image = [UIImage imageNamed:@"moviePlay_title"];
        titleBackImgView.alpha = 0.5;
        titleBackImgView.layer.cornerRadius = 15;
        titleBackImgView.layer.masksToBounds = YES;
        [self addSubview:titleBackImgView];
        UIImageView *laba = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        laba.image = [UIImage imageNamed:@"豪华礼物提示"];
        [titleBackImgView addSubview:laba];
        UILabel *titL = [[UILabel alloc]initWithFrame:CGRectMake(laba.right+10, 0, titleWidth+20, 30)];
        titL.text = titleStr;
        titL.textColor = [UIColor whiteColor];
        titL.font = [UIFont systemFontOfSize:14];
        [titleBackImgView addSubview:titL];
        [UIView animateWithDuration:seconds/4 animations:^{
            titleBackImgView.alpha = 1;
            titleBackImgView.x = 10;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds*0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:seconds/4 animations:^{
                titleBackImgView.alpha = 0;
                titleBackImgView.x = -_window_width;
            } completion:^(BOOL finished) {
                [titleBackImgView removeFromSuperview];
            }];
            
        });

    }
}

#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 3;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark === 永久闪烁的动画 ======

-(CABasicAnimation *)opacityForever_Animation:(float)time

{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.5f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
@end
