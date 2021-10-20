//
//  LivePlayerViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/18.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "socketLive.h"
#import <TXLiteAVSDK.h>
#import <TXLiteAVSDK_Smart/TXLivePlayer.h>
#import "chatMsgCell.h"
#import "anchorMessageView.h"
#import "shareView.h"
#import "expensiveGiftV.h"
#import "continueGift.h"
#import "userMoreView.h"
#import "jubaoVC.h"
#import "WYGiftListView.h"
#import "LiveOnlineList.h"
#import "userPopupView.h"
#import "RechargeViewController.h"
@interface LivePlayerViewController ()<UITextViewDelegate,socketLiveDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,haohuadelegate,TXLivePlayListener,anchorMessageViewDelegate,WYGiftListViewDelegate,LiveOnlineListDelegate,userPopupViewDeleagte>{
    //关注按钮
    UIButton *attionBtn;
    //直播间按钮
    UIButton *closeRoomBtn;//关闭直播间按钮
    UIButton *chatBtn;//聊天按钮
    UIButton *moreBtn;//更多功能按钮
    UIButton *likeBtn;
    UIButton *shareBtn;
    UIButton *giftBtn;
    UILabel *likesNumLabel;//点赞数
    UILabel *userNumLabel;//直播间人数
    //用户弹窗
    userPopupView *userPview;
    //定时请求直播间人数点赞数
    NSTimer *reloadTimer;
    //已卖出商品数量
    UILabel *sellerGoodsNumsLabel;
    //分享视图
    shareView *shareV;
    //连送礼物效果展示view
    UIView *liansongliwubottomview;//连送礼物底部view
    continueGift *continueGifts;//连送礼物
    expensiveGiftV *haohualiwuV;//豪华礼物
    NSString *usertype;
    //是否被禁言
    BOOL isShutUp;
    //主播信息弹窗
    anchorMessageView *anchorMsgV;
    LiveOnlineList *onlineList;//在线用户列表
    ///第一次点亮
    BOOL isLight;
    ///用户更多操作
    userMoreView *moreView;
    
    CGSize videoSize;
    WYGiftListView *giftview;//礼物界面
    
}
/// 预览视图
@property (nonatomic,strong) UIView *playBackView;
@property (nonatomic,strong) UIImageView *thumbImgView;

/// 推流地址
@property (nonatomic,strong) NSString *hostURL;
@property (nonatomic,strong)    TXLivePlayer *       txLivePlayer;
@property (nonatomic,strong)    TXLivePlayConfig*    config;

/// socket
@property (nonatomic,strong) socketLive *socketL;
///直播界面视图父view
@property (nonatomic,strong) UIView *frontView;
///聊天展示tableview
@property (nonatomic,strong) UITableView *chatTableView;
///聊天信息数组
@property (nonatomic,strong) NSMutableArray *chatArray;
///直播间打字聊天输入框
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UITextField *inputTextView;


@end

