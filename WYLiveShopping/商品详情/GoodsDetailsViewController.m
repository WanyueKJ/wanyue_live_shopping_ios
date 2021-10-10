//
//  GoodsDetailsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "homeViewController.h"
#import "HZPhotoBrowser.h"
#import "detailesGoodCell.h"
#import "productView.h"
#import "WYCarView.h"
#import "ReplyCell.h"
#import "ReplyListViewController.h"
#import "WMPlayer.h"
#import "SubmitOrderViewController.h"
#import "goodsShareView.h"
#import "StoreHomeViewController.h"

@interface GoodsDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WKNavigationDelegate,UIScrollViewDelegate,WMPlayerDelegate>{
    NSMutableArray *sliderArray;
    NSMutableArray *imageArray;
    NSString *description;
    NSDictionary *storeInfo;
    
    
    UILabel *priceLabel;
    UIImageView *vipImgView;
    UILabel *nameL;
    UILabel *oldPriceL;
    UILabel *stockLaleb;
    UILabel *salesLabel;
    UIView *integralView;//积分视图
    UILabel *integralLabel;//赠送积分数量
    UIView *specificationsView;//规格视图
    UILabel *specificationsLabel;//规格信息label
    
    UILabel *evaluateNumsL;
    UILabel *highLabel;
    
    UIImageView *storeThumbImgView;
    UILabel *storeNameLabel;
    
    NSMutableArray *goodListArray;//推荐商品数组
    
    NSArray *productAttr;//产品属性
    id productValue;//产品属性值
    NSString *uniqueID;//产品属性分类的ID，例如：XXL，红色的ID
    productView *productSelectView;
    
    //视频播放
    UIImageView *videoPlaceholdImgView;
    
    
    goodsShareView *shareView;
    //店铺ID
    NSString *mer_id;
    
    NSString *service_url;//客服链接
}
@property (nonatomic,strong) HoverPageScrollView *backScrollView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIView *naviView;
@property (nonatomic,strong) NSMutableArray *naviBtnArray;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *goodsView;

@property (nonatomic,strong) UIView *evaluateView;

@property (nonatomic,strong) UIScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) WMPlayer *wmPlayer;
@property (nonatomic,strong) UIPageControl *sliderPageC;

@property (nonatomic,strong) UIView *storeView;


@property (nonatomic,strong) UIView *goodListView;
@property (nonatomic,strong) UICollectionView *goodCollectionView;
@property (nonatomic,strong) UIPageControl *goodPageC;

@property (nonatomic,strong) WYCarView *carView;

@property (nonatomic,strong) UIView *addGoodsToStoreView;

@end

@implementation GoodsDetailsViewController
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[HoverPageScrollView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height-50-ShowDiff)];
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.bounces = NO;
        _backScrollView.delegate = self;
        if (@available(iOS 11.0, *)){
            _backScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _backScrollView.contentSize = CGSizeMake(0, _window_height * 2);

    }
    return _backScrollView;;
}

