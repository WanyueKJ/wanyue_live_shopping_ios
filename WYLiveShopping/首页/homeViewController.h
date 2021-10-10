//
//  homeViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/10.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface HoverPageScrollView : UIScrollView<UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSArray *scrollViewWhites;
@end

@interface homeViewController : HeaderBaseViewController

@end

NS_ASSUME_NONNULL_END
