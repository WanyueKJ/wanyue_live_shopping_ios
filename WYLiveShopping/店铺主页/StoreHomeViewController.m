//
//  StoreHomeViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/6.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "StoreHomeViewController.h"
#import "hotGoodsCell.h"
#import "GoodsDetailsViewController.h"

@interface StoreHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIImageView *storeThumbImgView;
    UILabel *storeNameLabel;
    UILabel *numsLabel;
    NSMutableArray *dataArray;
    int page;
    NSString *kefuUrlString;
}
@property (nonatomic,strong) UICollectionView *goodsCollectionView;

@end

@implementation StoreHomeViewController
- (void)getShopService_url{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"shopservice?mer_id=%@",_liveUid] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            kefuUrlString = minstr([info valueForKey:@"service_url"]);
        }
    } Fail:^{
        
    }];
}
- (void)dokefu{
    if (kefuUrlString.length > 6) {
        WYWebViewController *web = [[WYWebViewController alloc] init];
        web.urls = kefuUrlString;
        [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
    }else{
        [MBProgressHUD showError:@"客服暂未上线"];
    }

}
- (void)getSellerGoodsNum{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"shopsalenums?liveuid=%@",_liveUid] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSString *shopsalenums = minstr([info valueForKey:@"nums"]);
            numsLabel.text = [NSString stringWithFormat:@"%@件",shopsalenums];
        }
    } Fail:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    page = 1;
    kefuUrlString = @"";
    [self creatUI];
    [self.view addSubview:self.goodsCollectionView];
    [self getSellerGoodsNum];
    [self requestData];
    [self getShopService_url];
}
- (void)creatUI{
    UIView *storeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 130)];
    storeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:storeView];

    storeThumbImgView = [[UIImageView alloc]init];
    storeThumbImgView.contentMode = UIViewContentModeScaleAspectFill;
    storeThumbImgView.layer.cornerRadius = 25;
    storeThumbImgView.layer.masksToBounds = YES;
    [storeThumbImgView sd_setImageWithURL:[NSURL URLWithString:_avatar]];
    [storeView addSubview:storeThumbImgView];
    [storeThumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeView).offset(15);
        make.top.equalTo(storeView).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    storeNameLabel = [[UILabel alloc]init];
    storeNameLabel.font = [UIFont boldSystemFontOfSize:15];
    storeNameLabel.textColor = color32;
    storeNameLabel.text = [NSString stringWithFormat:@"%@的小店",_nickname];
    [storeView addSubview:storeNameLabel];
    [storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeThumbImgView.mas_right).offset(8);
        make.centerY.equalTo(storeThumbImgView);
    }];
    UIButton *kefuBtn = [UIButton buttonWithType:0];
    [kefuBtn setImage:[UIImage imageNamed:@"store_客服_gray"] forState:0];
    [kefuBtn addTarget:self action:@selector(dokefu) forControlEvents:UIControlEventTouchUpInside];
    [storeView addSubview:kefuBtn];
    [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(storeView).offset(-15);
        make.centerY.equalTo(storeThumbImgView);
        make.width.height.mas_equalTo(30);
    }];
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, _window_width, 40)];
    grayView.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    [storeView addSubview:grayView];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = color32;
    label.text = @"在售商品";
    [grayView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView).offset(15);
        make.centerY.equalTo(grayView);
    }];
    numsLabel = [[UILabel alloc]init];
    numsLabel.font = SYS_Font(12);
    numsLabel.textColor = color96;
    numsLabel.text = @"";
    [grayView addSubview:numsLabel];
    [numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(8);
        make.bottom.equalTo(label);
    }];
}
-(UICollectionView *)goodsCollectionView{
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake((_window_width-40)/2, (_window_width-40)/2+84);
        flow.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _goodsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom + 130, _window_width, _window_height-(self.naviView.bottom + 130)) collectionViewLayout:flow];
        [_goodsCollectionView registerNib:[UINib nibWithNibName:@"hotGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"hotGoodsCELL"];
        [_goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeaderV"];
        _goodsCollectionView.delegate =self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.backgroundColor = RGB_COLOR(@"#fafafa", 1);
        _goodsCollectionView.mj_footer  = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        
        _goodsCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        

    }
    return _goodsCollectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    liveGoodsModel *model = dataArray[indexPath.row];
    vc.goodsID = model.goodsID;
    vc.liveUid = _liveUid;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    hotGoodsCell *cell = (hotGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCELL" forIndexPath:indexPath];
    liveGoodsModel *model = dataArray[indexPath.row];

    cell.model = model;
    cell.salesL.text = [NSString stringWithFormat:@"已售%@件",model.salenums];

    return cell;
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"shopsale?page=%d&liveuid=%@",page,_liveUid] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_goodsCollectionView.mj_header endRefreshing];
        [_goodsCollectionView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            [_goodsCollectionView reloadData];
        }
    } Fail:^{
        [_goodsCollectionView.mj_header endRefreshing];
        [_goodsCollectionView.mj_footer endRefreshing];
    }];

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