#pragma mark -- UIScrollView代理 管理naviView的透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _backScrollView) {
        _naviView.alpha = _backScrollView.contentOffset.y/128.00;
        _goodCollectionView.scrollEnabled = NO;
        _cycleScrollView.scrollEnabled = NO;
        UIButton *btn;
        if (scrollView.contentOffset.y + (64 + statusbarHeight) < _evaluateView.y) {
            btn = _naviBtnArray[0];
        }else if (scrollView.contentOffset.y + (64 + statusbarHeight) < _goodListView.y){
            btn = _naviBtnArray[1];
        }else if (scrollView.contentOffset.y + (64 + statusbarHeight) < _webView.y){
            btn = _naviBtnArray[2];
        }else{
            btn = _naviBtnArray[3];
        }
        _lineView.centerX = btn.centerX;

    }else if (scrollView == _goodCollectionView){
        _backScrollView.scrollEnabled = NO;
        _goodPageC.currentPage = scrollView.contentOffset.x/_window_width;
    }else if (scrollView == _cycleScrollView){
        if (self.wmPlayer) {
            [self.wmPlayer pause];
        }
        _backScrollView.scrollEnabled = NO;
        _sliderPageC.currentPage = scrollView.contentOffset.x/_window_width;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _backScrollView.scrollEnabled = YES;
    _goodCollectionView.scrollEnabled = YES;
    _cycleScrollView.scrollEnabled = YES;
}
#pragma mark -- 商品信息视图
- (UIView *)goodsView{
    if (!_goodsView) {
        _goodsView = [[UIView alloc]init];
        _goodsView.backgroundColor = [UIColor whiteColor];
    }
    return _goodsView;
}
- (void)creatGoodsMessage{
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_backScrollView);
        make.top.equalTo(_cycleScrollView.mas_bottom);
    }];
    priceLabel = [[UILabel alloc]init];
    priceLabel.font = SYS_Font(13);
    priceLabel.textColor = color32;
    [_goodsView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_goodsView).offset(15);
    }];
    if (!_isAdd) {
        vipImgView = [[UIImageView alloc]init];
        vipImgView.image = [UIImage imageNamed:@"VIPidentifi"];
        vipImgView.hidden = YES;
        [_goodsView addSubview:vipImgView];
        [vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLabel.mas_centerY).offset(-1);
            make.left.equalTo(priceLabel.mas_right).offset(3);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(23);
        }];
        UIButton *shareBtn = [UIButton buttonWithType:0];
        [shareBtn setImage:[UIImage imageNamed:@"web_share"] forState:0];
        [shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
        [_goodsView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_goodsView).offset(-15);
            make.centerY.equalTo(priceLabel);
            make.width.height.mas_equalTo(30);
        }];
    }
    nameL = [[UILabel alloc]init];
    nameL.font = [UIFont boldSystemFontOfSize:15];
    nameL.textColor = color32;
    nameL.numberOfLines = 0;
    [_goodsView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel);
        make.top.equalTo(priceLabel.mas_bottom).offset(15);
        make.width.equalTo(_goodsView).offset(-30);
    }];
    
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = SYS_Font(13);
        label.textColor = color64;
        [_goodsView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameL.mas_bottom).offset(10);
        }];
        if (i == 0) {
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(priceLabel);
            }];
            oldPriceL = label;
        }else if (i == 1){
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_goodsView);
            }];
            stockLaleb = label;
        }else{
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(nameL);
            }];
            salesLabel = label;
        }
    }
    UIView *llView = [[UIView alloc]init];
    llView.backgroundColor = colorf0;
    [_goodsView addSubview:llView];
    [llView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_goodsView);
        make.top.equalTo(oldPriceL.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    integralView = [[UIView alloc]init];
    integralView.backgroundColor = [UIColor whiteColor];
    integralView.hidden = YES;
    [_goodsView addSubview:integralView];
    [integralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_goodsView);
        make.top.equalTo(llView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    UILabel *zengL = [[UILabel alloc]init];
    zengL.font = SYS_Font(15);
    zengL.textColor = color64;
    zengL.text = @"赠积分：";
    [integralView addSubview:zengL];
    [zengL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(integralView).offset(15);
        make.centerY.equalTo(integralView);
    }];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"赠送积分"];
    [integralView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zengL.mas_right).offset(10);
        make.centerY.equalTo(zengL);
        make.height.mas_equalTo(20);
    }];
    integralLabel = [[UILabel alloc]init];
    integralLabel.font = SYS_Font(13);
    integralLabel.textColor = normalColors;
    [integralView addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV).offset(12);
        make.right.equalTo(imageV).offset(-12);
        make.center.equalTo(imageV);
    }];

    UIView *llView2 = [[UIView alloc]init];
    llView2.backgroundColor = colorf0;
    [integralView addSubview:llView2];
    [llView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(integralView);
        make.height.mas_equalTo(0.5);
    }];
    
    specificationsView  = [[UIView alloc]init];
    specificationsView.backgroundColor = [UIColor whiteColor];
    specificationsView.hidden = YES;
    [_goodsView addSubview:specificationsView];
    [specificationsView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.width.equalTo(_goodsView);
         make.top.equalTo(integralLabel.mas_bottom);
         make.height.mas_equalTo(60);
    }];
    UILabel *guigeL = [[UILabel alloc]init];
    guigeL.font = SYS_Font(15);
    guigeL.textColor = color64;
    guigeL.text = @"规格 ";
    [specificationsView addSubview:guigeL];
    [guigeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specificationsView).offset(15);
        make.centerY.equalTo(specificationsView).offset(-5);
    }];
    UIImageView *rightImgV2 = [[UIImageView alloc]init];
    rightImgV2.image = [UIImage imageNamed:@"detalies右"];
    [specificationsView addSubview:rightImgV2];
    [rightImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(specificationsView).offset(-10);
        make.centerY.equalTo(guigeL);
        make.width.height.mas_equalTo(15);
    }];
    specificationsLabel = [[UILabel alloc]init];
    specificationsLabel.font = SYS_Font(15);
    specificationsLabel.textColor = color32;
    specificationsLabel.text = @"请选择规格";
    [specificationsView addSubview:specificationsLabel];
    [specificationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(guigeL.mas_right).offset(10);
        make.centerY.equalTo(guigeL);
    }];

    
    UIView *llView4 = [[UIView alloc]init];
    llView4.backgroundColor = colorf0;
    [specificationsView addSubview:llView4];
    [llView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(specificationsView);
        make.height.mas_equalTo(10);
    }];
    UIButton *specificationsBtn = [UIButton buttonWithType:0];
    [specificationsBtn addTarget:self action:@selector(doShowProductView) forControlEvents:UIControlEventTouchUpInside];
    [specificationsView addSubview:specificationsBtn];
    [specificationsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(specificationsView);
    }];
    [_goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(specificationsView.mas_bottom);
    }];
}
- (void)doShare{
    if (!shareView) {
        shareView = [[goodsShareView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andRoomMessage:storeInfo];
        shareView.liveUid = _liveUid;
        [self.view addSubview:shareView];
    }
    [shareView show];
}
#pragma mark -- 评价视图
- (UIView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView = [[UIView alloc]init];
        _evaluateView.backgroundColor = [UIColor whiteColor];
        UILabel *pingjiaL = [[UILabel alloc]init];
        pingjiaL.font = SYS_Font(15);
        pingjiaL.textColor = color32;
        pingjiaL.text = @"用户评价(0)";
        [_evaluateView addSubview:pingjiaL];
        [pingjiaL mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(_evaluateView).offset(15);
            make.centerY.equalTo(_evaluateView.mas_top).offset(25);
        }];
        evaluateNumsL = pingjiaL;
        UIImageView *rightImgV2 = [[UIImageView alloc]init];
        rightImgV2.image = [UIImage imageNamed:@"detalies右"];
        [_evaluateView addSubview:rightImgV2];
        [rightImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_evaluateView).offset(-10);
            make.centerY.equalTo(pingjiaL);
            make.width.height.mas_equalTo(15);
        }];
        
        UILabel *highTipsLabel = [[UILabel alloc]init];
        highTipsLabel.font = SYS_Font(15);
        highTipsLabel.textColor = color64;
        highTipsLabel.text = @"好评率";
        [_evaluateView addSubview:highTipsLabel];
        [highTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImgV2.mas_left).offset(-3);
            make.centerY.equalTo(pingjiaL);
        }];

        highLabel = [[UILabel alloc]init];
        highLabel.font = SYS_Font(15);
        highLabel.textColor = normalColors;
        highLabel.text = @"";
        [_evaluateView addSubview:highLabel];
        [highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(highTipsLabel.mas_left).offset(-1);
            make.centerY.equalTo(pingjiaL);
        }];
        UIButton *btn = [UIButton buttonWithType:0];
        [btn addTarget:self action:@selector(doAllReplys) forControlEvents:UIControlEventTouchUpInside];
        [_evaluateView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(pingjiaL);
            make.right.equalTo(rightImgV2);
            make.left.equalTo(highLabel);
            make.height.mas_equalTo(50);
        }];
    }
    return _evaluateView;
}
//有评价刷新评价视图
- (void)reloadEvaluateView:(NSDictionary *)dic{
    replyModel *model = [[replyModel alloc] initWithDic:dic];
    ReplyCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil] lastObject];
    cell.model = model;
    cell.frame = CGRectMake(0, 50, _window_width, model.rowH);
    [_evaluateView addSubview:cell];
    [_evaluateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50+model.rowH);
    }];
}
- (void)doAllReplys{
    ReplyListViewController *vc = [[ReplyListViewController alloc]init];
    vc.goodsID = _goodsID;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (UIView *)storeView{
    if (!_storeView) {
        _storeView = [[UIView alloc]init];
        _storeView.backgroundColor = [UIColor whiteColor];
        UIView *llView = [[UIView alloc]init];
        llView.backgroundColor = colorf0;
        [_storeView addSubview:llView];
        [llView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.top.equalTo(_storeView);
            make.height.mas_equalTo(10);
        }];

        storeThumbImgView = [[UIImageView alloc]init];
        storeThumbImgView.contentMode = UIViewContentModeScaleAspectFill;
        storeThumbImgView.layer.cornerRadius = 20;
        storeThumbImgView.layer.masksToBounds = YES;
        [_storeView addSubview:storeThumbImgView];
        [storeThumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_storeView).offset(15);
            make.centerY.equalTo(_storeView).offset(5);
            make.width.height.mas_equalTo(40);
        }];
        storeNameLabel = [[UILabel alloc]init];
        storeNameLabel.font = [UIFont boldSystemFontOfSize:15];
        storeNameLabel.textColor = color32;
        [_storeView addSubview:storeNameLabel];
        [storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(storeThumbImgView.mas_right).offset(8);
            make.centerY.equalTo(storeThumbImgView);
        }];
        UIImageView *rightImgV2 = [[UIImageView alloc]init];
        rightImgV2.image = [UIImage imageNamed:@"detalies右"];
        [_storeView addSubview:rightImgV2];
        [rightImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_storeView).offset(-10);
            make.centerY.equalTo(storeThumbImgView);
            make.width.height.mas_equalTo(15);
        }];
        
        UILabel *storeTipsLabel = [[UILabel alloc]init];
        storeTipsLabel.font = SYS_Font(14);
        storeTipsLabel.textColor = normalColors;
        storeTipsLabel.text = @"进店逛逛";
        [_storeView addSubview:storeTipsLabel];
        [storeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImgV2.mas_left).offset(-3);
            make.centerY.equalTo(storeThumbImgView);
        }];

        UIButton *btn = [UIButton buttonWithType:0];
        [btn addTarget:self action:@selector(doStoreHome) forControlEvents:UIControlEventTouchUpInside];
        [_storeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(storeThumbImgView);
            make.right.equalTo(rightImgV2);
            make.left.equalTo(storeTipsLabel);
            make.height.mas_equalTo(60);
        }];

    }
    return _storeView;
}
- (void)doStoreHome{
    StoreHomeViewController *vc = [[StoreHomeViewController alloc]init];
    vc.mer_id = mer_id;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
#pragma mark -- 优品推荐
- (UIView *)goodListView{
    if (!_goodListView) {
        goodListArray = [NSMutableArray array];
        _goodListView = [[UIView alloc]init];
        _goodListView.backgroundColor = [UIColor whiteColor];
        
        UIView *llView1 = [[UIView alloc]init];
        llView1.backgroundColor = colorf0;
        [_goodListView addSubview:llView1];
        [llView1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.width.equalTo(_goodListView);
           make.top.equalTo(_goodListView);
           make.height.mas_equalTo(10);
        }];

        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [_goodListView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(_goodListView);
            make.top.equalTo(llView1.mas_bottom);
            make.height.mas_equalTo(50);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"优品推荐";
        label.font = SYS_Font(15);
        label.textColor = normalColors;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        for (int i = 0; i < 2; i ++) {
            UIImageView *imgV = [[UIImageView alloc]init];
            imgV.image = [UIImage imageNamed:@"优品推荐"];
            [view addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.width.height.mas_equalTo(15);
                if (i == 0) {
                    make.right.equalTo(label.mas_left).offset(-20);
                }else{
                    make.left.equalTo(label.mas_right).offset(20);
                }
            }];

        }
        [_goodListView addSubview:self.goodCollectionView];
        [_goodCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(_goodListView);
            make.top.equalTo(view.mas_bottom);
            make.bottom.equalTo(_goodListView).offset(-30);
        }];
        UIView *llView = [[UIView alloc]init];
        llView.backgroundColor = colorf0;
        [_goodListView addSubview:llView];
        [llView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.width.equalTo(_goodListView);
           make.bottom.equalTo(_goodListView);
           make.height.mas_equalTo(10);
        }];

    }
    return _goodListView;
}
- (UIPageControl *)goodPageC{
    if (!_goodPageC) {
        _goodPageC = [[UIPageControl alloc]init];
        _goodPageC.currentPageIndicatorTintColor = normalColors;
        _goodPageC.pageIndicatorTintColor = color64;
    }
    return _goodPageC;
}
- (UICollectionView *)goodCollectionView{
    if (!_goodCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
            flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake(_window_width/3-0.01, _window_width/3 + 40);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(5, 0,5, 0);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        flow.headerReferenceSize = CGSizeMake(_window_width, _window_width*0.34);
        _goodCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        [_goodCollectionView registerNib:[UINib nibWithNibName:@"detailesGoodCell" bundle:nil] forCellWithReuseIdentifier:@"detailesGoodCELL"];
        _goodCollectionView.pagingEnabled = YES;
        _goodCollectionView.delegate =self;
        _goodCollectionView.dataSource = self;
        _goodCollectionView.bounces = NO;
        _goodCollectionView.backgroundColor = RGB_COLOR(@"#ffffff", 1);
        _goodCollectionView.alwaysBounceVertical = NO;

    }
    return _goodCollectionView;

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return goodListArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    liveGoodsModel *model = goodListArray[indexPath.row];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    vc.goodsID = model.goodsID;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    detailesGoodCell *cell = (detailesGoodCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"detailesGoodCELL" forIndexPath:indexPath];
    cell.model = goodListArray[indexPath.row];
    return cell;
}

