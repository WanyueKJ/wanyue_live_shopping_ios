//
//  JZLStarView.h
//  JZLStarView
//
//  Created by allenjzl on 2017/12/1.
//  Copyright © 2017年 com.Woodpecker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, StarStyle) {
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};
@class WYStarView;

@protocol WYStarViewClickDelegate <NSObject>

- (void)didClickStarView:(WYStarView *)starView andCurrentScore:(CGFloat)score;

@end

@interface WYStarView : UIView
/** 评分 */
@property (nonatomic, assign) CGFloat currentScore;


/**
 实例化

 @param frame frame
 @param starCount 星星的数量
 @param starStyle 评分样式
 @param isAllowScroe 是否可以评分,还是只是显示分数
 @return starView
 */
- (instancetype)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount starStyle:(StarStyle)starStyle isAllowScroe:(BOOL)isAllowScroe ;
@property (nonatomic,weak) id<WYStarViewClickDelegate> delegate;

@end
