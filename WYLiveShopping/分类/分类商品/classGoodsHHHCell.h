//
//  classGoodsHHHCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGoodsHHHCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *salesL;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceL;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgV;
@property (nonatomic,strong) liveGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
