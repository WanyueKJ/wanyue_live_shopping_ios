//
//  adminGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol adminGoodsCellDelegate <NSObject>

- (void)shangjiaGoods:(liveGoodsModel *)model;
- (void)xiajiaGoods:(liveGoodsModel *)model;
- (void)delateGoods:(liveGoodsModel *)model;

@end
@interface adminGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *salesL;
@property (weak, nonatomic) IBOutlet UILabel *profitL;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *delateBtn;
@property (nonatomic,strong) liveGoodsModel *model;
@property (nonatomic,weak) id<adminGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
