//
//  giftCell.h
//  yunbaolive
//
//  Created by Boom on 2018/10/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liwuModel.h"
#import <YYWebImage/YYWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface giftCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *giftIcon;
@property (weak, nonatomic) IBOutlet UILabel *giftNameL;
@property (weak, nonatomic) IBOutlet UILabel *giftCoinL;
@property (weak, nonatomic) IBOutlet UIImageView *giftTypeImg1;
@property (weak, nonatomic) IBOutlet UIImageView *giftTypeImg2;
@property (weak, nonatomic) IBOutlet UIImageView *giftTypeImg3;
@property(nonatomic,strong)liwuModel *model;

@end

NS_ASSUME_NONNULL_END
