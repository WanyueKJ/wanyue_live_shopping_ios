//
//  UILabel+RKLabel.m
//  TestApp
//
//  Created by YB007 on 2019/3/15.
//  Copyright © 2019 Rookie. All rights reserved.
//

#import "UILabel+RKLabel.h"
#import <objc/runtime.h>

@implementation UILabel (RKLabel)

+ (void)initialize {
    // 获取到UILabel中setText对应的method
    Method setText = class_getInstanceMethod([UILabel class], @selector(setText:));
    Method setTextMySelf = class_getInstanceMethod([self class], @selector(setTextHooked:));
    
    // 将目标函数的原实现绑定到setTextOriginalImplemention方法上
    IMP setTextImp = method_getImplementation(setText);
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    class_addMethod([UILabel class], @selector(setTextOriginal:), setTextImp, method_getTypeEncoding(setText));
    
    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP setTextMySelfImp = method_getImplementation(setTextMySelf);
    class_replaceMethod([UILabel class], @selector(setText:), setTextMySelfImp, method_getTypeEncoding(setText));
}

/*
 * 截获到 UILabel 的setText
 * 我们可以先处理完以后，再继续调用正常处理流程
 */
- (void)setTextHooked:(NSString *)text {
    //在这里插入过滤算法
    /*
    text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    // do something what ever you want
    NSLog(@"haha, this is my self setText !!!!!!!");
    */
    
    if (text.length==0 || text == nil || [text isEqual:@"<null>"]||[text isEqual:@"(null)"]||[text isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    // invoke original implemention
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(setTextOriginal:) withObject:text];
}
//- (void)setTextOriginal:(NSString *)text {
//    NSLog(@"======:%@====%@",text,self.text);
//}
@end
