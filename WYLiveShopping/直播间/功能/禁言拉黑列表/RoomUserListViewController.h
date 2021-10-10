//
//  RoomUserListViewController.h
//  yunbaolive
//
//  Created by IOS1 on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomUserListViewController : WYBaseViewController
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *liveuid;
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
