//
//  RecommendViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^recommendBlock)(NSArray *array,NSArray *liveclass);
@interface RecommendViewController : UIViewController
@property (nonatomic,copy) recommendBlock block;

@end

NS_ASSUME_NONNULL_END
