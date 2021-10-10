//
//  WYSuspensionPlayer.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/24.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYSuspensionPlayer.h"
#import <TXLiteAVSDK.h>
#import <TXLiteAVSDK_Smart/TXLivePlayer.h>
#import "LivePlayerViewController.h"

@interface WYSuspensionPlayer ()<TXLivePlayListener>{
    NSInteger _playType;
}
@property (nonatomic,strong) NSString *hostURL;
@property (nonatomic,strong)    TXLivePlayer *       txLivePlayer;
@property (nonatomic,strong)    TXLivePlayConfig*    config;
@property (nonatomic,strong) NSMutableDictionary *roomDic;

@end

@implementation WYSuspensionPlayer
- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)msg{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:minstr([msg valueForKey:@"thumb"])]];
        [self addSubview:imgV];
        _roomDic = [msg mutableCopy];
        _hostURL = minstr([_roomDic valueForKey:@"pull"]);
        _config = [[TXLivePlayConfig alloc] init];
        //自动模式
        _config.bAutoAdjustCacheTime   = YES;
        _config.minAutoAdjustCacheTime = 1;
        _config.maxAutoAdjustCacheTime = 5;
        _config.connectRetryCount = 1;
        _txLivePlayer =[[TXLivePlayer alloc] init];
        _txLivePlayer.enableHWAcceleration = YES;
        [_txLivePlayer setupVideoWidget:imgV.bounds containView:imgV insertIndex:0];
        [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [_txLivePlayer setConfig:_config];
        
        
        if(_txLivePlayer != nil)
        {
            _txLivePlayer.delegate = self;
            _playType = 0;
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

        [self addPanGestureRecognizer];
        
        UIButton *closeBtn = [UIButton buttonWithType:0];
        closeBtn.frame = CGRectMake(self.width-40, 0, 40, 40);
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 15, 5);
        [closeBtn setImage:[UIImage imageNamed:@"pre_退出登录"] forState:0];
        [closeBtn addTarget:self action:@selector(doClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}
- (void)addPanGestureRecognizer{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlepanss:)];
    [self addGestureRecognizer:panGesture];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fanhuishitu)];
    [self addGestureRecognizer:backTap];
}
- (void) handlepanss: (UIPanGestureRecognizer *)rec{
    UIView *tapView = (UIView *)rec.view;

    CGPoint point = [rec translationInView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
    if (rec.state == UIGestureRecognizerStateEnded) {
        CGFloat centerX,centerY;
        if (rec.view.center.x >= _window_width/2) {
            centerX = _window_width-tapView.width/2;
        }else{
            centerX = tapView.width/2;
        }
        if (rec.view.center.y >= _window_height-tapView.height/2-ShowDiff) {
            centerY = _window_height-tapView.height/2-ShowDiff;
        }else if (rec.view.center.y <= tapView.height/2+statusbarHeight) {
            centerY = tapView.height/2+statusbarHeight;
        }else{
            centerY = rec.view.center.y;
        }
        [UIView animateWithDuration:0.2 animations:^{
            rec.view.center = CGPointMake(centerX, centerY);
        }];
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
        }
        else if (EvtID== PLAY_WARNING_VIDEO_PLAY_LAG){
            NSLog(@"moviplay不连麦当前视频播放出现卡顿（用户直观感受）");
        }
        else if (EvtID == PLAY_EVT_PLAY_END){
            NSLog(@"moviplay不连麦视频播放结束");
            if (_playType == PLAY_TYPE_VOD_MP4) {
                [_txLivePlayer resume];
            }else{
                [self doLiveEnd];
            }
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            //视频播放结束
            NSLog(@"moviplay不连麦网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
            [self doLiveEnd];

        }else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            NSLog(@"主播连麦分辨率改变");
        }
    });
}
- (void)doLiveEnd{
    [self stopPlay];
    [MBProgressHUD showError:@"直播结束"];
    [self removeFromSuperview];
}
- (void)stopPlay{
    [_txLivePlayer stopPlay];
    _txLivePlayer = nil;
}
- (void)fanhuishitu{
    [self stopPlay];
    NSArray *temArray = [MXBADelegate sharedAppDelegate].topViewController.navigationController.viewControllers;
    LivePlayerViewController *playerVC;
    for(UIViewController *temVC in temArray)
        
    {
        
        if ([temVC isKindOfClass:[LivePlayerViewController class]])
            
        {
            playerVC = (LivePlayerViewController *)temVC;
            
        }
        
    }
    if (playerVC) {
        [[MXBADelegate sharedAppDelegate] popToViewController:playerVC];
    }else{
        [self removeFromSuperview];
        [self checkLive];
    }

}
- (void)checkLive{
    [WYToolClass postNetworkWithUrl:@"live/check" andParameter:@{@"stream":minstr([_roomDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            LivePlayerViewController *player = [[LivePlayerViewController alloc]init];
            player.roomDic = _roomDic;
            [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
        }
    } fail:^{
        
    }];
}

- (void)doClose{
    [self stopPlay];
    [self removeFromSuperview];
}
@end
