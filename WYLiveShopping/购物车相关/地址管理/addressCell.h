//
//  addressCell.h
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol addressCellDeleagte <NSObject>

- (void)delateAddress:(addressModel *)model;
- (void)editAddress:(addressModel *)model;
- (void)setDefault:(addressModel *)model;
@end
@interface addressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *detaliesL;
@property (weak, nonatomic) IBOutlet UIButton *delateBnt;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (nonatomic,weak) id<addressCellDeleagte> delegate;
@property (nonatomic,strong) addressModel *model;

@end

NS_ASSUME_NONNULL_END
