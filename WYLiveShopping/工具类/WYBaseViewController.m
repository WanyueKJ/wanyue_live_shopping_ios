//
//  YBBaseViewController.m
//  yunbaolive
//
//  Created by IOS1 on 2019/3/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import "WYBaseViewController.h"
#define naviBackColor [UIColor whiteColor]
#define naviTFont 16
#define naviTColor RGB_COLOR(@"#333333", 1)
@interface WYBaseViewController ()

@end

@implementation WYBaseViewController
- (void)doReturn{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //取消所有网络请求
    [manager.operationQueue cancelAllOperations];

    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)creatNavi{
    _naviView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    _naviView.contentMode = UIViewContentModeScaleAspectFill;
    _naviView.clipsToBounds = YES;
    _naviView.backgroundColor = naviBackColor;
    _naviView.userInteractionEnabled = YES;
    [self.view addSubview:_naviView];
    
    _returnBtn = [UIButton buttonWithType:0];
    _returnBtn.frame = CGRectMake(0, 24+statusbarHeight, 40, 40);
//    _returnBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_returnBtn setImage:[UIImage imageNamed:@"navi_backImg"] forState:0];
    [_returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:UIControlStateSelected];
    [_returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    _returnBtn.titleLabel.font = SYS_Font(15);
    [_returnBtn setTitleColor:color32 forState:0];
    [_naviView addSubview:_returnBtn];
    
    _titleL = [[UILabel alloc]init];
    _titleL.font = [UIFont boldSystemFontOfSize:naviTFont];
    _titleL.textColor = naviTColor;
    _titleL.textAlignment = NSTextAlignmentCenter;
    [_naviView addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_naviView);
        make.top.equalTo(_naviView).offset(34+statusbarHeight);
        make.height.mas_equalTo(20);
        make.width.equalTo(_naviView).multipliedBy(0.6);
    }];
    
    _rightBtn = [UIButton buttonWithType:0];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    _rightBtn.titleLabel.font = SYS_Font(14);
    [_rightBtn setTitleColor:normalColors forState:0];
    [_naviView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_titleL);
        make.right.equalTo(_naviView).offset(-10);
    }];
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = colorf0;
    [_naviView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_naviView);
        make.height.mas_equalTo(1);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBar.hidden = YES;
    if (SysVersion >= 11.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNothingView];
    [self creatNavi];
}

- (void)creatNothingView{
    _nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight)];
    _nothingView.backgroundColor = [UIColor whiteColor];
    _nothingView.hidden = YES;
    [self.view addSubview:_nothingView];
    _nothingImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, _window_width, _window_width*0.6)];
    _nothingImgV.contentMode = UIViewContentModeScaleAspectFit;
    //_nothingImgV.image = [UIImage imageNamed:@""];
    [_nothingView addSubview:_nothingImgV];
    _nothingTitleL = [[UILabel alloc]initWithFrame:CGRectMake(0, _nothingImgV.bottom+10, _window_width, 15)];
    _nothingTitleL.font = [UIFont systemFontOfSize:12];
    _nothingTitleL.textAlignment = NSTextAlignmentCenter;
//    _nothingTitleL.text = @"空空如也";
    _nothingTitleL.textColor = color32;
    [_nothingView addSubview:_nothingTitleL];
    
    _nothingMsgL = [[UILabel alloc]initWithFrame:CGRectMake(0, _nothingTitleL.bottom+5, _window_width, 15)];
//    _nothingMsgL.textColor = RGB_COLOR(@"#969696", 1);
    _nothingMsgL.textColor = color96;
    _nothingMsgL.font = [UIFont systemFontOfSize:11];
    _nothingMsgL.textAlignment = NSTextAlignmentCenter;
    [_nothingView addSubview:_nothingMsgL];

    _nothingBtn = [UIButton buttonWithType:0];
    _nothingBtn.frame = CGRectMake(_window_width*0.2, _nothingMsgL.bottom+40, _window_width*0.6, 40);
    [_nothingBtn setBackgroundImage:[UIImage imageNamed:@"button_back"]];
    _nothingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nothingBtn addTarget:self action:@selector(nothingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _nothingBtn.hidden = YES;
    _nothingBtn.layer.cornerRadius = 20;
    _nothingBtn.layer.masksToBounds  = YES;
    [_nothingView addSubview:_nothingBtn];
}
- (void)nothingBtnClick{
    
}
- (void)rightBtnClick{
    
}
//是否可以旋转
- (BOOL)shouldAutorotate
{
    return false;
}
//支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
