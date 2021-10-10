//
//  classGoodsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "classGoodsViewController.h"
#import "classGoodsHHHCell.h"
#import "recommendView.h"
#import "classGoodsVVVCell.h"
#import "GoodsDetailsViewController.h"
@interface classGoodsViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UITextField *searchTextF;
    NSMutableArray *dataArray;
    int page;
    UIButton *changeBtn;

    UIButton *priceBtn;
    NSString *priceOrder;
    UIButton *salesBtn;
    NSString *salesOrder;
    UIButton *newBtn;
    BOOL isVipPrice;
}
@property (nonatomic,strong) UICollectionView *goodsCollectionView;
@property (nonatomic,strong) recommendView *recommendV;

@end

@implementation classGoodsViewController
- (void)addSearchView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 50)];
    view.backgroundColor = normalColors;
    [self.view addSubview:view];
    searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, _window_width-65, 30)];
    searchTextF.font = SYS_Font(14);
    searchTextF.placeholder = @"搜索商品";
    searchTextF.delegate = self;
    searchTextF.leftViewMode = UITextFieldViewModeAlways;
    searchTextF.layer.cornerRadius = 15;
    searchTextF.layer.masksToBounds = YES;
    searchTextF.backgroundColor = RGB_COLOR(@"#ffffff", 1);
    searchTextF.returnKeyType = UIReturnKeySearch;
    searchTextF.text = _normalSearchStr;
    [view addSubview:searchTextF];
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 20, 20)];
    imgV.image = [UIImage imageNamed:@"搜索"];
    [leftV addSubview:imgV];
    searchTextF.leftView = leftV;

    changeBtn = [UIButton buttonWithType:0];
    [changeBtn setImage:[UIImage imageNamed:@"list_V"] forState:0];
    [changeBtn setImage:[UIImage imageNamed:@"list_H"] forState:UIControlStateSelected];
    changeBtn.frame = CGRectMake(searchTextF.right + 10, 10, 30, 30);
    [changeBtn addTarget:self action:@selector(changeListShow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:changeBtn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    page = 1;
    [self requestData];
    return YES;
}
- (void)changeListShow{
    changeBtn.selected = !changeBtn.selected;
    [_goodsCollectionView reloadData];
}
- (void)addBUttonView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight+50, _window_width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *array = @[_cate_name,@"价格",@"销量",@"新品"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(_window_width*0.25*i, 0, _window_width*0.25, 40);
        btn.tag = 1000 + i;
        [view addSubview:btn];
        if (i == 0) {
            if ([_cate_name isEqual:@"默认"]) {
                [btn setTitleColor:color32 forState:0];
            }else{
                [btn setTitleColor:normalColors forState:0];
            }
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        }else{
            [btn setTitleColor:color32 forState:0];
            btn.titleLabel.font = SYS_Font(12);
            if (i == 1 || i == 2) {
                CGRect rect = [array[i] boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : SYS_Font(12)} context:nil];
                [btn setImage:[UIImage imageNamed:@"list_nor"] forState:0];
                //button标题的偏移量，这个偏移量是相对于图片的
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-2.5, 0, btn.imageView.image.size.width+2.5);
                //button图片的偏移量，这个偏移量是相对于标题的
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);

                if (i == 1) {
                    priceBtn = btn;
                }else{
                    salesBtn = btn;
                }
            }else
            if (i == 3) {
                [btn setTitleColor:normalColors forState:UIControlStateSelected];
                newBtn = btn;
            }
        }
    }
}
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        [super doReturn];
    }else{
        if (sender == priceBtn) {
            if (salesOrder.length != 0) {
                salesOrder = @"";
                [salesBtn setImage:[UIImage imageNamed:@"list_nor"] forState:0];
            }
            if (priceOrder.length == 0) {
                priceOrder = @"desc";
                [priceBtn setImage:[UIImage imageNamed:@"list_top"] forState:0];
            }else if ([priceOrder isEqual:@"desc"]){
                priceOrder = @"asc";
                [priceBtn setImage:[UIImage imageNamed:@"list_down"] forState:0];
            }else{
                priceOrder = @"";
                [priceBtn setImage:[UIImage imageNamed:@"list_nor"] forState:0];
            }
        }else if (sender == salesBtn){
            if (priceOrder.length != 0) {
                priceOrder = @"";
                [priceBtn setImage:[UIImage imageNamed:@"list_nor"] forState:0];
            }
            if (salesOrder.length == 0) {
                salesOrder = @"desc";
                [salesBtn setImage:[UIImage imageNamed:@"list_top"] forState:0];
            }else if ([salesOrder isEqual:@"desc"]){
                salesOrder = @"asc";
                [salesBtn setImage:[UIImage imageNamed:@"list_down"] forState:0];
            }else{
                salesOrder = @"";
                [salesBtn setImage:[UIImage imageNamed:@"list_nor"] forState:0];
            }

        }else{
            newBtn.selected = !newBtn.selected;
        }
        page = 1;
        [self requestData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"商品列表";
    self.titleL.textColor = [UIColor whiteColor];
    self.returnBtn.selected = YES;
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = normalColors;
    dataArray = [NSMutableArray array];
    page = 1;
    priceOrder = @"";
    salesOrder = @"";
    [self addSearchView];
    [self addBUttonView];
    [self.view addSubview:self.goodsCollectionView];
    [self requestData];
}
-(UICollectionView *)goodsCollectionView{
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        _goodsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight+90, _window_width, _window_height-(64+statusbarHeight+90)) collectionViewLayout:flow];
        [_goodsCollectionView registerNib:[UINib nibWithNibName:@"classGoodsVVVCell" bundle:nil] forCellWithReuseIdentifier:@"classGoodsVVVCELL"];
        [_goodsCollectionView registerNib:[UINib nibWithNibName:@"classGoodsHHHCell" bundle:nil] forCellWithReuseIdentifier:@"classGoodsHHHCELL"];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.backgroundColor = colorf0;
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
-(recommendView *)recommendV{
    if (!_recommendV) {
        _recommendV = [[recommendView alloc]initWithFrame:_goodsCollectionView.frame andNothingImage:[UIImage imageNamed:@"noShopper"]];
    }
    return _recommendV;
}

- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"products?page=%d&cid=%@&sid=%@&keyword=%@&priceOrder=%@&salesOrder=%@&news=%d",page,_cid,_sid,searchTextF.text,priceOrder,salesOrder,newBtn.selected] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_goodsCollectionView.mj_header endRefreshing];
        [_goodsCollectionView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                model.isAdmin = YES;
                model.is_sale = @"0";
                if (model.vip_price.length > 0) {
                    isVipPrice = YES;
                }
                [dataArray addObject:model];
            }
            
            [_goodsCollectionView reloadData];
            if (dataArray.count == 0) {
                _goodsCollectionView.hidden = YES;
                if (_recommendV) {
                    _recommendV.hidden = NO;
                }else{
                    [self.view addSubview:self.recommendV];
                }
            }else{
                if ([info count] < 20) {
                    [_goodsCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                _goodsCollectionView.hidden = NO;
                if (_recommendV) {
                    _recommendV.hidden = YES;
                }
            }
        }
    } Fail:^{
        [_goodsCollectionView.mj_header endRefreshing];
        [_goodsCollectionView.mj_footer endRefreshing];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    liveGoodsModel *model = dataArray[indexPath.row];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    vc.goodsID = model.goodsID;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (changeBtn.selected) {
        classGoodsHHHCell *cell = (classGoodsHHHCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classGoodsHHHCELL" forIndexPath:indexPath];
        cell.model = dataArray[indexPath.row];
        return cell;

    }else{
        classGoodsVVVCell *cell = (classGoodsVVVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classGoodsVVVCELL" forIndexPath:indexPath];
        cell.model = dataArray[indexPath.row];
        return cell;
    }
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (changeBtn.selected) {
        return CGSizeMake(_window_width, 110);
    }else{
        if (isVipPrice) {
            return CGSizeMake((_window_width-40)/2, (_window_width-40)/2+84);
        }else{
            return CGSizeMake((_window_width-40)/2, (_window_width-40)/2+74);
        }
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (changeBtn.selected) {
        return UIEdgeInsetsMake(0,0,0,0);
    }else{
        return UIEdgeInsetsMake(10,15,10,15);
    }
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (changeBtn.selected) {
        return 0;
    }else{
        return 10;
    }
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (changeBtn.selected) {
        return 0;
    }else{
        return 10;
    }
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
