//
//  submitGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/1.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface submitGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numsL;
@property (weak, nonatomic) IBOutlet UILabel *sukLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (nonatomic,strong) cartModel *model;

@end

NS_ASSUME_NONNULL_END