#pragma mark -- 顶部slider
-(UIScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _window_width, _window_width)];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pagingEnabled = YES;
        _cycleScrollView.backgroundColor = colorf0;
        _cycleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _cycleScrollView;
}
- (void)creatSliderView:(BOOL)isVideo{
    for (int i = 0; i < sliderArray.count; i ++) {
        if (isVideo && i == 0) {
            WMPlayerModel *model = [[WMPlayerModel alloc]init];
            model.videoURL = [NSURL URLWithString:sliderArray[i]];
            model.title = @"";
            if(self.wmPlayer==nil){
                self.wmPlayer = [[WMPlayer alloc] initPlayerModel:model];
            }
            self.wmPlayer.backBtnStyle = BackBtnStylePop;
            self.wmPlayer.loopPlay = NO;//设置是否循环播放
            self.wmPlayer.tintColor = [UIColor whiteColor];//改变播放器着色
            self.wmPlayer.enableBackgroundMode = NO;//开启后台播放模式
            self.wmPlayer.delegate = self;
            self.wmPlayer.topView.hidden = YES;
            self.wmPlayer.bottomView.hidden = YES;

            [self.wmPlayer setPlayerLayerGravity:WMPlayerLayerGravityResizeAspect];
            [_cycleScrollView addSubview:self.wmPlayer];
            [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_cycleScrollView);
                make.top.equalTo(_cycleScrollView);
                make.height.width.mas_equalTo(_window_width);
            }];
            videoPlaceholdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width)];
            [videoPlaceholdImgView sd_setImageWithURL:[NSURL URLWithString:minstr([storeInfo valueForKey:@"image"])]];
            videoPlaceholdImgView.contentMode = UIViewContentModeScaleAspectFill;
            videoPlaceholdImgView.clipsToBounds = YES;
            videoPlaceholdImgView.userInteractionEnabled = YES;
            [_wmPlayer addSubview:videoPlaceholdImgView];

            UIButton *videoPlayBtn = [UIButton buttonWithType:0];
            [videoPlayBtn setImage:[UIImage imageNamed:@"slider_播放"] forState:0];
            [videoPlayBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
            [videoPlaceholdImgView addSubview:videoPlayBtn];
            [videoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_wmPlayer);
                make.width.height.mas_equalTo(60);
            }];
            //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            //旋转屏幕通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onDeviceOrientationChange:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object:nil
             ];

        }else{
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width * i, 0, _window_width, _window_width)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:sliderArray[i]]];
            imgV.contentMode = UIViewContentModeScaleAspectFill;
            imgV.clipsToBounds = YES;
            [_cycleScrollView addSubview:imgV];
        }
    }
    _cycleScrollView.contentSize = CGSizeMake(_window_width*sliderArray.count, 0);
    [_backScrollView addSubview:self.sliderPageC];
