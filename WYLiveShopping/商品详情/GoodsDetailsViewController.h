//
//  GoodsDetailsViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailsViewController : UIViewController
@property (nonatomic,strong) NSString *goodsID;
@property (nonatomic,assign) BOOL isAdd;
@property (nonatomic,strong) NSString *liveUid;

@end

NS_ASSUME_NONNULL_END
