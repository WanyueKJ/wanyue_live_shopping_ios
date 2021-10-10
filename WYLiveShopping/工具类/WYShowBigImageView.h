//
//  YBShowBigImageView.h
//  YBPlaying
//
//  Created by IOS1 on 2019/10/30.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYShowBigImageView : UIScrollView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSString *imageID;

- (void)setImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
