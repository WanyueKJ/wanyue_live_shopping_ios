//
//  YBImageView.m
//  yunbaolive
//
//  Created by IOS1 on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import "WYImageView.h"
#import "WYShowBigImageView.h"
#import "SDWebImageDownloader.h"
@interface WYImageView ()<UIScrollViewDelegate>{
    
    NSInteger currentIndex;
    UILabel *indexLb;
    UIButton *deleteBtn;
    UIView *navi;
    BOOL isMine;
}
@property (nonatomic,copy) YBImageViewBlock returnBlock;

@end
@implementation WYImageView{
    UITapGestureRecognizer *tap;
    UIScrollView *backScrollV;
    NSMutableArray *imageArray;
    NSMutableArray *imgViewArray;
}
- (instancetype)initWithImageArray:(NSArray *)array andIndex:(NSInteger)index andMine:(BOOL)ismine andBlock:(nonnull YBImageViewBlock)block{
    self = [super init];
    isMine = ismine;
    imageArray = [array mutableCopy];
    currentIndex = index;
    self.returnBlock = block;
    self.frame = CGRectMake(0, 0, _window_width, _window_height);
    if (self) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHideNavi)];
        [self addGestureRecognizer:tap];
        backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(_window_width/2, _window_height/2, 0, 0)];
        backScrollV.backgroundColor = [UIColor blackColor];
        backScrollV.contentSize = CGSizeMake(_window_width*imageArray.count, 0);
        backScrollV.contentOffset = CGPointMake(_window_width * index, 0);
        backScrollV.delegate = self;
        backScrollV.pagingEnabled=YES;
        //设置最大伸缩比例
        backScrollV.maximumZoomScale=1;
        //设置最小伸缩比例
        backScrollV.minimumZoomScale=1;
        backScrollV.showsHorizontalScrollIndicator = NO;
        backScrollV.showsVerticalScrollIndicator = NO;

        [self addSubview:backScrollV];
        imgViewArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            id imageContent = imageArray[i];
            WYShowBigImageView *imgV = [[WYShowBigImageView alloc]initWithFrame:CGRectMake(_window_width*i, 0, _window_width, _window_height)];
            if ([imageContent isKindOfClass:[UIImage class]]) {
                imgV.imageView.image = imageContent;
            }else if ([imageContent isKindOfClass:[NSString class]]){
                [imgV.imageView sd_setImageWithURL:[NSURL URLWithString:imageContent]];
            }else if ([imageContent isKindOfClass:[NSDictionary class]]){
                [imgV.imageView sd_setImageWithURL:[NSURL URLWithString:minstr([imageContent valueForKey:@"thumb"])]];
            }
            [backScrollV addSubview:imgV];
            [imgViewArray addObject:imgV];
        }
        [self showBigView];
        [self creatNavi];
    }
    return self;
}
- (void)showBigView{
        [UIView animateWithDuration:0.2 animations:^{
            backScrollV.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
}
- (void)doreturn{
    [UIView animateWithDuration:0.2 animations:^{
        backScrollV.frame = CGRectMake(_window_width/2, _window_height/2, 0, 0);
    }completion:^(BOOL finished) {
        if (self.returnBlock) {
            self.returnBlock(imageArray);
        }
        [backScrollV removeFromSuperview];
        backScrollV = nil;
        [self removeFromSuperview];
    }];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentIndex = scrollView.contentOffset.x/_window_width;
    indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];

}
-(void)creatNavi {
    
    navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navi.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:navi];
    
    
    UIButton *retrunBtn = [UIButton buttonWithType:0];
    retrunBtn.frame = CGRectMake(10, 25+statusbarHeight, 30, 30);
    [retrunBtn setImage:[UIImage imageNamed:@"navi_backImg"] forState:0];
    [retrunBtn addTarget:self action:@selector(doreturn) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:retrunBtn];
    
//    UILabel *titleL = [[UILabel alloc]init];
//    titleL.frame = CGRectMake(_window_width/2-40, 25+statusbarHeight, 80, 30);
//    titleL.textColor = [UIColor whiteColor];
//    titleL.font = [UIFont systemFontOfSize:16];
//    titleL.textAlignment = NSTextAlignmentCenter;
//    titleL.text = @"预览";
//    [navi addSubview:titleL];

    
    indexLb = [[UILabel alloc]init];
    indexLb.frame = CGRectMake(_window_width/2-40, 22+statusbarHeight, 80, 30);
    indexLb.textColor = [UIColor whiteColor];
    indexLb.font = [UIFont systemFontOfSize:15];
    indexLb.textAlignment = NSTextAlignmentCenter;
    indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];
    [navi addSubview:indexLb];
//    id imageContent = [imageArray firstObject];
//    if ([imageContent isKindOfClass:[UIImage class]] || isMine) {
//        deleteBtn = [UIButton buttonWithType:0];
//        deleteBtn.frame = CGRectMake(0, _window_height-40, _window_width, 40);
//        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [deleteBtn setTitle:@"删除" forState:0];
//        [deleteBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
//        [self addSubview:deleteBtn];
//    }
    //    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 63+statusbarHeight, _window_width, 1) andColor:colorf3 andView:navi];
    
}
-(void)deleteBtnClick{
    if (isMine) {
        [MBProgressHUD showMessage:@""];
        NSString *thumbID = minstr([imageArray[currentIndex] valueForKey:@"id"]);
        NSMutableDictionary *mudic = @{
            @"uid":[Config getOwnID],
            @"token":[Config getOwnToken],
            @"id":thumbID,
        }.mutableCopy;
        NSString *sign = [WYToolClass sortString:mudic];
        [mudic setObject:sign forKey:@"sign"];

        [WYToolClass postNetworkWithUrl:@"Photo.DelPhoto" andParameter:mudic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:msg];
            if (code == 0) {
                [self deleteSucess];
            }
        } fail:^{
            [MBProgressHUD hideHUD];
        }];
    }else{
        [self deleteSucess];
    }
}
- (void)deleteSucess{
    [imageArray removeObjectAtIndex:currentIndex];
    if (imageArray.count == 0) {
        [self doreturn];
    }else{
        UIImageView *imgV = imgViewArray[currentIndex];
        [imgV removeFromSuperview];
        [imgViewArray removeObjectAtIndex:currentIndex];
        if (currentIndex == 0) {
            currentIndex = 0;
        }else{
            currentIndex -= 1;
        }
        indexLb.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,imageArray.count];
        backScrollV.contentSize = CGSizeMake(_window_width*imageArray.count, 0);
        [backScrollV setContentOffset:CGPointMake(_window_width*currentIndex, 0)];
        for (int i = 0; i < imgViewArray.count; i ++) {
            WYShowBigImageView *imgVVVV = imgViewArray[i];
            imgVVVV.x = _window_width * i;
        }
    }

}
- (void)showHideNavi{
    navi.hidden = !navi.hidden;
    if (deleteBtn) {
        deleteBtn.hidden = navi.hidden;
    }
}
@end
