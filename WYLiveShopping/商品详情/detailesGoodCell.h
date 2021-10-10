//
//  detailesGoodCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/28.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface detailesGoodCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (nonatomic,strong) liveGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
