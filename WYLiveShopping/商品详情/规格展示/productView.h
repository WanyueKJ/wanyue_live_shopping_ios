//
//  productView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/28.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectProductSuccess)(NSString *unique, NSString *keyStr);
@interface productView : UIView
-(instancetype)initWithFrame:(CGRect)frame andProductAttr:(NSArray *)array1 andProductValue:(id)dic andSelectStr:(NSString *)str andName:(NSString *)name andGoodsMessage:(NSDictionary *)goodsMsg;
- (void)show;
- (void)doHide;
@property (nonatomic,copy) selectProductSuccess block;
@property (nonatomic,strong) UITextField *numsTextF;

@end

NS_ASSUME_NONNULL_END
