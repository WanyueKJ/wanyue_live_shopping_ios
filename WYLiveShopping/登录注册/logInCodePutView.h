//
//  logInputView.h
//  YBEducation
//
//  Created by IOS1 on 2020/2/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^logSucesss)();
@interface logInCodePutView : UIView
@property (nonatomic,copy) logSucesss block;
@property (nonatomic,strong) UITextField *nameT;
@property (nonatomic,strong) UITextField *pwdT;
- (void)ChangeBtnBackground;
@end

NS_ASSUME_NONNULL_END
