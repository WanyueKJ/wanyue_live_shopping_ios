//
//  OrderCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "OrderCell.h"
#import "SubmitOrderViewController.h"
@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)doBuyAndPayView:(NSString *)cartID{
    [WYToolClass postNetworkWithUrl:@"order/confirm" andParameter:@{@"cartId":cartID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            SubmitOrderViewController *vc = [[SubmitOrderViewController alloc]init];
            vc.orderMessage = [info mutableCopy];
            vc.liveUid = @"";
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } fail:^{
        
    }];

}

- (IBAction)rightButtonClick:(id)sender {
    if ([_model.paid isEqual:@"1"]) {
        if ([_model.status isEqual:@"2"]) {
            //待评价
        }
        if ([_model.status isEqual:@"3"]) {
            //已完成-删除订单
            [WYToolClass postNetworkWithUrl:@"order/del" andParameter:@{@"uni":_model.orderNums} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"删除成功"];
                if (code == 200) {
                    if (self.delegate) {
                        [self.delegate doRemoveCurrentOrder:_model];
                    }
                }
            } fail:^{
                
            }];

        }

    }else{
        if (self.delegate) {
            [self.delegate doPayOrder:_model];
        }
    }

}
- (IBAction)leftButtonClick:(id)sender {
    if ([_model.paid isEqual:@"1"]) {
        if ([_model.status isEqual:@"3"]) {
            //再次购买
            [MBProgressHUD showMessage:@""];
            [WYToolClass postNetworkWithUrl:@"order/again" andParameter:@{@"uni":_model.orderNums} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
                if (code == 200) {
                    [self doBuyAndPayView:minstr([info valueForKey:@"cateId"])];
                }else{
                    [MBProgressHUD hideHUD];
                }
            } fail:^{
                
            }];

        }

    }else{
        [WYToolClass postNetworkWithUrl:@"order/cancel" andParameter:@{@"id":_model.orderNums} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 200) {
                if (self.delegate) {
                    [self.delegate doRemoveCurrentOrder:_model];
                }
            }
        } fail:^{
            
        }];
    }
}
-(void)setModel:(orderModel *)model{
    _model = model;
    _store_nameL.text = _model.store_name;
    _statusLabel.text = _model.status_name;
    _allPriceL.text = [NSString stringWithFormat:@"¥ %@",_model.pay_price];
    _tipsL.text = [NSString stringWithFormat:@"共%@件商品，总金额",_model.total_num];
    [_goodsTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.goodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    orderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"orderGoodsCell" owner:nil options:nil] lastObject];
    }
    cell.model = _model.goodsArray[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
@end