//    _sliderPageC.frame = CGRectMake((_window_width-20*sliderArray.count)/2, _window_width-20, 20*sliderArray.count, 20);
    _sliderPageC.numberOfPages = sliderArray.count;
    _sliderPageC.currentPage = 0;
    [_sliderPageC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backScrollView);
        make.bottom.equalTo(_cycleScrollView);
        make.height.mas_equalTo(20);
    }];

}
- (UIPageControl *)sliderPageC{
    if (!_sliderPageC) {
        _sliderPageC = [[UIPageControl alloc]init];
        _sliderPageC.currentPageIndicatorTintColor = normalColors;
        _sliderPageC.pageIndicatorTintColor = color64;
    }
    return _sliderPageC;
}

- (void)playVideo{
    [videoPlaceholdImgView removeFromSuperview];
    videoPlaceholdImgView = nil;
    self.wmPlayer.bottomView.hidden = NO;
    [_wmPlayer play];
}
//全屏的时候hidden底部homeIndicator
-(BOOL)prefersHomeIndicatorAutoHidden{
    return self.wmPlayer.isFullscreen;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(BOOL)prefersStatusBarHidden{
    return self.wmPlayer.prefersStatusBarHidden;
}
//视图控制器实现的方法
- (BOOL)shouldAutorotate{
//    if (self.forbidRotate) {
//        return NO;
//    }
//    if (self.wmPlayer.playerModel.verticalVideo) {
//        return NO;
//    }
     return !self.wmPlayer.isLockScreen;
}
//viewController所支持的全部旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    //对于present出来的控制器，要主动的（强制的）旋转VC，让wmPlayer全屏
//    UIInterfaceOrientationLandscapeLeft或UIInterfaceOrientationLandscapeRight
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    return UIInterfaceOrientationLandscapeRight;
}
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (wmplayer.isFullscreen) {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        //刷新
//        [UIViewController attemptRotationToDeviceOrientation];
    }else{
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
///播放暂停
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    NSLog(@"clickedPlayOrPauseButton");
}
///全屏按钮
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (self.wmPlayer.isFullscreen) {//全屏
        //强制翻转屏幕，Home键在下边。
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    }else{//非全屏
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    }
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}
///单击播放器
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    [self setNeedsStatusBarAppearanceUpdate];
}
///双击播放器
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
    if (wmplayer.isLockScreen) {
        return;
    }
    [wmplayer playOrPause:[wmplayer valueForKey:@"playOrPauseBtn"]];
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{

}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
}
-(void)wmplayerGotVideoSize:(WMPlayer *)wmplayer videoSize:(CGSize )presentationSize{
    
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    [self setNeedsStatusBarAppearanceUpdate];
}
//播放进度的代理方法
-(void)wmplayerPlayTime:(WMPlayer *)wmplayer currentTime:(CGFloat)time{

}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (self.wmPlayer.isLockScreen){
        return;
    }
