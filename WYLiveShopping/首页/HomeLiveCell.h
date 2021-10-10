//
//  HomeLiveCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/12.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeLiveCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumL;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (nonatomic,strong) HomeLiveModel *model;
@property (weak, nonatomic) IBOutlet UILabel *lookNumsL;
@property (weak, nonatomic) IBOutlet UILabel *likeNumsLabel;

@end

NS_ASSUME_NONNULL_END