@implementation LivePlayerViewController
-(void)viewWillAppear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [_txLivePlayer resume];
    [[WYToolClass sharedInstance] removeSusPlayer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [_txLivePlayer pause];
    [[WYToolClass sharedInstance] showSusPlayer:_roomDic andVideoSize:videoSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化一些基本信息
    [self chushihua];
    //注册通知
    [self nsnotifition];

    //创建预览视图
    [self creatPlayerView];
    [self setView];
    [self enterRoom];
}
- (void)chushihua{
    isLight = NO;
    _chatArray = [NSMutableArray array];
    
}
-(void)nsnotifition{
    //注册进入后台的处理
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [notification addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)creatPlayerView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doLight)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    _playBackView = [[UIView alloc] init];
    _playBackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playBackView];
    _playBackView.frame = CGRectMake(0,0, _window_width, _window_height);
    
    _thumbImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:minstr([_roomDic valueForKey:@"thumb"])]];
    _thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
    [_playBackView addSubview:_thumbImgView];
    _hostURL = minstr([_roomDic valueForKey:@"pull"]);
    _config = [[TXLivePlayConfig alloc] init];
    //_config.enableAEC = YES;
    //自动模式
    _config.bAutoAdjustCacheTime   = YES;
    _config.minAutoAdjustCacheTime = 1;
    _config.maxAutoAdjustCacheTime = 5;
    _txLivePlayer =[[TXLivePlayer alloc] init];
    _txLivePlayer.enableHWAcceleration = YES;
    [_txLivePlayer setupVideoWidget:_playBackView.bounds containView:_playBackView insertIndex:0];
    [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    [_txLivePlayer setConfig:_config];
    
    
    if(_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = self;
        NSInteger _playType = 0;
        if ([_hostURL hasPrefix:@"rtmp:"]) {
            _playType = PLAY_TYPE_LIVE_RTMP;
        } else if (([_hostURL hasPrefix:@"https:"] || [_hostURL hasPrefix:@"http:"]) && [_hostURL rangeOfString:@".flv"].length > 0) {
            _playType = PLAY_TYPE_LIVE_FLV;
        }
        else{
            
        }
        if ([_hostURL rangeOfString:@".mp4"].length > 0) {
            _playType = PLAY_TYPE_VOD_MP4;
        }
        if ([_hostURL rangeOfString:@".m3u8"].length > 0) {
            _playType = PLAY_TYPE_VOD_FLV;
        }

        int result = [_txLivePlayer startPlay:_hostURL type:_playType];
        NSLog(@"wangminxin%d",result);
        if (result == -1)
        {
            
        }
        if( result != 0)
        {
            [MBProgressHUD showError:@"视频流播放失败"];
//            [self lastView];
        }
        if( result == 0){
            NSLog(@"播放视频");

        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }

}
//播放监听事件
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
//    NSLog(@"eventID:%d===%@",EvtID,param);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            NSLog(@"moviplay不连麦已经连接服务器");
        }
        else if (EvtID == PLAY_EVT_RTMP_STREAM_BEGIN){
            NSLog(@"moviplay不连麦已经连接服务器，开始拉流");
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN){
            NSLog(@"moviplay不连麦视频播放开始");
            dispatch_async(dispatch_get_main_queue(), ^{
                _thumbImgView.hidden = YES;
            });
        }
        else if (EvtID== PLAY_WARNING_VIDEO_PLAY_LAG){
            NSLog(@"moviplay不连麦当前视频播放出现卡顿（用户直观感受）");
        }
        else if (EvtID == PLAY_EVT_PLAY_END){
            NSLog(@"moviplay不连麦视频播放结束");
            [_txLivePlayer resume];
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            //视频播放结束
            NSLog(@"moviplay不连麦网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
        }else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            NSLog(@"主播连麦分辨率改变");
            CGFloat width = [minstr ([param valueForKey:@"EVT_PARAM1"]) floatValue];
            CGFloat height = [minstr ([param valueForKey:@"EVT_PARAM2"]) floatValue];
            videoSize = CGSizeMake(width, height);
        }
    });
}
-(void)onNetStatus:(NSDictionary *)param{
    
    
}

