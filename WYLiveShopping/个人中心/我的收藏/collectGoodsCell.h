//
//  collectGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol collectGoodsCellDelegate <NSObject>

- (void)removeCollected:(collectGoodsModel *)model;

@end
@interface collectGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (nonatomic,strong) collectGoodsModel *model;
@property (nonatomic,weak) id<collectGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