//    if (self.forbidRotate) {
//        return ;
//    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    if (orientation ==UIInterfaceOrientationPortrait) {
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.wmPlayer.superview);
            make.top.equalTo(self.view);
            make.height.mas_equalTo(_window_width);
        }];
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.topView.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_cycleScrollView addSubview:self.wmPlayer];
        });
    }else{
        [self.view addSubview:self.wmPlayer];
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.topView.hidden = NO;

    }
//    self.enablePanGesture = !self.wmPlayer.isFullscreen;
//    self.nextBtn.hidden = self.wmPlayer.isFullscreen;
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (void)releaseWMPlayer{
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer = nil;
}

#pragma mark -- 商品简介webview
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, _goodListView.bottom, _window_width, _backScrollView.height)];
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.multipleTouchEnabled = YES;
        _webView.scrollView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.panGestureRecognizer.enabled = NO;
    }
    return _webView;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        _webView.frame = CGRectMake(0, _goodListView.bottom, _window_width, [result doubleValue]);//将WKWebView的高度设置为内容高度
        //刷新制定位置Cell
        _backScrollView.contentSize = CGSizeMake(0, _webView.bottom);
    }];
    
    //    插入js代码，对图片进行点击操作
    [webView evaluateJavaScript:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}" completionHandler:^(id object, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:^(id object, NSError *error) {
        
    }];
    imageArray = [self getImgs:description];


}
#pragma mark -- 获取文章中的图片个数
- (NSMutableArray *)getImgs:(NSString *)string
{
   
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    NSArray *array = [string componentsSeparatedByString:@"<img"];
    NSInteger count = [array count] - 1;


    for (int i = 0; i < count; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [_webView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
            
            if (error ==nil) {
                [arrImgURL addObject:str];
            }
       
        }];
    }
    imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURLRequest *request = navigationAction.request;
    if ([request.URL.scheme isEqualToString: @"image-preview"])
    {
        
        NSString *url = [request.URL.absoluteString substringFromIndex:14];
        
        
        //启动图片浏览器， 跳转到图片浏览页面
        if (imageArray.count != 0) {
            
            HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
            browserVc.imageArray = imageArray;
            browserVc.imageCount = imageArray.count; // 图片总数
            browserVc.currentImageIndex = (int)[imageArray indexOfObject:url];//当前点击的图片
            [browserVc show];
            
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
        
    }

    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"在发送请求之前：%@",navigationAction.request.URL.absoluteString);
}

