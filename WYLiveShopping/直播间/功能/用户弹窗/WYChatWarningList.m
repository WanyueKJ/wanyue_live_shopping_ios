//
//  WYChatWarningList.m
//  WYCity
//
//  Created by apple on 2020/6/30.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WYChatWarningList.h"
@interface WYWarningCell:UITableViewCell
+(instancetype)cellForTableView:(UITableView *)tableView;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UIView *line;

@end
@implementation WYWarningCell

+(instancetype)cellForTableView:(UITableView *)tableView{
    WYWarningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYWarningCell"];
    if (!cell) {
        cell = [[WYWarningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WYWarningCell"];
        [cell addSubview:cell.tipLabel];
        [cell addSubview:cell.line];
    }
    return cell;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, _window_width, 0.5)];
        _line.backgroundColor = Line_Cor;
    }
    return _line;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _window_width, self.height-0.5)];
        _tipLabel.textColor = RGB_COLOR(@"#646464", 1);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipLabel;
}
@end

@interface WYChatWarningList ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isWarningList;

@end
@implementation WYChatWarningList

- (instancetype)initWithFrame:(CGRect)frame  data:(nonnull NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        NSDictionary *dic = @{@"name":@"取消"};
        [self.dataArray addObject:dic];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.tableView];
        [self.tableView reloadData];
        
    }
    return self;
}
- (void)setList:(NSArray *)list {
    
}
#pragma mark -tableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYWarningCell *cell = [WYWarningCell cellForTableView:tableView];
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.tipLabel.text = minstr(dic[@"name"]);
        if (indexPath.row == self.dataArray.count-1) {
            cell.tipLabel.textColor = RGB_COLOR(@"#5074FA", 1);
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count-1) {
        [self removeFromSuperview];
        return;
    }
    NSDictionary *info = self.dataArray[indexPath.row];
        //禁言
    if ([self.delegate respondsToSelector:@selector(jinyanUser:name:jinyanID:)]) {
        [self.delegate jinyanUser:minstr(info[@"second"]) name:minstr(info[@"name"]) jinyanID:minstr(info[@"id"])];
    }
    [self removeFromSuperview];
}

#pragma mark - lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0,_titleLabel.bottom, _window_width, self.bgView.height-_titleLabel.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UIView *)bgView {
    if (!_bgView) {
        CGFloat height = 50+self.dataArray.count*50.0;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _window_height-height-ShowDiff, _window_width,height)];
        _bgView.layer.cornerRadius = 6;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, _window_width, 40)];
        _titleLabel.text = @"请选择禁言时间";
        _titleLabel.textColor = RGB_COLOR(@"#323232", 1);
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
@end
