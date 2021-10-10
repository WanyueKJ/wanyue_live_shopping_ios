//
//  AdminGoodsViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminGoodsViewController : UIViewController
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *keywordStr;

- (void)doSearchGoods;

@end

NS_ASSUME_NONNULL_END
