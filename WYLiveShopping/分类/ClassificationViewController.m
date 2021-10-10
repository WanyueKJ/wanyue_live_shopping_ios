//
//  ClassificationViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ClassificationViewController.h"
#import "classGoodsCell.h"
#import "classGoodsTableCell.h"
#import "classGoodsViewController.h"

@interface classHeaderView : UICollectionReusableView
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation classHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addShowView{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = color32;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(80);
    }];
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = color32;
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(1);
        make.right.equalTo(_titleLabel.mas_left);
        make.width.equalTo(self).multipliedBy(0.25);
    }];
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = color32;
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.equalTo(_titleLabel.mas_right);
        make.width.equalTo(self).multipliedBy(0.25);
    }];

}
@end

@interface ClassificationViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    NSArray *classArray;
    NSInteger selectTableIndex;
    BOOL isClickLeft;
    UITextField *searchTextF;
}
@property (nonatomic,strong) UITableView *classTableView;
@property (nonatomic,strong) UICollectionView *classCollectionView;

@end

@implementation ClassificationViewController
- (void)addSearchView{
    UIView *navi =[[UIView alloc]initWithFrame:CGRectMake(0, 64 + statusbarHeight, _window_width, 50)];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];

//    UIButton *searchBtn = [UIButton buttonWithType:0];
//    [searchBtn setImage:[UIImage imageNamed:@"home_search"] forState:0];
//    [searchBtn setTitle:@"  搜索商品" forState:0];
//    [searchBtn setTitleColor:RGB_COLOR(@"#b4b4b4", 1) forState:0];
//    searchBtn.titleLabel.font = SYS_Font(14);
//    [searchBtn setBackgroundColor:RGB_COLOR(@"#F5F5F5", 1)];
//    searchBtn.layer.cornerRadius = 15;
//    searchBtn.layer.masksToBounds = YES;
//    [searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
//    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [navi addSubview:searchBtn];
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(navi).offset(15);
//        make.right.equalTo(navi).offset(-15);
//        make.centerY.equalTo(navi);
//        make.height.mas_equalTo(30);
//    }];
    searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, _window_width-65, 30)];
    searchTextF.font = SYS_Font(14);
    searchTextF.placeholder = @"搜索商品";
    searchTextF.delegate = self;
    searchTextF.leftViewMode = UITextFieldViewModeAlways;
    searchTextF.layer.cornerRadius = 15;
    searchTextF.layer.masksToBounds = YES;
    searchTextF.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    searchTextF.returnKeyType = UIReturnKeySearch;
    [navi addSubview:searchTextF];
    [searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navi).offset(15);
        make.right.equalTo(navi).offset(-15);
        make.centerY.equalTo(navi);
        make.height.mas_equalTo(30);
    }];

    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 20, 20)];
    imgV.image = [UIImage imageNamed:@"搜索"];
    [leftV addSubview:imgV];
    searchTextF.leftView = leftV;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        classGoodsViewController *vc = [[classGoodsViewController alloc]init];
        vc.cid = @"";
        vc.sid = @"";
        vc.cate_name = @"默认";
        vc.normalSearchStr = textField.text;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }
    return YES;
}
- (void)doSearch{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.returnBtn.hidden = YES;
    self.titleL.text = @"商品分类";
    selectTableIndex = 0;
    [self addSearchView];
    [self.view addSubview:self.classTableView];
    [self.view addSubview:self.classCollectionView];
    [self requestData];
}
- (UITableView *)classTableView{
    if (!_classTableView) {
        _classTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+50+statusbarHeight, 110, _window_height-(64+44+statusbarHeight + ShowDiff + 48) ) style:0];
        _classTableView.delegate = self;
        _classTableView.dataSource = self;
        _classTableView.separatorStyle = 0;
        _classTableView.backgroundColor = colorf0;
    }
    return _classTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    classGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classGoodsTableCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"classGoodsTableCell" owner:nil options:nil] lastObject];
        [cell.titleBtn setBackgroundImage:[WYToolClass getImgWithColor:colorf0] forState:0];
        [cell.titleBtn setBackgroundImage:[WYToolClass getImgWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    }
    NSDictionary *dic = classArray[indexPath.row];
    [cell.titleBtn setTitle:minstr([dic valueForKey:@"cate_name"]) forState:0];
    if (indexPath.row == selectTableIndex) {
        cell.titleBtn.selected = YES;
    }else{
        cell.titleBtn.selected = NO;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != selectTableIndex) {
        //判断滑动是不是因为点击一级分类引起
        isClickLeft = YES;
        selectTableIndex = indexPath.row;
        [tableView reloadData];
        [_classCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectTableIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        ///让collectionview的滑动回退sectionheader的高度
        _classCollectionView.contentOffset = CGPointMake(0, _classCollectionView.contentOffset.y-70);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isClickLeft = NO;
        });
    }
}
- (UICollectionView *)classCollectionView{
    if (!_classCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake((_window_width-110)/3-0.1, (_window_width-110)/3-0.1);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.headerReferenceSize = CGSizeMake(_window_width-110, 50);
        flow.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
        _classCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(110,_classTableView.top, _window_width-110, _classTableView.height) collectionViewLayout:flow];
        [_classCollectionView registerNib:[UINib nibWithNibName:@"classGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"classGoodsCELL"];
        [_classCollectionView registerClass:[classHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classHeaderV"];
        _classCollectionView.delegate =self;
        _classCollectionView.dataSource = self;
        _classCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _classCollectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return classArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = [classArray[section] valueForKey:@"children"];
    return array.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary *oneDic = classArray[indexPath.section];
    NSDictionary *twoDic = [oneDic valueForKey:@"children"][indexPath.row];
    classGoodsViewController *vc = [[classGoodsViewController alloc]init];
    vc.cid = minstr([oneDic valueForKey:@"id"]);
    vc.sid = minstr([twoDic valueForKey:@"id"]);
    vc.cate_name = minstr([twoDic valueForKey:@"cate_name"]);
    vc.normalSearchStr = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    classGoodsCell *cell = (classGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classGoodsCELL" forIndexPath:indexPath];
    NSArray *array = [classArray[indexPath.section] valueForKey:@"children"];
    NSDictionary *dic = array[indexPath.row];
    [cell.thumbImgView sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"pic"])]];
    cell.nameL.text = minstr([dic valueForKey:@"cate_name"]);
    return cell;
}

#pragma mark ================ collectionview头视图 ===============

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        classHeaderView *header = (classHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classHeaderV" forIndexPath:indexPath];
        if (!header.titleLabel) {
            [header addShowView];
        }
        NSDictionary *dic = classArray[indexPath.section];
        header.titleLabel.text = minstr([dic valueForKey:@"cate_name"]);
        
        return header;
    }else{
        return nil;
    }
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView == _classCollectionView) {
//        NSArray *array = [_classCollectionView visibleCells];
//        NSLog(@"%ld",array.count);
//        if (array.count > 0) {
//            UICollectionViewCell *cell = [array firstObject];
//            NSIndexPath *indexPath = [_classCollectionView indexPathForCell:cell];
//            selectTableIndex = indexPath.section;
//            [_classTableView reloadData];
//        }
//    }
//}
///collectionview将要加载头尾视图调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (isClickLeft) {
        return;
    }
    CGPoint point = [view convertPoint:CGPointZero toView:self.view];
    ///判断是不是SectionHeader
    if (point.y < 100 && [elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        ///更新当前选中的一级分类的indexpath
        selectTableIndex = indexPath.section;
        [_classTableView reloadData];
    }
}
///collectionview已经加载完头尾视图调用的方法

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (isClickLeft) {
        return;
    }
    CGPoint point = [view convertPoint:CGPointZero toView:self.view];
    ///判断是不是SectionHeader
    if (point.y < 100 && [elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        ///更新当前选中的一级分类的indexpath
        selectTableIndex = indexPath.section;
        [_classTableView reloadData];
    }
}

- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"category" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        classArray = info;
        [_classTableView reloadData];
        [_classCollectionView reloadData];
    } Fail:^{
        
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
