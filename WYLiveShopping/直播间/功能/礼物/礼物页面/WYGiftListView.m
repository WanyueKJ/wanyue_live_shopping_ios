//
//  WYGiftListView.m
//  WYLiveShopping
//
//  Created by apple on 2020/8/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYGiftListView.h"
#import "giftCell.h"
#import "liwuModel.h"
#import "PublicObj.h"
#import "LWLCollectionViewHorizontalLayout.h"
#define celll @"cell"
@interface CollectionCellWhite : UICollectionViewCell
@end

@implementation CollectionCellWhite

- (instancetype)initWithFrame:(CGRect)frame andPlayDic:(NSDictionary *)zhuboDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
@interface WYGiftListView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _pageCount;
    NSTimer *timer;
    int a;
    NSMutableArray *selectedArray;
    UIView *allGiftView;
    NSArray *countArray;
    UIImageView *btnBgImgView;
    UIButton *giftCountBtn;
    UIButton *haohuaBtn;
    UIImageView *coinIconImg;
    BOOL isRight;
}
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property(nonatomic,strong)NSMutableArray *models;
@property(nonatomic,strong)CABasicAnimation *animation;
@property(nonatomic,strong)liwuModel *selectModel;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UIButton *continuBTN;
@property(nonatomic,strong)UIButton *push;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)NSDictionary *pldic;
@property(nonatomic,strong)NSMutableArray *myArr;
@property (nonatomic,strong) UIView *giftCountView;

@end
@implementation WYGiftListView

- (instancetype)initWithFrame:(CGRect)frame andZhuboMsg:(NSDictionary *)dic{
    self = [super initWithFrame:frame];
    if (self) {
        self.models = [NSMutableArray array];
        self.pldic = dic;
        countArray = @[@"1314",@"520",@"100",@"88",@"66",@"10",@"1"];
        self.backgroundColor = RGB_COLOR(@"#000000", 0.96);
        [self addSubview:self.tipLabel];
        [self creatAllGiftView];
        [self creatBottomView];
    }
    return self;
}
#pragma mark - request
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"giftlist" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
    
            [Config saveIcon:minstr([info valueForKey:@"coin"])];
            [self chongzhiV:minstr([info valueForKey:@"coin"])];
            self.allArray = [info valueForKey:@"list"];
            NSMutableArray *muatb = [NSMutableArray array];
            for (int i=0;i<self.allArray.count;i++) {
                liwuModel *model = [liwuModel modelWithDic:self.allArray[i]];
                [muatb addObject:model];
            }
            _models = muatb;
            for (int i=0; i<self.allArray.count; i++) {
                [selectedArray addObject:@"0"];
            }
            _pageCount = self.allArray.count;
            while (_pageCount % 10 != 0) {
                ++_pageCount;
                NSLog(@"%zd", _pageCount);
            }
            for (int i=0; i<self.allArray.count; i++) {
                [selectedArray addObject:@"0"];
            }
            [self.collectionView reloadData];
        }
    }Fail:^{
        
    }];
    
}

#pragma mark - 发送礼物
-(void)doLiWu:(UIButton *)sender{
    if(!_selectModel){
        return;
    }
    NSString *lianfa = @"y";
    _push.enabled = NO;
    NSLog(@"发送了%@",_selectModel.giftname);
    //判断连发
    NSString *giftCount;
    if ([_selectModel.type isEqual:@"1"]) {
        giftCount = @"1";
        lianfa = @"n";
        _continuBTN.hidden = YES;
        _push.enabled = YES;
                
    }else{
        giftCount = minstr(giftCountBtn.titleLabel.text);
        btnBgImgView.hidden = YES;
        _continuBTN.hidden = NO;
        a = 5;
        if(timer == nil){
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(jishiqi) userInfo:nil repeats:YES];
        }
        if(sender == _push){
            [timer setFireDate:[NSDate date]];
        }
    }
    //}