#pragma mark -- 导航
- (UIView *)naviView{
    if (!_naviView) {
        _naviBtnArray = [NSMutableArray array];
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
        _naviView.backgroundColor = [UIColor whiteColor];
        _naviView.alpha = 0;
        NSArray *array = @[@"商品",@"评价",@"推荐",@"详情"];
        for (int i = 0; i < array.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:0];
            [btn setTitle:array[i] forState:0];
            [btn setTitleColor:color32 forState:0];
            btn.titleLabel.font = SYS_Font(15);
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_window_width/2-120 + i * 60 , 24+statusbarHeight, 60, 40);
            [_naviView addSubview:btn];
            [_naviBtnArray addObject:btn];
        }
        [_naviView addSubview:self.lineView];
    }
    return _naviView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(_window_width/2-120+15, _naviView.height - 8, 30, 2)];
        _lineView.backgroundColor = normalColors;
    }
    return _lineView;
}
- (void)headerButtonClick:(UIButton *)sender{
    _lineView.centerX = sender.centerX;
    if (sender.tag == 1000) {
        [_backScrollView setContentOffset:CGPointZero];
    }else if (sender.tag == 1001){
        [_backScrollView setContentOffset:CGPointMake(0, _evaluateView.y - (64 + statusbarHeight))];
    }else if (sender.tag == 1002){
        [_backScrollView setContentOffset:CGPointMake(0, _goodListView.y - (64 + statusbarHeight))];
    }else{
        [_backScrollView setContentOffset:CGPointMake(0, _webView.y - (64 + statusbarHeight))];
    }
}

#pragma mark -- 返回按钮
- (void)addReturnBtn{
    UIButton *returnBtn = [UIButton buttonWithType:0];
    returnBtn.frame = CGRectMake(0, 24+statusbarHeight, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"navi_backImg_black"] forState:0];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn setTintColor:[UIColor blackColor]];

}
- (void)doReturn{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DetailViewController dealloc");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    uniqueID = @"";
    
    [self.view addSubview:self.backScrollView];
    [_backScrollView addSubview:self.cycleScrollView];
    [_backScrollView addSubview:self.goodsView];
    [self creatGoodsMessage];
    [_backScrollView addSubview:self.evaluateView];
    [_evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_backScrollView);
        make.top.equalTo(_goodsView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
//    [_backScrollView addSubview:self.storeView];
//    [_storeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.equalTo(_backScrollView);
//        make.top.equalTo(_evaluateView.mas_bottom);
//    }];

    [_backScrollView addSubview:self.goodListView];
    [_goodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_backScrollView);
        make.top.equalTo(_evaluateView.mas_bottom);
    }];
    [_backScrollView layoutIfNeeded];
    [self.view addSubview:self.naviView];
    if (_isAdd) {
        [self.view addSubview:self.addGoodsToStoreView];
    }else{
        [self.view addSubview:self.carView];
    }
    [self addReturnBtn];
    [self requestData];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"product/detail/%@",_goodsID] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            service_url = minstr([info valueForKey:@"service_url"]);
            storeInfo = [info valueForKey:@"storeInfo"];
            productAttr = [info valueForKey:@"productAttr"];
            productValue = [info valueForKey:@"productValue"];
            [self setGoodsMessage];
            
