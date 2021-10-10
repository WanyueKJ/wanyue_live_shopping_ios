//
//  commissionCell.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/4.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface commissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end

NS_ASSUME_NONNULL_END