//else{
//        giftCount = @"1";
//
//    }

    /*******发送礼物开始 **********/
    NSDictionary *giftDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.pldic valueForKey:@"uid"],@"liveuid",[self.pldic valueForKey:@"stream"],@"stream",_selectModel.ID,@"giftid",giftCount,@"count", nil];
    NSLog(@"%@",giftDic);
    [WYToolClass postNetworkWithUrl:@"sendgift" andParameter:giftDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            
            NSString *coin = minstr([info valueForKey:@"coin"]);
//            LiveUser *liveUser = [Config myProfile];
//            liveUser.coin  =  [NSString stringWithFormat:@"%@",coin];
            [Config saveIcon:coin];
            [self chongzhiV:coin];
            [self.delegate sendGift:self.myArr andPlayDic:self.pldic andData:info andLianFa:lianfa];
            
            [_collectionView reloadData];
            
        }else{
            
                _continuBTN.hidden = YES;
                btnBgImgView.hidden = NO;
            
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        btnBgImgView.hidden = NO;
        _continuBTN.hidden = YES;
    }];
}
//连发倒计时
-(void)jishiqi{
    a-=1;
    [_continuBTN setTitle:[NSString stringWithFormat:@"%@\n  %ds",@"连发",a] forState:UIControlStateNormal];
    if (a == 0) {
        [timer setFireDate:[NSDate distantFuture]];
        _push.enabled = YES;
        _continuBTN.hidden = YES;
        btnBgImgView.hidden = NO;
    }
}
- (void)addAnimation:(NSIndexPath *)indexpath{
    for (giftCell *cell in _collectionView.visibleCells) {
        if ([[_collectionView indexPathForCell:cell] isEqual:indexpath]) {
            [cell.giftIcon.layer addAnimation:self.animation forKey:nil];
        }else{
            [cell.giftIcon.layer removeAllAnimations];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    [_collectionView reloadData];
    //    [self addAnimation];
}
-(CABasicAnimation *)animation{
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _animation.duration = 0.88;       //执行时间
        _animation.repeatCount = 9999999;      //执行次数
        _animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        _animation.fromValue = [NSNumber numberWithFloat:1];   //初始伸缩倍数
        _animation.toValue = [NSNumber numberWithFloat:0.8];     //结束伸缩倍数
    }
    return _animation;
}
-(void)reloadPushState{
    for (NSString *type in selectedArray) {
        if ([type isEqual:@"1"]) {
            //            _push.backgroundColor = normalColors;
            _push.enabled = YES;
            break;
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //水平滑动时 判断是右滑还是左滑
    if(velocity.x>0){
        //右滑
        NSLog(@"右滑");
        isRight = YES;
    }else{
        //左滑
        NSLog(@"左滑");
        isRight = NO;
    }
    NSLog(@"scrollViewWillEndDragging");
    if (isRight) {
        self.pageControl.currentPage+=1;
    }
    else{
        self.pageControl.currentPage-=1;
    }
}
#pragma mark - collection delegate
//展示cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pageCount;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item >= self.models.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite"
                                                                               forIndexPath:indexPath];
        return cell;
    } else {
        giftCell *cell = (giftCell *)[collectionView dequeueReusableCellWithReuseIdentifier:celll forIndexPath:indexPath];
        
        liwuModel *model = self.models[indexPath.item];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.model = model;
        NSString *duihao = [NSString stringWithFormat:@"%@",selectedArray[indexPath.item]];
//        if (isBag) {
//            cell.giftCoinL.text = [NSString stringWithFormat:@"%@个",model.num];
//        }
        if ([duihao isEqual:@"1"]) {
            cell.selectImgView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell.giftIcon.layer addAnimation:self.animation forKey:nil];
            });
        }
        else{
            cell.selectImgView.hidden = YES;
            [cell.giftIcon.layer removeAllAnimations];
        }
        return cell;
    }
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item>=self.models.count) {
        return;
    }
    haohuaBtn.selected = YES;
    selectedArray = nil;
    selectedArray = [NSMutableArray array];
    for (int i=0; i<self.allArray.count; i++) {
        [selectedArray addObject:@"0"];
    }
    [selectedArray replaceObjectAtIndex:indexPath.item withObject:@"1"];
    _selectModel = self.models[indexPath.item];
    _push.enabled = YES;
    if (timer) {
        //        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }
    _continuBTN.hidden = YES;
    
    if ([_selectModel.type isEqual:@"1"]) {
        haohuaBtn.hidden = NO;
        btnBgImgView.hidden = YES;
    }else{
        haohuaBtn.hidden = YES;
        btnBgImgView.hidden = NO;
    }
    //    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    //    [self addAnimation:indexPath];
    
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_window_width/5-0.01, _window_width/4-0.01);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}



