//
//  liveGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol liveGoodsCellDelegate <NSObject>

- (void)DismountGoods:(liveGoodsModel*)model;

@end
@interface liveGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *caozuoBtn;
@property (weak, nonatomic) IBOutlet UILabel *salesNumL;

@property (nonatomic,strong) liveGoodsModel *model;
@property (nonatomic,weak) id<liveGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
