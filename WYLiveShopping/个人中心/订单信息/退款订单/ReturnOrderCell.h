//
//  ReturnOrderCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReturnOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *sukL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *numsL;
@property (nonatomic,strong) cartModel *model;

@end

NS_ASSUME_NONNULL_END
