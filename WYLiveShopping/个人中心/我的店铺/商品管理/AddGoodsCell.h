//
//  AddGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liveGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AddGoodsCellDelegate <NSObject>

- (void)addGoodsChange:(liveGoodsModel *)model;

@end
@interface AddGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiageLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (nonatomic,strong) liveGoodsModel *model;
@property (nonatomic,weak) id<AddGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
