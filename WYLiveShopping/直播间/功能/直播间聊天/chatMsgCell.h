//
//  chatMsgCell.h
//  yunbaolive
//
//  Created by Boom on 2018/10/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface chatMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
@property(nonatomic,strong)chatModel *model;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@end

NS_ASSUME_NONNULL_END
