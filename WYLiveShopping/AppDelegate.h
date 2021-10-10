//
//  AppDelegate.h
//  YBEducation
//
//  Created by IOS1 on 2020/2/21.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXBADelegate.h"

@interface AppDelegate : MXBADelegate
@property (nonatomic, copy) void (^ backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调


@end

