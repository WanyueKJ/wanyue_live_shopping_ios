//
//  profitHistoryCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface profitHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

@end

NS_ASSUME_NONNULL_END