#pragma mark-UI
- (void)creatBottomView{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,allGiftView.bottom, _window_width,40+ShowDiff)];
    [self addSubview:_bottomView];
    btnBgImgView = [[UIImageView alloc]init];
    btnBgImgView.frame = CGRectMake(_window_width-140, 2, 130, 36);
    btnBgImgView.userInteractionEnabled = YES;
    btnBgImgView.image = [UIImage imageNamed:@"gift_send"];
    [_bottomView addSubview:btnBgImgView];
    
    haohuaBtn = [UIButton buttonWithType:0];
    [haohuaBtn setTitle:@"赠送" forState:UIControlStateNormal];
    [haohuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [haohuaBtn setTitleColor:RGB_COLOR(@"#949596", 1) forState:UIControlStateNormal];
    [haohuaBtn setBackgroundImage:[PublicObj getImgWithColor:normalColors] forState:UIControlStateSelected];
    [haohuaBtn setBackgroundImage:[PublicObj getImgWithColor:RGB_COLOR(@"#282518", 1)] forState:UIControlStateNormal];
    haohuaBtn.selected = NO;
    [haohuaBtn addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchUpInside];
    haohuaBtn.frame = CGRectMake(btnBgImgView.left+47,2,65+18,36);
    haohuaBtn.layer.cornerRadius = 18.0;
    haohuaBtn.layer.masksToBounds = YES;
    haohuaBtn.hidden = NO;
    [_bottomView addSubview:haohuaBtn];
    
    //选择数量按钮
    giftCountBtn = [UIButton buttonWithType:0];
    giftCountBtn.frame = CGRectMake(0, 0, 65, 36);
    [giftCountBtn setTitle:@"1" forState:0];
    [giftCountBtn setImage:[UIImage imageNamed:@"gift_down"] forState:0];
    [giftCountBtn addTarget:self action:@selector(giftCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    giftCountBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [giftCountBtn setTitleColor:normalColors forState:0];
    giftCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 17);
    giftCountBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 48, 13, 5);
    [btnBgImgView addSubview:giftCountBtn];
    btnBgImgView.hidden = YES;
    //发送按钮
    _push = [UIButton buttonWithType:UIButtonTypeSystem];
    [_push setTitle:@"赠送" forState:UIControlStateNormal];
    [_push setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_push addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchUpInside];
    _push.enabled = NO;
    _push.tag = 6789;
    _push.frame = CGRectMake(65,0,65,36);
    [btnBgImgView addSubview:_push];
    
    CGFloat w = 80;
    _continuBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _continuBTN.frame = CGRectMake(_window_width - 85,_bottomView.top-40,w,w);
    [_continuBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_continuBTN addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchDown];
    _continuBTN.tag = 5678;
    _continuBTN.titleLabel.numberOfLines = 2;
    [_continuBTN setBackgroundImage:[UIImage imageNamed:@"gift_continus"] forState:UIControlStateNormal];
    _continuBTN.hidden = YES;
    [self addSubview:_continuBTN];

    coinIconImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    coinIconImg.image = [UIImage imageNamed:@"coin"];
    [_bottomView addSubview:coinIconImg];
        
        //充值lable
    _chongzhi = [[UILabel alloc] init];
    //LiveUser *user = [Config myProfile];
    _chongzhi.textColor = normalColors;
    _chongzhi.font = [UIFont boldSystemFontOfSize:14];
    _chongzhi.frame = CGRectMake(coinIconImg.right+10,10,_window_width-150-40,20);
    [_bottomView addSubview:_chongzhi];
        //充值上透明按钮
    _jumpRecharge = [[UIButton alloc] initWithFrame:CGRectMake(0,0,_window_width-150,40)];
    _jumpRecharge.titleLabel.text = @"";
    [_jumpRecharge setBackgroundColor:[UIColor clearColor]];
    [_jumpRecharge addTarget:self action:@selector(jumpRechargess) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_jumpRecharge];
    [self requestData];
}
- (void)jumpRechargess{
    if ([self.delegate respondsToSelector:@selector(pushCoinV)]) {
        [self.delegate pushCoinV];
    }
}
- (void)giftCountBtnClick:(UIButton *)btn{
    if (!_giftCountView) {
        _giftCountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _giftCountView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideGiftCountView)];
        [_giftCountView addGestureRecognizer:tap];
        [self addSubview:_giftCountView];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width-140, _giftCountView.height-25*countArray.count-10-40-ShowDiff, 65, 25*countArray.count+10)];
        imgView.image = [UIImage imageNamed:@"gift_nums"];
        imgView.userInteractionEnabled = YES;
        [_giftCountView addSubview:imgView];
        for (int i = 0; i < countArray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(0, i*25, 65, 25);
            [btn setTitle:countArray[i] forState:0];
            [btn setTitleColor:normalColors forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(selectGiftNum:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:btn];
        }
    }else{
        _giftCountView.hidden = NO;
    }
    [giftCountBtn setImage:[UIImage imageNamed:@"gift_top"] forState:0];
    
}
- (void)selectGiftNum:(UIButton *)sender{
    _giftCountView.hidden = YES;
    [giftCountBtn setTitle:sender.titleLabel.text forState:0];
    [giftCountBtn setImage:[UIImage imageNamed:@"gift_down"] forState:0];
}
- (void)hideGiftCountView{
    _giftCountView.hidden = YES;
    [giftCountBtn setImage:[UIImage imageNamed:@"gift_down"] forState:0];
    
}

