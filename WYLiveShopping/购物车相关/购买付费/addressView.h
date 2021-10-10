//
//  addressView.h
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^changeAddressBlock)();
@interface addressView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UILabel *nothingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *detaileL;
@property (nonatomic,strong) NSDictionary *adressDic;
@property (nonatomic,copy) changeAddressBlock block;

//- (void)getgetDefaultAddr;
@end

NS_ASSUME_NONNULL_END
