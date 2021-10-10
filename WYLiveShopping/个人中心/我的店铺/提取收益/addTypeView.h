//
//  addTypeView.h
//  yunbaolive
//
//  Created by Boom on 2018/10/11.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^setNewType)();

@interface addTypeView : UIView<UITextFieldDelegate>
@property (nonatomic,copy) setNewType block;

@end

NS_ASSUME_NONNULL_END