-(void)chongzhiV:(NSString *)coins{
    if (_chongzhi && coins.length>0) {
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:coins];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"pre_right"];
        attch.bounds = CGRectMake(0,0,10,10);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [noteStr appendAttributedString:string];
        [_chongzhi setAttributedText:noteStr];
    }
}
- (void)creatAllGiftView{
    allGiftView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, _window_width, _window_width/2+20)];
    [self addSubview:allGiftView];
    UIImageView *colBgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/2)];
    colBgImgView.image = [UIImage imageNamed:@"gift_col_back"];
    [allGiftView addSubview:colBgImgView];
    LWLCollectionViewHorizontalLayout *Flowlayout =[[LWLCollectionViewHorizontalLayout alloc]init];
    Flowlayout.itemCountPerRow = 5;
    Flowlayout.rowCount = 2;
    Flowlayout.minimumLineSpacing = 0;
    Flowlayout.minimumInteritemSpacing = 0;
    Flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_width/2) collectionViewLayout:Flowlayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    //注册cell
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"giftCell" bundle:nil] forCellWithReuseIdentifier:celll];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.multipleTouchEnabled = NO;
    [self.collectionView registerClass:[CollectionCellWhite class]
            forCellWithReuseIdentifier:@"CellWhite"];
    [allGiftView addSubview:self.collectionView];
    
    //page
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0,_collectionView.bottom,_window_width,20);
    //    pageControl.center = CGPointMake(0,_collectionView.bottom+10);
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //        pageControl.backgroundColor = RGB_COLOR(@"#323232", 0.9);
    pageControl.enabled = NO;
    _pageControl = pageControl;
    [allGiftView addSubview:pageControl];
    
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 15)];
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.text = @"礼物";
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}
@end