//创建直播间视图按钮
- (void)setView{
    _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _frontView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_frontView];

    [self addLeftView];
    closeRoomBtn = [UIButton buttonWithType:0];
    [closeRoomBtn setImage:[UIImage imageNamed:@"live_关闭"] forState:0];
    [closeRoomBtn addTarget:self action:@selector(showCloseAlert) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:closeRoomBtn];
    [closeRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frontView).offset(27+statusbarHeight);
        make.right.equalTo(_frontView).offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    userNumLabel = [[UILabel alloc]init];
    userNumLabel.font = SYS_Font(10);
    userNumLabel.textColor = [UIColor whiteColor];
    userNumLabel.textAlignment = NSTextAlignmentCenter;
    userNumLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    userNumLabel.text = @"  0人  ";
    userNumLabel.layer.cornerRadius = 15;
    userNumLabel.layer.masksToBounds = YES;
    userNumLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOnlineList)];
    [userNumLabel addGestureRecognizer:tap];
    [_frontView addSubview:userNumLabel];
    [userNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeRoomBtn.mas_left).offset(-10);
        make.centerY.height.equalTo(closeRoomBtn);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    
    likeBtn = [UIButton buttonWithType:0];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"live_点亮"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(doLight) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_frontView).offset(-10-ShowDiff);
        make.right.equalTo(_frontView).offset(-10);
        make.width.height.mas_equalTo(36);
    }];

    shareBtn = [UIButton buttonWithType:0];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"live_分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(likeBtn);
        make.right.equalTo(likeBtn.mas_left).offset(-10);
        make.width.height.mas_equalTo(36);
    }];

    moreBtn = [UIButton buttonWithType:0];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"功能"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"功能_s"] forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(showmoreview) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(likeBtn);
        make.right.equalTo(shareBtn.mas_left).offset(-10);
        make.width.height.mas_equalTo(36);
    }];
    
    giftBtn = [UIButton buttonWithType:0];
    [giftBtn setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];
    [giftBtn addTarget:self action:@selector(doShowGiftView) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:giftBtn];
    [giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(likeBtn);
        make.right.equalTo(moreBtn.mas_left).offset(-10);
        make.width.height.mas_equalTo(36);
    }];

    chatBtn = [UIButton buttonWithType:0];
    [chatBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    [chatBtn addTarget:self action:@selector(showToolbarView) forControlEvents:UIControlEventTouchUpInside];
    [chatBtn setTitle:@"  说点什么..." forState:0];
    chatBtn.titleLabel.font = SYS_Font(14);
    chatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    chatBtn.layer.cornerRadius = 18;
    chatBtn.layer.masksToBounds = YES;
    [_frontView addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_frontView).offset(10);
        make.bottom.equalTo(likeBtn);
        make.height.mas_equalTo(36);
        make.right.equalTo(giftBtn.mas_left).offset(-10);
    }];

    [_frontView addSubview:self.chatTableView];
    [_chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_frontView).offset(10);
        make.width.equalTo(_frontView).multipliedBy(0.7);
        make.height.mas_equalTo(190);
        make.bottom.equalTo(chatBtn.mas_top).offset(-35);
    }];
    liansongliwubottomview = [[UIView alloc]init];
    [_frontView addSubview:liansongliwubottomview];
    [liansongliwubottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_frontView);
        make.bottom.equalTo(_chatTableView.mas_top).offset(-10);
        make.width.mas_equalTo(_window_width/2);
        make.height.mas_equalTo(140);
    }];

    [self.view addSubview:self.toolView];
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reloadRoomMessage) userInfo:nil repeats:YES];

}
-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, 50)];
        _toolView.backgroundColor = [UIColor whiteColor];
        _inputTextView = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, _window_width-20, 36)];
        _inputTextView.font = SYS_Font(14);
        _inputTextView.placeholder = @"说点什么...";
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.cornerRadius = 18;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.leftViewMode = UITextFieldViewModeAlways;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 36)];
        _inputTextView.leftView = view;
        _inputTextView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
        [_toolView addSubview:_inputTextView];
    }
    return _toolView;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (isShutUp) {
        [MBProgressHUD showError:@"你已被禁言"];
        [textField resignFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        [_socketL sendMessage:textField.text andisAtt:minstr([_roomDic valueForKey:@"isattent"]) userType:usertype];
        textField.text = @"";
    }
    return YES;
}
-(UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.showsVerticalScrollIndicator = NO;
        _chatTableView.estimatedRowHeight = 80.0;
        _chatTableView.clipsToBounds = YES;

    }
    return _chatTableView;;
}
#pragma mark -- tableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chatArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"chatMsgCell" owner:nil options:nil] lastObject];
    }
    
    chatModel *models = _chatArray[indexPath.row];

    cell.model =models;
    
    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatModel *model = _chatArray[indexPath.row];
    //&& ![model.userID isEqual:[Config getOwnID]]
    if (model.userID && model.userID.length > 0 ) {
        [self showUserPopupView:model isonline:NO];
    }
}
#pragma mark - 在线列表
- (void)showOnlineList{
    if (!onlineList) {
        onlineList = [[LiveOnlineList alloc] initWithFrame:CGRectMake(0, 0, _window_width, _window_height) stream:_roomDic[@"stream"] liveUID:_roomDic[@"uid"]];
        onlineList.delegate = self;
    }
    [onlineList requestData];
    [self.view addSubview:onlineList];
}
//delegate
- (void)showUserToast:(chatModel *)model {
    [self showUserPopupView:model isonline:YES];
}
#pragma mark -- 用户弹窗相关
- (void)showUserPopupView:(chatModel *)model isonline:(BOOL)isOnline{
    if (userPview) {
        [userPview removeFromSuperview];
        userPview = nil;
    }
    userPview = [[userPopupView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andModel:model liveUid:_roomDic[@"uid"]];
    userPview.delegate = self;
    userPview.isOnlineUser = isOnline;
    [self.view addSubview:userPview];
}
- (void)removeUserPopupView{
    [userPview removeFromSuperview];
    userPview = nil;
}
- (void)doShutupUser:(NSString *)userID andUserName:(NSString *)uname content:(nonnull NSString *)content{
    [_socketL shutUpUser:userID andName:uname andAction:@"1" content:content];
}
-(void)doKickUser:(NSString *)userID andUserName:(NSString *)uname{
    [_socketL kickUser:userID andName:uname];
}
- (void)doCancleShutupUser:(NSString *)userID andUserName:(NSString *)uname{
    NSString *content = [NSString stringWithFormat:@"%@被解除禁言",uname];
    [_socketL shutUpUser:userID andName:uname andAction:@"2" content:content];
}
- (void)setAdminUser:(NSString *)userID andUserName:(NSString *)uname{
    [_socketL setAdmin:userID andName:uname];
}
-(void)cancelAdminUser:(NSString *)userID andUserName:(NSString *)uname{
    [_socketL cancelSetAdmin:userID andName:uname];
}

- (void)doShowAnchorView{
    if (!anchorMsgV) {
        
        anchorMsgV = [[[NSBundle mainBundle] loadNibNamed:@"anchorMessageView" owner:nil options:nil] lastObject];
        anchorMsgV.frame = CGRectMake(0, 0, _window_width, _window_height);
        [anchorMsgV.followBtn setBackgroundImage:[WYToolClass getImgWithColor:normalColors] forState:0];
        [anchorMsgV.followBtn setBackgroundImage:[WYToolClass getImgWithColor:RGB_COLOR(@"#f2edeb", 1)] forState:UIControlStateSelected];
        [anchorMsgV.iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([_roomDic valueForKey:@"avatar"])]];
        anchorMsgV.nameLabel.text = minstr([_roomDic valueForKey:@"nickname"]);
        anchorMsgV.IDLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([_roomDic valueForKey:@"uid"])];
        anchorMsgV.delegate = self;
        [self.view addSubview:anchorMsgV];
        WeakSelf;
        anchorMsgV.block = ^(BOOL isFollow) {
            [weakSelf reloadAttionButton:isFollow];
        };
    }
    anchorMsgV.followBtn.selected = [minstr([_roomDic valueForKey:@"isattent"]) intValue];
    [anchorMsgV requestMessage:minstr([_roomDic valueForKey:@"uid"])];
    anchorMsgV.hidden = NO;
}
#pragma mark- 关闭直播
- (void)closeLive{
    [WYToolClass postNetworkWithUrl:@"supershut" andParameter:@{@"liveuid":_roomDic[@"uid"],@"stream":minstr([_roomDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [_socketL superAdminCloseLive];
        }
    } fail:^{
        
    }];
   
}
//直播间左上角视图
- (void)addLeftView{
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    leftView.layer.cornerRadius = 17;
    [_frontView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_frontView).offset(10);
        make.top.equalTo(_frontView).offset(25+statusbarHeight);
        make.height.mas_equalTo(34);
    }];
    UIButton *iconButton = [UIButton buttonWithType:0];
    iconButton.layer.cornerRadius = 15;
    iconButton.layer.masksToBounds = YES;
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [iconButton sd_setImageWithURL:[NSURL URLWithString:minstr([_roomDic valueForKey:@"avatar"])] forState:0];
    [iconButton addTarget:self action:@selector(doShowAnchorView) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(leftView).offset(2);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.font = SYS_Font(14);
    nameL.textColor = [UIColor whiteColor];
    nameL.text = minstr([_roomDic valueForKey:@"nickname"]);
    [leftView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconButton).offset(3);
        make.left.equalTo(iconButton.mas_right).offset(4);
        make.right.lessThanOrEqualTo(leftView).offset(-14);
    }];
    
    UIImageView *likeImgView = [[UIImageView alloc]init];
    likeImgView.image = [UIImage imageNamed:@"likeImage"];
    likeImgView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:likeImgView];
    [likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.width.height.mas_equalTo(9);
        make.bottom.equalTo(iconButton).offset(-1);
    }];
    likesNumLabel = [[UILabel alloc]init];
    likesNumLabel.font = SYS_Font(10);
    likesNumLabel.textColor = [UIColor whiteColor];
    likesNumLabel.text = @"0";
    [leftView addSubview:likesNumLabel];
    [likesNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeImgView);
        make.left.equalTo(likeImgView.mas_right).offset(4);
        make.right.lessThanOrEqualTo(leftView).offset(-14);
    }];
    
    attionBtn  = [UIButton buttonWithType:0];
    [attionBtn setBackgroundColor:normalColors];
    [attionBtn setTitle:@"关注" forState:0];
    attionBtn.titleLabel.font = SYS_Font(10);
    attionBtn.layer.cornerRadius = 12;
    attionBtn.layer.masksToBounds = YES;
    [attionBtn addTarget:self action:@selector(doFollow) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:attionBtn];
    [attionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(leftView);
        make.right.equalTo(leftView).offset(-5);
        make.left.greaterThanOrEqualTo(nameL.mas_right).offset(5);
        make.left.greaterThanOrEqualTo(likesNumLabel.mas_right).offset(5);
    }];
    
    UIView *sellerGoodsNumsView = [[UIView alloc]init];
    sellerGoodsNumsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    sellerGoodsNumsView.layer.cornerRadius = 11;
    [_frontView addSubview:sellerGoodsNumsView];
    [sellerGoodsNumsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.top.equalTo(leftView.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
    }];
    UILabel *sellerTipsL = [[UILabel alloc]init];
    sellerTipsL.font = SYS_Font(10);
    sellerTipsL.textColor = [UIColor whiteColor];
    sellerTipsL.text = @"本场销售商品：";
    [sellerGoodsNumsView addSubview:sellerTipsL];
    [sellerTipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sellerGoodsNumsView);
        make.left.equalTo(sellerGoodsNumsView).offset(10);
    }];

    sellerGoodsNumsLabel = [[UILabel alloc]init];
    sellerGoodsNumsLabel.font = SYS_Font(10);
    sellerGoodsNumsLabel.textColor = normalColors;
    sellerGoodsNumsLabel.text = @"0";
    [sellerGoodsNumsView addSubview:sellerGoodsNumsLabel];
    [sellerGoodsNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sellerGoodsNumsView);
        make.left.equalTo(sellerTipsL.mas_right);
        make.right.lessThanOrEqualTo(sellerGoodsNumsView).offset(-10);
    }];

}
- (void)reloadAttionButton:(BOOL)isAtt{
    [_roomDic setValue:[NSString stringWithFormat:@"%d",isAtt] forKey:@"isattent"];
    [UIView animateWithDuration:0.1 animations:^{
        [attionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(isAtt?0:33);
        }];
    }];
}
#pragma mark -- 关闭直播
- (void)showCloseAlert{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:@"确定退出直播吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doReturn];
    }];
    [sureAction setValue:normalColors forKey:@"_titleTextColor"];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];

}
#pragma mark -- 分享
- (void)doShare{
    if (!shareV) {
        shareV = [[shareView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andRoomMessage:_roomDic];
        [self.view addSubview:shareV];
    }else{
        [shareV show];
    }
}

#pragma mark -- 展示输入框
- (void)showToolbarView{
    if (moreView) {
        moreView.hidden = YES;
        moreBtn.selected = NO;
    }
    [_inputTextView becomeFirstResponder];
}
- (void)jumpLast{
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatArray.count-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
#pragma mark -- 底部更多按钮点击
- (void)showmoreview{
    if (!moreView) {
        moreView = [[userMoreView alloc]initWithFrame:CGRectMake(moreBtn.centerX-30, moreBtn.top-40, 60, 34)];
        WeakSelf;
        moreView.block = ^(NSString * _Nonnull name) {
            if ([name isEqual:@"举报"]) {
                [weakSelf doJubao];
            }
            moreView.hidden = YES;
            moreBtn.selected = NO;
        };
        [self.view addSubview:moreView];
    }else{
        if (moreView.hidden) {
            moreView.hidden = NO;
            moreBtn.selected = YES;
        }else{
            moreView.hidden = YES;
            moreBtn.selected = NO;

        }
    }
    

}
- (void)doJubao{
    jubaoVC *vc = [[jubaoVC alloc]init];
    vc.liveuid = minstr([_roomDic valueForKey:@"uid"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
#pragma mark -- 键盘通知
- (void)keyboardWillShow:(NSNotification *)aNotification
{

    [self hideBTN];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    WeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.toolView.y = height-50;
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self showBTN];
    WeakSelf;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.toolView.y = _window_height;
    }];
}
//展示底部按钮
- (void)showBTN{
    closeRoomBtn.hidden = NO;
    userNumLabel.hidden = NO;
    chatBtn.hidden = NO;
    moreBtn.hidden = NO;
    likeBtn.hidden = NO;
    giftBtn.hidden = NO;
    shareBtn.hidden = NO;
}
//隐藏底部按钮
- (void)hideBTN{
    closeRoomBtn.hidden = YES;
    userNumLabel.hidden = YES;
    chatBtn.hidden = YES;
    moreBtn.hidden = YES;
    likeBtn.hidden = YES;
    giftBtn.hidden = YES;
    shareBtn.hidden = YES;
}
#pragma mark -- 展示礼物页面
- (void)doShowGiftView{
    if (!giftview) {
        //礼物弹窗
        CGFloat height = _window_width/2+65+40+ShowDiff;
        giftview = [[WYGiftListView alloc]initWithFrame:CGRectMake(0, _window_height-height, _window_width, height) andZhuboMsg:self.roomDic];
        giftview.delegate = self;
        
    }else{
        [giftview chongzhiV:[Config getNowIcon]];
    }
    //giftview.guradType = minstr([guardInfo valueForKey:@"type"]);
    [self.view addSubview:giftview];
    [self.view bringSubviewToFront:giftview];
}
#pragma gift delegate
//发送礼物
-(void)sendGift:(NSDictionary *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa{
   // haohualiwu = lianfa;
    NSString *info = [datas  valueForKey:@"gifttoken"];
    //level = [[datas firstObject] valueForKey:@"level"];
//    LiveUser *users = [Config myProfile];
//    
//    [Config updateProfile:users];
    [_socketL sendGiftAndINfo:info andlianfa:lianfa];
}
- (void)pushCoinV{
    RechargeViewController *rechargeVC = [RechargeViewController new];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

#pragma mark -- 送礼物效果
-(void)sendGift:(NSDictionary *)msg andLiansong:(NSString *)liansong andTotalCoin:(NSString *)votestotal andGiftInfo:(NSDictionary *)giftInfo andCt:(NSDictionary *)ct{
    NSString *type = minstr([ct valueForKey:@"type"]);
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:ct];
    [muDic setObject:msg[@"uhead"] forKey:@"avatar"];
    [muDic setObject:giftInfo[@"nicename"] forKey:@"nicename"];
    if ([type isEqual:@"1"]) {
        [self expensiveGift:muDic.copy isPlatGift:NO];
    }else{
        if (!continueGifts) {
            continueGifts = [[continueGift alloc]init];
            [liansongliwubottomview addSubview:continueGifts];
            //初始化礼物空位
            [continueGifts initGift];
        }
        [continueGifts GiftPopView:muDic.copy andLianSong:liansong];
    }
}

-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]initWithIsPlat:NO];
        haohualiwuV.delegate = self;
        [self.view addSubview:haohualiwuV];
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
    }
    if (giftData == nil) {
        
        
        
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive:NO];
    }
}
-(void)expensiveGift:(NSDictionary *)giftData isPlatGift:(BOOL)isPlat{
    
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc] initWithIsPlat:isPlat];
        haohualiwuV.delegate = self;
        [self.view addSubview:haohualiwuV];
    }
    if (giftData == nil) {
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive:isPlat];
    }
}
#pragma mark -- 进入直播间enterroom

