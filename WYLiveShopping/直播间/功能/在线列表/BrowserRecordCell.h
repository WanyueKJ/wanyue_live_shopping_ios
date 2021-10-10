//
//  BrowserRecordCell.h
//  live1v1
//
//  Created by apple on 2020/2/6.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class chatModel;
@protocol BrowserRecordCellDelegate <NSObject>

- (void)userToast:(chatModel *)model;

@end
@interface BrowserRecordCell : UITableViewCell
@property(nonatomic,weak)UIViewController *vc;
@property(nonatomic,strong)chatModel *model;

@property(nonatomic,weak)id<BrowserRecordCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
