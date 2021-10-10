//
//  RecommendViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "RecommendViewController.h"
#import "HomeLiveCell.h"
#import "LivePlayerViewController.h"

@interface RecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *infoArray;
    int page;
    NSMutableArray *sliderArray;
}
@property (nonatomic,strong) UICollectionView *classCollectionView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    infoArray = [NSMutableArray array];
    page = 1;
    [self.view addSubview:self.classCollectionView];
    [self requestData];
}
- (UICollectionView *)classCollectionView{
    if (!_classCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
            flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake((_window_width-25)/2, (_window_width-25)/2 * 1.2 + 70);
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        flow.sectionInset = UIEdgeInsetsMake(5, 10,5, 10);
//        flow.headerReferenceSize = CGSizeMake(_window_width, _window_width*0.34);
        _classCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height-64-statusbarHeight-50-ShowDiff-48) collectionViewLayout:flow];
        [_classCollectionView registerNib:[UINib nibWithNibName:@"HomeLiveCell" bundle:nil] forCellWithReuseIdentifier:@"HomeLiveCELL"];

        _classCollectionView.delegate =self;
        _classCollectionView.dataSource = self;
        _classCollectionView.backgroundColor = RGB_COLOR(@"#ffffff", 1);
        _classCollectionView.mj_footer  = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        _classCollectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        if (@available(iOS 11.0, *)) {
            _classCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_classCollectionView addSubview:self.nothingImgView];
    }
    return _classCollectionView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.55)];
        _nothingImgView.image = [UIImage imageNamed:@"noLives"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"featured?page=%d",page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_classCollectionView.mj_header endRefreshing];
        [_classCollectionView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [infoArray removeAllObjects];
                NSArray *banner = [info valueForKey:@"banner"];
                NSArray *liveclass = [info valueForKey:@"liveclass"];

                if (self.block) {
                    self.block(banner,liveclass);
                }

            }
            NSArray *list = [info valueForKey:@"list"];
            for (NSDictionary *dic in list) {
                HomeLiveModel *model = [[HomeLiveModel alloc]initWithDic:dic];
                [infoArray addObject:model];
            }
            [_classCollectionView reloadData];
            if ([info count] < 20) {
                [_classCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if ([infoArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }
        }
        
    } Fail:^{
        [_classCollectionView.mj_header endRefreshing];
        [_classCollectionView.mj_footer endRefreshing];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return infoArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HomeLiveModel *model = infoArray[indexPath.row];
    [MBProgressHUD showMessage:@""];
    [[WYToolClass sharedInstance] removeSusPlayer];
    [self checkLive:model];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeLiveCell *cell = (HomeLiveCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeLiveCELL" forIndexPath:indexPath];
    cell.model = infoArray[indexPath.row];
    
    return cell;
}
- (void)checkLive:(HomeLiveModel *)model{
    [WYToolClass postNetworkWithUrl:@"live/check" andParameter:@{@"stream":model.stream} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            LivePlayerViewController *player = [[LivePlayerViewController alloc]init];
            player.roomDic = [model.originDic mutableCopy];
            [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
        }
    } fail:^{
        
    }];
}

#pragma mark ================ collectionview头视图 ===============

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecommendHeaderV" forIndexPath:indexPath];
//
//        header.backgroundColor = [UIColor whiteColor];
//        [header addSubview:self.collectionHeaderView];
//        return header;
//    }else{
//        return nil;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
