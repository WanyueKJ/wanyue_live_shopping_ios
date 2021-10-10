//
//  applePay.h
//  TCLVBIMDemo
//
//  Created by 王敏欣 on 2016/12/2.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol applePayDelegate <NSObject>

-(void)applePayHUD;
-(void)applePayShowHUD;
-(void)applePaySuccess;

@end

@interface applePay : UIView

@property(nonatomic,assign)id<applePayDelegate>delegate;

typedef void (^applePayBlock)(id arrays);

-(void)applePay:(NSDictionary *)dic;

@end
