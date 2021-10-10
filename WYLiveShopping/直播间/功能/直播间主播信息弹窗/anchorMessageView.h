//
//  anchorMessageView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol anchorMessageViewDelegate <NSObject>

- (void)closeLive;

@end
typedef void(^followAnchorBlock)(BOOL isFollow);
@interface anchorMessageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumsL;
@property (weak, nonatomic) IBOutlet UILabel *fanNumsL;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
- (void)requestMessage:(NSString *)touid;
@property (nonatomic,copy) followAnchorBlock block;
@property (weak, nonatomic) IBOutlet UIButton *closeLiveBtn;
- (IBAction)closeLiveAction:(id)sender;
@property(nonatomic,weak)id<anchorMessageViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
