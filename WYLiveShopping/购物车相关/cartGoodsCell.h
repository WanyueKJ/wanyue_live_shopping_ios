//
//  cartGoodsCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cartModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol cartGoodsCellDelegate <NSObject>

- (void)changeSelectedState:(BOOL)isSelected;

@end
@interface cartGoodsCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *sukLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextT;
@property (nonatomic,strong) cartModel *model;
@property (nonatomic,weak) id<cartGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