//            mer_id = minstr([info valueForKey:@"mer_id"]);
//            if ([mer_id integerValue] > 0) {
//                _storeView.hidden = NO;
//                [_storeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(80);
//                }];
//                storeNameLabel.text = minstr([info valueForKey:@"shop_name"]);
//                [storeThumbImgView sd_setImageWithURL:[NSURL URLWithString:minstr([info valueForKey:@"shop_avatar"])]];
//            }else{
//                _storeView.hidden = YES;
//                [_storeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(0);
//                }];
//            }
            NSArray *good_list = [info valueForKey:@"good_list"];
            for (NSDictionary *dic in good_list) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                [goodListArray addObject:model];
            }
            if (goodListArray.count > 3) {
                [_goodListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(95+(_window_width/3+50) * 2);
                }];
            }else if (goodListArray.count > 0 && goodListArray.count <= 3){
                [_goodListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_window_width/3+50 + 95);
                }];
            }else {
                [_goodListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(70);
                }];
            }
            [_goodCollectionView reloadData];
            if (goodListArray.count > 0) {
                [_goodListView addSubview:self.goodPageC];
                _goodPageC.numberOfPages = goodListArray.count % 6 == 0 ? goodListArray.count/6 : goodListArray.count/6+1;
                _goodPageC.currentPage = 0;
                [_goodPageC mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_goodListView);
                    make.top.equalTo(_goodCollectionView.mas_bottom);
                    make.height.mas_equalTo(20);
                }];
            }
            
            evaluateNumsL.text = [NSString stringWithFormat:@"用户评价(%@)",minstr([info valueForKey:@"replyCount"])];
            highLabel.text = [NSString stringWithFormat:@"%@%%",minstr([info valueForKey:@"replyChance"])];
            id reply = [info valueForKey:@"reply"];
            if ([reply isKindOfClass:[NSDictionary class]] && [reply count] > 0) {
                [self reloadEvaluateView:reply];
            }
            _carView.collectButton.selected = [minstr([storeInfo valueForKey:@"userCollect"]) intValue];
            
            description = minstr([storeInfo valueForKey:@"description"]);
            NSString * htmlStyle = @" <style type=\"text/css\"> *{min-width: 80% !important;max-width: 100% !important;} table{ width: 100% !important;} img{ height: auto !important;}  </style> ";
            description = [htmlStyle stringByAppendingString:description];
            NSString *aaa = @"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\">";
            description = [aaa stringByAppendingString:description];
            if (!_webView) {
                [_backScrollView layoutIfNeeded];
                [_backScrollView addSubview:self.webView];
            }
            [_webView loadHTMLString:description baseURL:nil];
            sliderArray = @[].mutableCopy;
            if (minstr([storeInfo valueForKey:@"video_link"]).length > 6) {
                [sliderArray addObject:minstr([storeInfo valueForKey:@"video_link"])];
                [sliderArray addObjectsFromArray:[storeInfo valueForKey:@"slider_image"]];
                [self creatSliderView:YES];
            }else{
                [sliderArray addObjectsFromArray:[storeInfo valueForKey:@"slider_image"]];
                [self creatSliderView:NO];
            }

//li{width: 100% !important; height: auto !important; font-size: 30px !important; line-height: 35px !important; white-space: pre-wrap !important; margin-top: 30px !important; display: block;}
        }
    } Fail:^{
        
    }];
}
- (void)setGoodsMessage{
    if ([minstr([storeInfo valueForKey:@"vip_price"]) floatValue] == 0) {
        priceLabel.attributedText = [self setAttText:minstr([storeInfo valueForKey:@"price"]) andVIP:@""];
        vipImgView.hidden = YES;
    }else{
        priceLabel.attributedText = [self setAttText:minstr([storeInfo valueForKey:@"price"]) andVIP:minstr([storeInfo valueForKey:@"vip_price"])];
        vipImgView.hidden = NO;
    }
    nameL.text = minstr([storeInfo valueForKey:@"store_name"]);
    oldPriceL.text = [NSString stringWithFormat:@"原价:%@",minstr([storeInfo valueForKey:@"ot_price"])];
    stockLaleb.text = [NSString stringWithFormat:@"库存:%@%@",minstr([storeInfo valueForKey:@"stock"]),minstr([storeInfo valueForKey:@"unit_name"])];
    salesLabel.text = [NSString stringWithFormat:@"销量:%@%@",minstr([storeInfo valueForKey:@"sales"]),minstr([storeInfo valueForKey:@"unit_name"])];
    NSString *give_integral = minstr([storeInfo valueForKey:@"give_integral"]);
    if (![give_integral isEqualToString:@"0.00"]) {
        integralLabel.text = [NSString stringWithFormat:@"赠送 %@ 积分",give_integral];
        integralView.hidden = NO;
    }else{
        integralView.hidden = YES;
        [integralView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    if ([productAttr count] == 0) {
        specificationsView.hidden = YES;
        [specificationsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        specificationsView.hidden = NO;
        if ([productValue count] > 0) {
            if ([productValue isKindOfClass:[NSDictionary class]]) {
                [productValue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    if ([minstr([dic valueForKey:@"stock"]) intValue] > 0) {
                        uniqueID = minstr([dic valueForKey:@"unique"]);
                        specificationsLabel.text = key;
                        *stop = YES;
                    }

                }];
            }
            else{
                for (int i = 0; i < [productValue count]; i ++) {
                    NSDictionary *dic = productValue[i];
                    if ([minstr([dic valueForKey:@"stock"]) intValue] > 0) {
                        uniqueID = minstr([dic valueForKey:@"unique"]);
                        specificationsLabel.text = [NSString stringWithFormat:@"%d",i];
                        break;
                    }
                }
            }
            
        }
    }
}
- (NSAttributedString *)setAttText:(NSString *)price andVIP:(NSString *)vipP{
    NSMutableAttributedString *muStr;

    if (vipP.length > 0) {
        muStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@ ¥%@",price,vipP]];
    }else{
        muStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@ ",price]];
    }
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, 1)];
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(1, price.length+2)];
    [muStr addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, price.length+2)];

    return muStr;
}
#pragma mark -- 展示选择规格的view

