//



#import "LiveOnlineList.h"
#import "BrowserRecordCell.h"
#import "userPopupView.h"
#import "chatModel.h"
@interface LiveOnlineList()<UITableViewDelegate,UITableViewDataSource,BrowserRecordCellDelegate,userPopupViewDeleagte>{
    int paging;
    NSString *anchorID;
    userPopupView *userPview;
    NSString *liveStream;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *line;
@end
@implementation LiveOnlineList

- (instancetype)initWithFrame:(CGRect)frame stream:(NSString *)stream liveUID:(NSString *)uid{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        anchorID = uid;
        liveStream = stream;
        paging = 1;
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.line];
        [self.bgView addSubview:self.tableView];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
- (void)requestData{
    NSString *postUrl = [NSString stringWithFormat:@"getuserlist?stream=%@&p=%d&liveuid=%@",liveStream,paging,anchorID];
    [WYToolClass getQCloudWithUrl:postUrl Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (code == 200) {
            NSArray *infoA = info;
            if (paging == 1) {
                [_dataArray removeAllObjects];
            }
            for (int i = 0; i<infoA.count; i++) {
                chatModel *model = [[chatModel alloc] initOnlineDic:infoA[i]];
                [_dataArray addObject:model];
            }
        
            if (infoA.count < 20) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    paging += 1;
                    [self requestData];
                }];
            }
        [self.tableView reloadData];
                   
        }else {
            [MBProgressHUD showError:msg];
        }
    } Fail:^{
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络请求失败"];
    }];
    
}

#pragma mark - delegate
- (void)userToast:(chatModel *)model{
    if ([model.userID isEqualToString:[Config getOwnID]]) {
       // [MBProgressHUD showError:@"自己不可以点击"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(showUserToast:)]) {
        [self.delegate showUserToast:model];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        [self removeFromSuperview];
    }
}

- (void)closeView{
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrowserRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserRecordCell"];
    cell.vc = self.vc;
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
         cell.model = self.dataArray[indexPath.row];
    }

    return cell;
}
#pragma mark-lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _line.bottom, self.bgView.width, self.bgView.height-_line.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BrowserRecordCell" bundle:nil] forCellReuseIdentifier:@"BrowserRecordCell"];
        _tableView.rowHeight = 70;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            paging = 1;
            [self requestData];
        }];
               
        
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
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _window_height-400, _window_width, 400)];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 40)];
        _titleLabel.text = @"在线观众";
        _titleLabel.textColor = RGB_COLOR(@"#323232", 1);
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, _window_width, 0.5)];
        _line.backgroundColor = RGB_COLOR(@"#eeeeee", 1);
    }
    return _line;
}

@end
