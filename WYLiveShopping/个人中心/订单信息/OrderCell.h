//
//  OrderCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"
#import "orderGoodsCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol OrderCellControlDelegate <NSObject>

- (void)doRemoveCurrentOrder:(orderModel *)model;
- (void)doPayOrder:(orderModel *)model;

@end
@interface OrderCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceL;
@property (weak, nonatomic) IBOutlet UILabel *tipsL;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *store_nameL;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;

@property (nonatomic,strong) orderModel *model;
@property (nonatomic,weak) id<OrderCellControlDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
