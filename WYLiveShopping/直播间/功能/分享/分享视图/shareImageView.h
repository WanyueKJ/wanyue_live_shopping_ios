//
//  shareImageView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/10.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareImageView : UIView
@property (weak, nonatomic) IBOutlet UIView *shareImgV;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *appNameL;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UIButton *wxShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *downImgBtn;

@end

NS_ASSUME_NONNULL_END
