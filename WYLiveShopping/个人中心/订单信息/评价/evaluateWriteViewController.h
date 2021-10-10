//
//  evaluateWriteViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYBaseViewController.h"
#import "cartModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface WYPhotoView : UIView
@property(nonatomic, strong) UIImageView *thumbImgView;
@property (nonatomic,strong) UIButton *delateBtn;

@end

typedef void(^evaluateSucessBlock)();
@interface evaluateWriteViewController : WYBaseViewController
@property (nonatomic,strong) cartModel *goodsModel;
@property (nonatomic,copy) evaluateSucessBlock block;

@end

NS_ASSUME_NONNULL_END