- (void)doShowProductView{
    if (!productSelectView) {
        productSelectView = [[productView alloc]initWithFrame:CGRectMake(0, 0, _window_height, _backScrollView.height) andProductAttr:productAttr andProductValue:productValue andSelectStr:specificationsLabel.text andName:minstr([storeInfo valueForKey:@"store_name"]) andGoodsMessage:storeInfo];
        [self.view addSubview:productSelectView];
        productSelectView.block = ^(NSString * _Nonnull unique, NSString * _Nonnull keyStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  uniqueID = unique;
                  specificationsLabel.text = keyStr;
            });
        };
    }
    [productSelectView show];
}

- (WYCarView *)carView{
    if (!_carView) {
        _carView = [[WYCarView alloc]init];
        if (_liveUid && _liveUid.length > 0) {
            _carView.addButton.hidden = YES;
            _carView.buyButton.layer.cornerRadius = 18;
            _carView.buyButton.layer.masksToBounds = YES;
            _carView.buyButton.frame = CGRectMake(0, 0, _carView.buyButton.superview.width, 36);
        }
        WeakSelf;
        _carView.block = ^(int type) {
            //0加入购物车 1立即购买 2收藏
            if (type == 0) {
//                if (productAttr.count > 0) {
                    if (!productSelectView || productSelectView.hidden) {
                        [weakSelf doShowProductView];
                    }else{
                        [productSelectView doHide];
                        [weakSelf doAddGoodsToCar:0];
                    }
//                }else{
//                    [weakSelf doAddGoodsToCar:0];
//                }
            }else if (type == 1){
//                if (productAttr.count > 0) {
                    if (!productSelectView || productSelectView.hidden) {
                        [weakSelf doShowProductView];
                    }else{
                        [productSelectView doHide];
                        [weakSelf doAddGoodsToCar:1];
                    }
//                }else{
//                    [weakSelf doAddGoodsToCar:1];
//                    [weakSelf doBuyAndPayView];
//                }

            }else if (type == 2){
                [weakSelf doCollectGoods];
            }else{
                if (service_url.length > 6) {
                    WYWebViewController *web = [[WYWebViewController alloc] init];
                    web.urls = service_url;
                    [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
                }else{
                    [MBProgressHUD showError:@"客服暂未上线"];
                }
            }
        };
    }
    return _carView;
}
- (void)doBuyAndPayView:(NSString *)cartID{
    [WYToolClass postNetworkWithUrl:@"order/confirm" andParameter:@{@"cartId":cartID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            SubmitOrderViewController *vc = [[SubmitOrderViewController alloc]init];
            vc.orderMessage = [info mutableCopy];
            vc.liveUid = _liveUid;
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } fail:^{
        
    }];

}
- (void)doAddGoodsToCar:(int)newValue{
    //new 0:加入购物车 1:立即购买的时候加入购物车
    NSDictionary *dic = @{
        @"productId":_goodsID,
        @"cartNum":productSelectView ? minstr(productSelectView.numsTextF.text) : @"1",
        @"uniqueId":uniqueID,
        @"new":@(newValue)
    };
    [WYToolClass postNetworkWithUrl:@"cart/add" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            if (newValue == 0) {
                [MBProgressHUD showSuccess:@"添加购物车成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:WYCarNumChange object:nil];
            }
            if (newValue == 1) {
                [self doBuyAndPayView:minstr([info valueForKey:@"cartId"])];
            }

        }
    } fail:^{
        
    }];
}
- (void)doCollectGoods{
    _carView.collectButton.userInteractionEnabled = NO;
    NSString *url;
    if (_carView.collectButton.selected) {
        url = @"collect/del";
    }else{
        url = @"collect/add";
    }
    [WYToolClass postNetworkWithUrl:url andParameter:@{@"id":_goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        _carView.collectButton.userInteractionEnabled = YES;

        if (code == 200) {
//            [MBProgressHUD showError:msg];
            _carView.collectButton.selected = !_carView.collectButton.selected;
        }
    } fail:^{
        _carView.collectButton.userInteractionEnabled = YES;
    }];
}





- (UIView *)addGoodsToStoreView{
    if (!_addGoodsToStoreView) {
        _addGoodsToStoreView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-50-ShowDiff, _window_width, 50+ShowDiff)];
        _addGoodsToStoreView.backgroundColor = [UIColor whiteColor];
        UIButton *addBtn = [UIButton buttonWithType:0];
        [addBtn setTitle:@"添加到店铺" forState:0];
        [addBtn setBackgroundColor:normalColors];
        addBtn.titleLabel.font = SYS_Font(15);
        addBtn.layer.cornerRadius = 20;
        addBtn.layer.masksToBounds = YES;
        [addBtn addTarget:self action:@selector(doAddGoodsToMineStore) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame = CGRectMake(15, 4, _window_width-30, 40);
        [_addGoodsToStoreView addSubview:addBtn];

    }
    return _addGoodsToStoreView;

}
- (void)doAddGoodsToMineStore{
    [WYToolClass postNetworkWithUrl:@"shopadd" andParameter:@{@"productid":_goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];

}
- (void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DetailViewController dealloc");
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
