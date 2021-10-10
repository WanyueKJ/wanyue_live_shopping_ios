//
//  startLiveClassVC.h
//  yunbaolive
//
//  Created by Boom on 2018/9/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^liveClassClick)(NSDictionary *dic);

@interface startLiveClassVC : WYBaseViewController
@property (nonatomic,strong)NSString *classID;
@property (nonatomic,copy) liveClassClick block;

@end

NS_ASSUME_NONNULL_END
