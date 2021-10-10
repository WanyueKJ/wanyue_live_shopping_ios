//
//  JZLStarView.m
//  JZLStarView
//
//  Created by allenjzl on 2017/12/1.
//  Copyright © 2017年 com.Woodpecker. All rights reserved.
//





#import "WYStarView.h"




@interface WYStarView()
/** 黄色星星背景 */
@property (nonatomic, strong) UIView *colorStarView;
/** 灰色星星背景 */
@property (nonatomic, strong) UIView *grayStarView;

/** 是否只是评分(用于只做分数显示,不能评分) */
@property (nonatomic, assign) BOOL isAllowScroe;
@property (nonatomic, assign) StarStyle StarStyle;
/** 星星的数量 */
@property (nonatomic, assign) NSInteger starCount;


@end

@implementation WYStarView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self creatStarWithstarCount:5 starStyle:0 isAllowScroe:1];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount starStyle:(StarStyle)starStyle isAllowScroe:(BOOL)isAllowScroe  {
    if (self = [super initWithFrame:frame]) {
        [self creatStarWithstarCount:starCount starStyle:starStyle isAllowScroe:isAllowScroe];
    }
    return self;
}

- (void)creatStarWithstarCount:(NSInteger)starCount starStyle:(StarStyle)starStyle isAllowScroe:(BOOL)isAllowScroe  {
    self.colorStarView = [self creatStarViewWithStarCount:starCount starImage:@"star_yellow"];
    self.grayStarView = [self creatStarViewWithStarCount:starCount starImage:@"star_gray"];
    [self addSubview:self.grayStarView];
    [self addSubview:self.colorStarView];
    self.starCount = starCount;
    self.StarStyle = starStyle;
    self.isAllowScroe = isAllowScroe;
    //点击评分
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //滑动评分
//    UISwipeGestureRecognizer* rightSwiper = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:nil];
//    [rightSwiper setDirection:(UISwipeGestureRecognizerDirectionRight)];
//
//    UISwipeGestureRecognizer* leftSwiper = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:nil];
//    [leftSwiper setDirection:(UISwipeGestureRecognizerDirectionRight)];

    [self addGestureRecognizer:tap];
//    [self addGestureRecognizer:rightSwiper];
//    [self addGestureRecognizer:leftSwiper];

}





- (UIView *)creatStarViewWithStarCount:(NSInteger)starCount starImage:(NSString *)starImage {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;//关键
    for (int i = 0; i < starCount; i++) {
        UIImageView *starImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:starImage]];
        starImgView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat width = self.bounds.size.width / starCount;
        CGFloat height = self.bounds.size.height ;
        starImgView.frame = CGRectMake(i * width, 0, width, height);
        [view addSubview:starImgView];
    }
    return view;
}



/** 点击手势 */
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (!self.isAllowScroe) {
        return;
    }
    //获取坐标
    CGPoint tapPoint = [sender locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat starOffset = offset / (self.bounds.size.width / self.starCount);
    switch (self.StarStyle) {
        case WholeStar:{//全星评价
            self.currentScore = ceil(starOffset);
        }
            
            break;
            
        case HalfStar:{//半星评价
            self.currentScore = roundf(starOffset)>starOffset ? ceilf(starOffset):(ceilf(starOffset)-0.5);
        }
            
            break;
            
        case IncompleteStar:{//不完整评价
            self.currentScore = starOffset;
        }
            
            break;
            
        default:
            break;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didClickStarView:andCurrentScore:)]) {
        [self.delegate didClickStarView:self andCurrentScore:self.currentScore];
    }
}





/** 手指移动 */
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!self.isAllowScroe) {
//        return;
//    }
//    UITouch *touch = touches.anyObject;
//    CGPoint tapPoint = [touch locationInView:self];
//    CGFloat offset = tapPoint.x;
//    CGFloat starOffset = offset / (self.bounds.size.width / self.starCount);
//    switch (self.StarStyle) {
//        case WholeStar:{//全星评价
//            self.currentScore = ceil(starOffset);
//        }
//            
//            break;
//            
//        case HalfStar:{//半星评价
//            self.currentScore = roundf(starOffset)>starOffset ? ceilf(starOffset):(ceilf(starOffset)-0.5);
//        }
//            
//            break;
//            
//        case IncompleteStar:{//不完整评价
//            self.currentScore = starOffset;
//        }
//            
//            break;
//            
//        default:
//            break;
//    }

}

- (void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore != currentScore) {
        _currentScore = currentScore;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:0.2 animations:^{
       self.colorStarView.frame =  CGRectMake(0, 0, self.currentScore * self.bounds.size.width / self.starCount, self.bounds.size.height);
    }];
    
}

@end








