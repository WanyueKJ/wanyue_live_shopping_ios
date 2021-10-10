//
//  YBBaseViewController.h
//  yunbaolive
//
//  Created by IOS1 on 2019/3/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYBaseViewController : UIViewController
@property (nonatomic,strong) UIImageView *nothingImgV;
@property (nonatomic,strong) UILabel *nothingTitleL;
@property (nonatomic,strong) UILabel *nothingMsgL;
@property (nonatomic,strong) UIButton *nothingBtn;
@property (nonatomic,strong) UIView  *nothingView;

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIImageView *naviView;
@property (nonatomic,strong) UIView *lineView;

- (void)nothingBtnClick;
- (void)doReturn;
- (void)rightBtnClick;
@end

NS_ASSUME_NONNULL_END