- (void)enterRoom{
    [WYToolClass postNetworkWithUrl:@"live/enter" andParameter:@{@"stream":minstr([_roomDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [_roomDic addEntriesFromDictionary:info];
            [_roomDic setObject:minstr([info valueForKey:@"liveuid"]) forKey:@"uid"];
            [self linkSocketL];
            isShutUp = [minstr([_roomDic valueForKey:@"ishut"]) intValue];
            usertype = minstr(_roomDic[@"usertype"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                userNumLabel.text = [NSString stringWithFormat:@"  %@人  ",minstr([info valueForKey:@"nums"])];
                likesNumLabel.text = minstr([info valueForKey:@"likes"]);
                sellerGoodsNumsLabel.text = minstr([info valueForKey:@"goods"]);
                [self reloadAttionButton:[minstr([_roomDic valueForKey:@"isattent"]) intValue]];
                [self changeShutState];
            });
        }
    } fail:^{
        
    }];
}
#pragma mark -- socket代理相关

-(void)linkSocketL
{

    _socketL = [[socketLive alloc]init];
    _socketL.delegate = self;
    [_socketL addNodeListen:minstr([_roomDic valueForKey:@"chatserver"]) andRoomMessage:_roomDic];
}
//聊天消息
- (void)reciveMessage:(NSDictionary *)dic {
    NSDictionary *chatDic;
    if ([minstr([dic valueForKey:@"_method_"]) isEqual:@"SystemNot"]) {
        chatDic = @{
            @"contentChat":minstr([dic valueForKey:@"ct"]),
            @"userName":@"",
            @"userID":@"",
            @"type":@"1",
            @"icon":@"",
            @"isattent":@"0",
            
        };
    }
    else if ([minstr([dic valueForKey:@"_method_"]) isEqual:@"SendMsg"]) {
        chatDic = @{
            @"contentChat":minstr([dic valueForKey:@"content"]),
            @"userName":minstr([dic valueForKey:@"usernickname"]),
            @"userID":minstr([dic valueForKey:@"uid"]),
            @"type":@"2",
            @"icon":minstr([dic valueForKey:@"avatar"]),
            @"isattent":minstr([dic valueForKey:@"isattent"]),
            @"usertype":minstr(dic[@"usertype"])
        };

    }
    else if ([minstr([dic valueForKey:@"_method_"]) isEqual:@"SendLight"]) {
        chatDic = @{
            @"contentChat":@"点亮了",
            @"userName":minstr([dic valueForKey:@"usernickname"]),
            @"userID":minstr([dic valueForKey:@"uid"]),
            @"type":@"4",
            @"icon":minstr([dic valueForKey:@"avatar"]),
            @"isattent":minstr([dic valueForKey:@"isattent"]),
        };

    }
    if (chatDic) {
        chatModel *model = [[chatModel alloc]initWithDic:chatDic];
        [_chatArray addObject:model];
        if (_chatArray.count > 100) {
            [_chatArray removeObjectAtIndex:1];
        }
        [_chatTableView reloadData];
        [self jumpLast];
    }
}
//用户进入
- (void)userEnterRoom:(NSDictionary *)dic {
    NSDictionary *ct = [dic valueForKey:@"ct"];
    if (![minstr([ct valueForKey:@"uid"]) isEqual:[Config getOwnID]]) {
        NSDictionary *chatDic = @{
            @"contentChat":@"进入了直播间",
            @"userName":minstr([ct valueForKey:@"name"]),
            @"userID":minstr([ct valueForKey:@"uid"]),
            @"type":@"3",
            @"icon":minstr([ct valueForKey:@"avatar"]),
            @"isattent":minstr([ct valueForKey:@"isattent"]),
        };
        chatModel *model = [[chatModel alloc]initWithDic:chatDic];
        [_chatArray addObject:model];
        if (_chatArray.count > 100) {
            [_chatArray removeObjectAtIndex:1];
        }
        [_chatTableView reloadData];
        [self jumpLast];
    }

}
//用户离开
- (void)userLeaveRoom {
}

//禁言
- (void)anchorShutUser:(NSString *)touid andAction:(int)action content:(NSString *)content{
    if ([touid isEqual:[Config getOwnID]]) {
        if (action == 1) {
            isShutUp = YES;
            [MBProgressHUD showError:@"你已被禁言"];
        }else if (action == 2){
            isShutUp = NO;
            [MBProgressHUD showError:@"你已解除禁言"];
        }
    }
   NSDictionary *chatDic = @{
        @"contentChat":content,
        @"userName":@"",
        @"userID":@"",
        @"type":@"1",
        @"icon":@"",
        @"isattent":@"0",
        
    };
    chatModel *model = [[chatModel alloc]initWithDic:chatDic];
    [_chatArray addObject:model];
    if (_chatArray.count > 100) {
        [_chatArray removeObjectAtIndex:1];
    }
    [_chatTableView reloadData];
    [self jumpLast];
}
- (void)changeShutState{
    if (isShutUp) {
        [_inputTextView resignFirstResponder];
    }
}

//踢出房间
- (void)anchorKickUser:(NSString *)touid{
    if ([touid isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:@"你已被踢出房间"];
        [self doReturn];
    }
}
-(void)setAdmin:(NSDictionary *)msg action:(NSString *)action{
    NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];

    if ([touid isEqual:[Config getOwnID]]) {
        if ([action isEqual:@"0"]) {
            usertype = @"0";
        }else{
            usertype = @"40";
        }
    }
    /*
    NSDictionary *chatDic = @{
        @"contentChat":minstr(msg[@"ct"]),
        @"userName":@"",
        @"userID":@"",
        @"type":@"1",
        @"icon":@"",
        @"isattent":@"0",
        
    };
    chatModel *model = [[chatModel alloc]initWithDic:chatDic];
    [_chatArray addObject:model];
    if (_chatArray.count > 100) {
        [_chatArray removeObjectAtIndex:1];
    }
    [_chatTableView reloadData];
    [self jumpLast];
     */
}
///直播关闭
- (void)LiveEnd{
    NSString *url = [NSString stringWithFormat:@"live/stopinfo?stream=%@",minstr([_roomDic valueForKey:@"stream"])];
    [WYToolClass getQCloudWithUrl:url Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [self lastview:info];
        }else{
            [self lastview:nil];
        }
    } Fail:^{
        [self lastview:nil];
    }];
    

}
-(void)lastview:(NSDictionary *)dic{
    if (reloadTimer) {
        [reloadTimer invalidate];
        reloadTimer = nil;
    }

    //无数据都显示0
    if (!dic) {
        dic = @{@"length":@"0",@"nums":@"0"};
    }
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    lastView.userInteractionEnabled = YES;
    [lastView sd_setImageWithURL:[NSURL URLWithString:minstr([_roomDic valueForKey:@"thumb"])]];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [lastView addSubview:effectview];
    
    
    UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,24+statusbarHeight, _window_width, _window_height*0.17)];
    labell.textColor = normalColors;
    labell.text = @"直播已结束";
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:labell];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1, labell.bottom+50, _window_width*0.8, _window_width*0.8*8/13)];
    backView.backgroundColor = RGB_COLOR(@"#000000", 0.2);
    backView.layer.cornerRadius = 5.0;
    backView.layer.masksToBounds = YES;
    [lastView addSubview:backView];
    
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width/2-50, labell.bottom, 100, 100)];
    [headerImgView sd_setImageWithURL:[NSURL URLWithString:minstr([_roomDic valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    headerImgView.layer.masksToBounds = YES;
    headerImgView.layer.cornerRadius = 50;
    [lastView addSubview:headerImgView];

    
    UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,50, backView.width, backView.height*0.55-50)];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = minstr([_roomDic valueForKey:@"nickname"]);
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [backView addSubview:nameL];

    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(10, nameL.bottom, backView.width-20, 1) andColor:RGB_COLOR(@"#585452", 1) andView:backView];
    
    NSArray *labelArray = @[@"直播时长",@"观看人数"];
    for (int i = 0; i < labelArray.count; i++) {
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*backView.width/2, nameL.bottom, backView.width/2, backView.height/4)];
        topLabel.font = [UIFont boldSystemFontOfSize:18];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            topLabel.text = minstr([dic valueForKey:@"length"]);
        }
