//
//  YBImageView.h
//  yunbaolive
//
//  Created by IOS1 on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YBImageViewBlock)(NSArray *array);
@interface WYImageView : UIView
- (instancetype)initWithImageArray:(NSArray *)array andIndex:(NSInteger)index andMine:(BOOL)ismine andBlock:(YBImageViewBlock)block;
@end

NS_ASSUME_NONNULL_END
