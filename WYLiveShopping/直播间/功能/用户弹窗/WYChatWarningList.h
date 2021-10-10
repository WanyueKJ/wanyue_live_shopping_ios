//
//  WYChatWarningList.h
//  WYCity
//
//  Created by apple on 2020/6/30.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WYChatWarningListDelegate <NSObject>

- (void)jinyanUser:(NSString *)time name:(NSString *)content jinyanID:(NSString *)ID;


@end
@interface WYChatWarningList : UIView
-(instancetype)initWithFrame:(CGRect)frame  data:(NSArray *)array;
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,weak)id<WYChatWarningListDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