//        if (i == 1) {
//            topLabel.text = minstr([dic valueForKey:@"votes"]);
//        }
        if (i == 1) {
            topLabel.text = minstr([dic valueForKey:@"nums"]);
        }
        [backView addSubview:topLabel];
        UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom, topLabel.width, 14)];
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.textColor = RGB_COLOR(@"#cacbcc", 1);
        footLabel.textAlignment = NSTextAlignmentCenter;
        footLabel.text = labelArray[i];
        [backView addSubview:footLabel];
    }
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_window_width*0.1,_window_height *0.75, _window_width*0.8,40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:normalColors];
//    [button setBackgroundImage:[UIImage imageNamed:@"startLive_back"]];

    [button setTitle:@"返回首页" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds  =YES;
    [lastView addSubview:button];
    [self.view addSubview:lastView];
    
}
- (void)doReturn{
    [self invalidateTimer];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 注销计时器
- (void)invalidateTimer{
    //[_socketL userLeaveRoom];//发送关闭直播的socket
    [_socketL colseSocket];//注销socket
    _socketL = nil;//注销socket
    [_txLivePlayer stopPlay];
    _txLivePlayer = nil;
    if (reloadTimer) {
        [reloadTimer invalidate];
        reloadTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
#pragma mark -- 关注
- (void)doFollow{
    attionBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        attionBtn.userInteractionEnabled = YES;
    });
    [WYToolClass postNetworkWithUrl:@"attent/add" andParameter:@{@"touid":minstr([_roomDic valueForKey:@"liveuid"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:@"关注成功"];
            WeakSelf;
            [weakSelf reloadAttionButton:[minstr([info valueForKey:@"isattent"]) intValue]];
        }
    } fail:^{
        
    }];
}

#pragma mark -- 获取直播间人数
- (void)getRoomUserNums{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"livenums?stream=%@",minstr([_roomDic valueForKey:@"stream"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            userNumLabel.text = [NSString stringWithFormat:@"  %@人  ",minstr([info valueForKey:@"nums"])];

        }
    } Fail:^{
        
    }];
}
#pragma mark -- 获取直播间点赞数
- (void)getRoomLikeNums{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"livelikes?stream=%@",minstr([_roomDic valueForKey:@"stream"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            likesNumLabel.text = minstr([info valueForKey:@"nums"]);
        }
    } Fail:^{
        
    }];

}
#pragma mark -- 获取直播间销售商品数
- (void)getRoomSellerGoodsNums{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"livegoodsnums?stream=%@",minstr([_roomDic valueForKey:@"stream"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            sellerGoodsNumsLabel.text = minstr([info valueForKey:@"nums"]);
        }
    } Fail:^{
        
    }];

}

