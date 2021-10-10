//


#import <UIKit/UIKit.h>
@class chatModel;
NS_ASSUME_NONNULL_BEGIN
@protocol LiveOnlineListDelegate <NSObject>

- (void)showUserToast:(chatModel *)model;

@end
@interface LiveOnlineList : UIView
@property(nonatomic,weak)UIViewController *vc;
-(void)requestData;
@property(nonatomic,weak)id<LiveOnlineListDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame stream:(NSString *)stream liveUID:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
