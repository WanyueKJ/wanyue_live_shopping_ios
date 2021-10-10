//
//  recommendView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "recommendView.h"
#import "hotGoodsCell.h"
#import "GoodsDetailsViewController.h"

@interface recommendView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *dataArray;
    int page;
    UIImage *nothingImage;
}
@property (nonatomic,strong) UICollectionView *recommendCollectionView;
@property (nonatomic,strong) UIView *headerView;

@end

@implementation recommendView

-(instancetype)initWithFrame:(CGRect)frame andNothingImage:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        nothingImage = image;
        dataArray = [NSMutableArray array];
        page = 1;
        [self addSubview:self.recommendCollectionView];
        [self requestData];
    }
    return self;
}
-(UICollectionView *)recommendCollectionView{
    if (!_recommendCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake((_window_width-40)/2, (_window_width-40)/2+84);
        flow.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        if (nothingImage) {
            flow.headerReferenceSize = CGSizeMake(_window_width, _window_width*0.55+60+20);
        }else{
            flow.headerReferenceSize = CGSizeMake(_window_width, 60);
        }
        _recommendCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flow];
        [_recommendCollectionView registerNib:[UINib nibWithNibName:@"hotGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"hotGoodsCELL"];
        [_recommendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeaderV"];
        _recommendCollectionView.delegate =self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.backgroundColor = colorf0;
        _recommendCollectionView.mj_footer  = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        
        _recommendCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        

    }
    return _recommendCollectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    liveGoodsModel *model = dataArray[indexPath.row];
    vc.goodsID = model.goodsID;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    hotGoodsCell *cell = (hotGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCELL" forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    return cell;
}

#pragma mark ================ collectionview头视图 ===============

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeaderV" forIndexPath:indexPath];
        [header addSubview:self.headerView];
        return header;
    }else{
        return nil;
    }
}
- (UIView *)headerView{
    if (!_headerView) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 60)];
        _headerView.backgroundColor = [UIColor whiteColor];
        CGFloat viewTop;
        if (nothingImage) {
            _headerView.size = CGSizeMake(_window_width, _window_width*0.55+60);
            UIImageView *nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.55)];
            nothingImgView.image = nothingImage;
            nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
            [_headerView addSubview:nothingImgView];
            viewTop = nothingImgView.bottom+16;
        }else{
            _headerView.size = CGSizeMake(_window_width, 44);
            viewTop = 16;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, viewTop, _window_width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:view];
        UILabel *label = [[UILabel alloc]init];
        label.font = SYS_Font(15);
        label.textColor = color32;
        label.text = @"热门推荐";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        for (int i = 0; i < 2; i ++) {
            UIImageView *imgV = [[UIImageView alloc]init];
            imgV.image = [UIImage imageNamed:@"四边形"];
            [view addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.width.height.mas_equalTo(6);
                if (i == 0) {
                    make.right.equalTo(label.mas_left).offset(-20);
                }else{
                    make.left.equalTo(label.mas_right).offset(20);
                }
            }];
            UIView *lineV = [[UIView alloc]init];
            lineV.backgroundColor = color32;
            [view addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.width.equalTo(view).multipliedBy(0.1666);
                if (i == 0) {
                    make.right.equalTo(imgV.mas_left).offset(-4);
                }else{
                    make.left.equalTo(imgV.mas_right).offset(4);
                }
                make.height.mas_equalTo(1);
            }];
        }
    }
    return _headerView;
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"product/hot?page=%d&limit=20",page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_recommendCollectionView.mj_header endRefreshing];
        [_recommendCollectionView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            [_recommendCollectionView reloadData];
        }
    } Fail:^{
        [_recommendCollectionView.mj_header endRefreshing];
        [_recommendCollectionView.mj_footer endRefreshing];
    }];

}
@end