- (void)reloadRoomMessage{
    [self getRoomLikeNums];
    [self getRoomUserNums];
    [self getRoomSellerGoodsNums];
}
#pragma mark -- 点亮
- (void)doLight{
    
    likeBtn.userInteractionEnabled = NO;
    [WYToolClass postNetworkWithUrl:@"livesetlike" andParameter:@{@"stream":minstr([_roomDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        likeBtn.userInteractionEnabled = YES;
        if (code == 200) {
            if (!isLight) {
                isLight = YES;
                [_socketL startLike];
            }
            likesNumLabel.text = [NSString stringWithFormat:@"%lld",[likesNumLabel.text longLongValue] + 1];
        }
    } fail:^{
        likeBtn.userInteractionEnabled = YES;
    }];
    [self socketLight];
}
-(void)socketLight{
    CGFloat starX = likeBtn.frame.origin.x ;
    CGFloat starY = likeBtn.frame.origin.y - 30;
    UIImageView *starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX, starY, 30, 30)];
    starImage.contentMode = UIViewContentModeScaleAspectFit;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_no1.png",@"plane_heart_no2.png",@"plane_heart_no3.png",@"plane_heart_no4.png",@"plane_heart_no5.png", nil];
    NSInteger random = arc4random()%array.count;
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    [UIView animateWithDuration:0.2 animations:^{
        starImage.alpha = 1.0;
        starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [_frontView addSubview:starImage];
    CGFloat finishX = _window_width - round(arc4random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(arc4random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(starImage)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    
    //  设置imageView的结束frame
    starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        starImage.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (moreView) {
        moreView.hidden = YES;
        moreBtn.selected = NO;
    }
    if ([giftview isDescendantOfView:self.view]) {
        [giftview removeFromSuperview];
    }

}
-(void)dealloc{
    if (_socketL) {
        [_socketL closeRoom];//发送关闭直播的socket
        [_socketL colseSocket];//注销socket
        _socketL = nil;//注销socket
    }
    if (_txLivePlayer) {
        [_txLivePlayer stopPlay];
        _txLivePlayer = nil;
    }
    if (reloadTimer) {
        [reloadTimer invalidate];
        reloadTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
