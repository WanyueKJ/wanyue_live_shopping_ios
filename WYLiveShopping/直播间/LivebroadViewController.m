//
//  LivebroadViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/5.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "LivebroadViewController.h"
#import "socketLive.h"
#import <TXLiteAVSDK.h>
#import <TXLiteAVSDK_Smart/TXLivePush.h>
#import <TXLiteAVSDK_Smart/TXLiveBase.h>
#import "V8HorizontalPickerView.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>

#import "startLiveClassVC.h"
#import "Utils.h"
#import "chatMsgCell.h"
#import "userPopupView.h"
#import "MyTextView.h"
#import "anchorMoreMenuView.h"
#import "shareView.h"
#import "expensiveGiftV.h"
#import "continueGift.h"
#import "LiveOnlineList.h"
//#import "TZImagePickerController.h"
typedef NS_ENUM(NSInteger,TCLVFilterType) {
    FilterType_None         = 0,
    FilterType_white        ,   //美白滤镜
    FilterType_langman         ,   //浪漫滤镜
    FilterType_qingxin         ,   //清新滤镜
    FilterType_weimei         ,   //唯美滤镜
    FilterType_fennen         ,   //粉嫩滤镜
    FilterType_huaijiu         ,   //怀旧滤镜
    FilterType_landiao         ,   //蓝调滤镜
    FilterType_qingliang     ,   //清凉滤镜
    FilterType_rixi         ,   //日系滤镜
};
@import CoreLocation;

@interface LivebroadViewController ()<TXVideoCustomProcessDelegate,TXLivePushListener,V8HorizontalPickerViewDelegate,V8HorizontalPickerViewDataSource,UITextViewDelegate,CLLocationManagerDelegate,socketLiveDelegate,UITableViewDelegate,UITableViewDataSource,userPopupViewDeleagte,UITextFieldDelegate,haohuadelegate,TZImagePickerControllerDelegate,LiveOnlineListDelegate>{
    /***********************  腾讯SDK start **********************/
    float  _tx_beauty_level;
    float  _tx_whitening_level;
    float  _tx_eye_level;
    float  _tx_face_level;
    UIButton              *_beautyBtn;
    UIButton              *_filterBtn;
    UILabel               *_beautyLabel;
    UILabel               *_whiteLabel;
    UISlider              *_sdBeauty;
    UISlider              *_sdWhitening;
    V8HorizontalPickerView  *_filterPickerView;
    NSInteger    _filterType;
    
    NSTimer *backGroundTimer;//检测后台时间（超过60秒执行断流操作）
    int backTime;//返回后台时间60s

    //预览视图相关
    UIButton *preThumbBtn;
    UILabel *thumbLabel;
    UITextView *liveTitleTextView;
    UILabel *textPlaceholdLabel;
    UIImage *thumbImage;
    //开播位置相关
    UILabel *locationLabel;
    //开始直播按钮
    UIButton *startLiveBtn;
    //直播分类
    UILabel *classTipL;
    NSString *liveClassID;
    //开始动画
    UIView *animationBackView;
    UILabel *aniLabel1;
    UILabel *aniLabel2;
    UILabel *aniLabel3;
    //是否被禁言
    BOOL isShutUp;
    //直播间按钮
    UIButton *closeRoomBtn;//关闭直播间按钮
    UIButton *chatBtn;//聊天按钮
    UIButton *moreBtn;//更多功能按钮
    UILabel *likesNumLabel;//点赞数
    UILabel *userNumLabel;//直播间人数
    //用户弹窗
    userPopupView *userPview;
    //飘心计时器
    NSTimer *heartTimer;
    int heartShowCount;
    //主播更多按钮view
    anchorMoreMenuView *moreMenuView;
    BOOL isTorch;//是否开启闪光灯
    //分享视图
    shareView *shareV;
    //连送礼物效果展示view
    UIView *liansongliwubottomview;//连送礼物底部view
    continueGift *continueGifts;//连送礼物
    expensiveGiftV *haohualiwuV;//豪华礼物
    //定时请求直播间人数点赞数
    NSTimer *reloadTimer;
    //已卖出商品数量
    UILabel *sellerGoodsNumsLabel;
    BOOL _needScale;
    LiveOnlineList *onlineList;//在线用户列表
}
@property (nonatomic,strong)UIView *preFrontView;
//@property(nonatomic, strong) GPUImageView *gpuPreviewView;
//@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
//@property (nonatomic, strong) CIImage *outputImage;
//@property (nonatomic, assign) size_t outputWidth;
//@property (nonatomic, assign) size_t outputheight;

/***********************  腾讯SDK start **********************/
@property TXLivePushConfig* txLivePushonfig;
@property TXLivePush*       txLivePublisher;
@property (nonatomic,strong) NSDictionary *pushSettings;

@property(nonatomic,strong)NSMutableArray *filterArray;//美颜数组
@property (nonatomic,strong)UIView     *vBeauty;
@property (nonatomic,strong)CTCallCenter     *callCenter;

/***********************  腾讯SDK end **********************/

/// 顶部提示
@property (nonatomic,strong) CWStatusBarNotification *notification;

/// 预览视图
@property (nonatomic,strong) UIView *pushBackView;

/// 推流地址
@property (nonatomic,strong) NSString *hostURL;
/// socket
@property (nonatomic,strong) socketLive *socketL;
///定位
@property (nonatomic,strong) CLLocationManager   *lbsManager;
///直播界面视图父view
@property (nonatomic,strong) UIView *frontView;
///直播间信息字典
@property (nonatomic,strong) NSMutableDictionary *roomDic;
///聊天展示tableview
@property (nonatomic,strong) UITableView *chatTableView;
///聊天信息数组
@property (nonatomic,strong) NSMutableArray *chatArray;
///直播间打字聊天输入框
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UITextField *inputTextView;

@end

@implementation LivebroadViewController
#pragma mark -- 退出登录
- (void)doSignOut{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 定位相关
/*
- (void)stopLbs {
    [_lbsManager stopUpdatingHeading];
    _lbsManager.delegate = nil;
    _lbsManager = nil;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [self stopLbs];
    } else {
        [_lbsManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLbs];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocatioin = locations[0];
    liveCity *cityU = [cityDefault myProfile];
    cityU.lat = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.latitude];
    cityU.lng = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocatioin completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            CLPlacemark *placeMark = placemarks[0];
            NSString *city      = placeMark.locality;
            NSString *addr = [NSString stringWithFormat:@"%@%@%@%@%@",placeMark.country,placeMark.administrativeArea,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare];
            cityU.addr = addr;
            cityU.city = city;
            [cityDefault saveProfile:cityU];
            dispatch_async(dispatch_get_main_queue(), ^{
                locationLabel.text = city;
            });
        }
    }];
     [self stopLbs];
}
-(void)location{
    if (!_lbsManager) {
        _lbsManager = [[CLLocationManager alloc] init];
        [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _lbsManager.delegate = self;
        // 兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [_lbsManager respondsToSelector:requestSelector]) {
            [_lbsManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        } else {
            [_lbsManager startUpdatingLocation];
        }
    }
}
*/
#pragma mark -- 定位结束

#pragma mark -- 腾讯直播相关
-(void)txBaseBeauty {
    _filterArray = [NSMutableArray new];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"原图";
        v.face = [UIImage imageNamed:@"orginal"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"美白";
        v.face = [UIImage imageNamed:@"fwhite"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"浪漫";
        v.face = [UIImage imageNamed:@"langman"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"清新";
        v.face = [UIImage imageNamed:@"qingxin"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"唯美";
        v.face = [UIImage imageNamed:@"weimei"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"粉嫩";
        v.face = [UIImage imageNamed:@"fennen"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"怀旧";
        v.face = [UIImage imageNamed:@"huaijiu"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"蓝调";
        v.face = [UIImage imageNamed:@"landiao"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"清凉";
        v.face = [UIImage imageNamed:@"qingliang"];
        v;
    })];
    [_filterArray addObject:({
        V8LabelNode *v = [V8LabelNode new];
        v.title = @"日系";
        v.face = [UIImage imageNamed:@"rixi"];
        v;
    })];
    
    
    
    //美颜拉杆浮层
    float   beauty_btn_width  = 65;
    float   beauty_btn_height = 30;//19;
    
    float   beauty_btn_count  = 2;
    
    float   beauty_center_interval = (self.view.width - 30 - beauty_btn_width)/(beauty_btn_count - 1);
    float   first_beauty_center_x  = 15 + beauty_btn_width/2;
    int ib = 0;
    _vBeauty = [[UIView  alloc] init];
    _vBeauty.frame = CGRectMake(0, self.view.height-185-statusbarHeight, self.view.width, 185+statusbarHeight);
    [_vBeauty setBackgroundColor:[UIColor whiteColor]];
    float   beauty_center_y = _vBeauty.height - 30;//35;
    _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _beautyBtn.center = CGPointMake(first_beauty_center_x, beauty_center_y);
    _beautyBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty"] forState:UIControlStateNormal];
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty_press"] forState:UIControlStateSelected];
    [_beautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:normalColors forState:UIControlStateSelected];
    _beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _beautyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _beautyBtn.tag = 0;
    _beautyBtn.selected = YES;
    [_beautyBtn addTarget:self action:@selector(selectBeauty:) forControlEvents:UIControlEventTouchUpInside];
    ib++;
    _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterBtn.center = CGPointMake(first_beauty_center_x + ib*beauty_center_interval, beauty_center_y);
    _filterBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful"] forState:UIControlStateNormal];
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful_press"] forState:UIControlStateSelected];
    [_filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
    [_filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_filterBtn setTitleColor:normalColors forState:UIControlStateSelected];
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _filterBtn.tag = 1;
    [_filterBtn addTarget:self action:@selector(selectBeauty:) forControlEvents:UIControlEventTouchUpInside];
    ib++;
    _beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  _beautyBtn.top - 95, 40, 20)];
    _beautyLabel.text = @"美白";
    _beautyLabel.font = [UIFont systemFontOfSize:12];
    _sdBeauty = [[UISlider alloc] init];
    _sdBeauty.frame = CGRectMake(_beautyLabel.right, _beautyBtn.top - 95, self.view.width - _beautyLabel.right - 10, 20);
    _sdBeauty.minimumValue = 0;
    _sdBeauty.maximumValue = 9;
    _sdBeauty.value = 6.3;
    [_sdBeauty setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdBeauty setMinimumTrackImage:[WYToolClass getImgWithColor:normalColors] forState:UIControlStateNormal];
    [_sdBeauty setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdBeauty addTarget:self action:@selector(txsliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdBeauty.tag = 0;
    
    
    _whiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _beautyBtn.top - 55, 40, 20)];
    
    _whiteLabel.text = @"美颜";
    _whiteLabel.font = [UIFont systemFontOfSize:12];
    _sdWhitening = [[UISlider alloc] init];
    
    _sdWhitening.frame =  CGRectMake(_whiteLabel.right, _beautyBtn.top - 55, self.view.width - _whiteLabel.right - 10, 20);
    
    _sdWhitening.minimumValue = 0;
    _sdWhitening.maximumValue = 9;
    _sdWhitening.value = 2.7;
    [_sdWhitening setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdWhitening setMinimumTrackImage:[WYToolClass getImgWithColor:normalColors] forState:UIControlStateNormal];//[UIImage imageNamed:@"green"]
    [_sdWhitening setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdWhitening addTarget:self action:@selector(txsliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdWhitening.tag = 1;
    
    _filterPickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 115)];
    _filterPickerView.textColor = [UIColor grayColor];
    _filterPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _filterPickerView.delegate = self;
    _filterPickerView.dataSource = self;
    _filterPickerView.hidden = YES;
    
    UIImageView *sel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected"]];
    
    _filterPickerView.selectedMaskView = sel;
    _filterType = 0;
    
    [_vBeauty addSubview:_beautyLabel];
    [_vBeauty addSubview:_whiteLabel];
    [_vBeauty addSubview:_sdWhitening];
    [_vBeauty addSubview:_sdBeauty];
    [_vBeauty addSubview:_beautyBtn];
    [_vBeauty addSubview:_filterPickerView];
    [_vBeauty addSubview:_filterBtn];
    _vBeauty.hidden = YES;
    [self.view addSubview: _vBeauty];
}
-(void)userTXBase {
    if (!_vBeauty) {
        [self txBaseBeauty];
    }
    _preFrontView.hidden = YES;
    _vBeauty.hidden = NO;
    [self.view bringSubviewToFront:_vBeauty];
}
-(void)txRtmpPush{
    _pushBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _pushBackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_pushBackView];
    [self.view sendSubviewToBack:_pushBackView];
    //配置推流参数
    _txLivePushonfig = [[TXLivePushConfig alloc] init];
    _txLivePushonfig.frontCamera = YES;
    _txLivePushonfig.enableAutoBitrate = YES;
    /*
     {
     "codingmode": "2",
     "resolution": "5",
     "fps": "15",
     "fps_min": "15",
     "fps_max": "30",
     "gop": "3",
     "bitrate": "800",
     "bitrate_min": "800",
     "bitrate_max": "1200",
     "audiorate": "44100",
     "audiobitrate": "48",
     "preview_fps": "15",
     "preview_resolution": "1"
     }
     */
    int videoResolution = [minstr([_pushSettings valueForKey:@"resolution"]) intValue];
    if (videoResolution == 0) {
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_360_640 ;
    }
    else if (videoResolution == 1){
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_540_960 ;
    }
    else{
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_720_1280 ;
    }
    _txLivePushonfig.videoEncodeGop = [minstr([_pushSettings valueForKey:@"gop"]) intValue];
    _txLivePushonfig.videoFPS = [minstr([_pushSettings valueForKey:@"fps"]) intValue];
    _txLivePushonfig.videoBitratePIN = [minstr([_pushSettings valueForKey:@"bitrate"]) intValue];
    _txLivePushonfig.videoBitrateMax = [minstr([_pushSettings valueForKey:@"bitrate_max"]) intValue];
    _txLivePushonfig.videoBitrateMin = [minstr([_pushSettings valueForKey:@"bitrate_min"]) intValue];
    _txLivePushonfig.audioSampleRate = [minstr([_pushSettings valueForKey:@"audiorate"]) intValue];
    _txLivePushonfig.pauseTime = 60;
    //background push
    _txLivePushonfig.pauseFps = 5;
    _txLivePushonfig.pauseTime = 300;
    //耳返
    _txLivePushonfig.enableAudioPreview = NO;
    _txLivePushonfig.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
    _txLivePublisher = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
    if (isMHSDK) {
        _txLivePublisher.videoProcessDelegate = self;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:0 whitenessLevel:0 ruddinessLevel:0];
        [_txLivePublisher setMirror:YES];
    }else{
        _tx_beauty_level = 9;
        _tx_whitening_level = 3;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
    }
    
    [_txLivePublisher startPreview:_pushBackView];
    //[self txStartRtmp];
    _notification = [CWStatusBarNotification new];
    _notification.notificationLabelBackgroundColor = [UIColor redColor];
    _notification.notificationLabelTextColor = [UIColor whiteColor];
}
-(void)txStartRtmp{
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = self;
        [self.txLivePublisher setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION adjustBitrate:YES adjustResolution:YES];
        //连麦混流
//        _hostURL = [NSString stringWithFormat:@"%@&mix=session_id:%@",_hostURL,[Config getOwnID]];
        [_txLivePublisher startPush:_hostURL];
        if ([_txLivePublisher startPush:_hostURL] != 0) {
            [_notification displayNotificationWithMessage:@"推流器启动失败" forDuration:5];
            NSLog(@"推流器启动失败");
        }
//        if ([[common getIsTXfiter]isEqual:@"1"]) {
//            [_txLivePublisher setEyeScaleLevel:_tx_eye_level];
//            [_txLivePublisher setFaceScaleLevel:_tx_face_level];
//        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}
- (void)txStopRtmp {
    if(_txLivePublisher != nil)
    {
        [_txLivePublisher stopBGM];
        _txLivePublisher.delegate = nil;
        [_txLivePublisher stopPreview];
        [_txLivePublisher stopPush];
        _txLivePublisher.config.pauseImg = nil;
        _txLivePublisher = nil;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
-(void) onNetStatus:(NSDictionary*) param{
    
}
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"onPushEvent:(int)EvtID withParam:(NSDictionary*)param = \n%d",EvtID);
        if (EvtID >= 0) {
            if (EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL) {
                _txLivePublisher.config.enableHWAcceleration = false;
                NSLog(@"PUSH_EVT_PUSH_BEGIN硬编码启动失败，采用软编码");
            }else if (EvtID == PUSH_EVT_CONNECT_SUCC) {
                // 已经连接推流服务器
                NSLog(@" PUSH_EVT_PUSH_BEGIN已经连接推流服务器");
            }else if (EvtID == PUSH_EVT_PUSH_BEGIN) {
                // 已经与服务器握手完毕,开始推流
                [self changePlayState:1];
                NSLog(@"liveshow已经与服务器握手完毕,开始推流");
            }else if (EvtID == PUSH_WARNING_RECONNECT){
                // 网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)
                NSLog(@"网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)");
            }else if (EvtID == PUSH_WARNING_NET_BUSY) {
                [_notification displayNotificationWithMessage:@"您当前的网络环境不佳，请尽快更换网络保证正常直播" forDuration:5];
            }else if (EvtID == WARNING_RTMP_SERVER_RECONNECT) {
                [_notification displayNotificationWithMessage:@"网络断连, 已启动自动重连" forDuration:5];
            }
        }else {
            if (EvtID == PUSH_ERR_NET_DISCONNECT) {
                NSLog(@"PUSH_EVT_PUSH_BEGIN网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启推流");
                [_notification displayNotificationWithMessage:@"网络断连" forDuration:5];
                [self getCloseShow];
            }
        }
    });
}
//推流成功后更新直播状态 1开播
-(void)changePlayState:(int)status{
    
    NSDictionary *changelive = @{
                                 @"islive":@"1"
                                 };
    [WYToolClass postNetworkWithUrl:@"live/upLive" andParameter:changelive success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
    } fail:^{
        
    }];
}

-(void) txsliderValueChange:(UISlider*) obj {
    // todo
    if (obj.tag == 1) { //美颜
        _tx_beauty_level = obj.value;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
        // [_txLivePublisher setBeautyFilterDepth:_beauty_level setWhiteningFilterDepth:_whitening_level];
    } else if (obj.tag == 0) { //美白
        _tx_whitening_level = obj.value;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
        // [_txLivePublisher setBeautyFilterDepth:_beauty_level setWhiteningFilterDepth:_whitening_level];
    } else if (obj.tag == 2) { //大眼
        _tx_eye_level = obj.value;
        [_txLivePublisher setEyeScaleLevel:_tx_eye_level];
    } else if (obj.tag == 3) { //瘦脸
        _tx_face_level = obj.value;
        [_txLivePublisher setFaceScaleLevel:_tx_face_level];
    } else if (obj.tag == 4) {// 背景音乐音量
        [_txLivePublisher setBGMVolume:(obj.value/obj.maximumValue)];
    } else if (obj.tag == 5) { // 麦克风音量
        [_txLivePublisher setMicVolume:(obj.value/obj.maximumValue)];
    }
}

-(void)selectBeauty:(UIButton *)button{
    switch (button.tag) {
        case 0: {
            _sdWhitening.hidden = NO;
            _sdBeauty.hidden    = NO;
            _beautyLabel.hidden = NO;
            _whiteLabel.hidden  = NO;
            _beautyBtn.selected  = YES;
            _filterBtn.selected = NO;
            _filterPickerView.hidden = YES;
            _vBeauty.frame = CGRectMake(0, self.view.height-185-statusbarHeight, self.view.width, 185+statusbarHeight);
        }break;
        case 1: {
            _sdWhitening.hidden = YES;
            _sdBeauty.hidden    = YES;
            _beautyLabel.hidden = YES;
            _whiteLabel.hidden  = YES;
            _beautyBtn.selected  = NO;
            _filterBtn.selected = YES;
            _filterPickerView.hidden = NO;
            [_filterPickerView scrollToElement:_filterType animated:NO];
        }
            _beautyBtn.center = CGPointMake(_beautyBtn.center.x, _vBeauty.frame.size.height - 35-statusbarHeight);
            _filterBtn.center = CGPointMake(_filterBtn.center.x, _vBeauty.frame.size.height - 35-statusbarHeight);
    }
}
//设置美颜滤镜
#pragma mark - HorizontalPickerView DataSource Methods/Users/annidy/Work/RTMPDemo_PituMerge/RTMPSDK/webrtc
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [_filterArray count];
}
#pragma mark - HorizontalPickerView Delegate Methods
- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    
    V8LabelNode *v = [_filterArray objectAtIndex:index];
    return [[UIImageView alloc] initWithImage:v.face];
    
}
- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    
    return 90;
}
- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    _filterType = index;
    [self filterSelected:index];
}
- (void)filterSelected:(NSInteger)index {
    NSString* lookupFileName = @"";
    switch (index) {
        case FilterType_None:
            break;
        case FilterType_white:
            lookupFileName = @"filter_white";
            break;
        case FilterType_langman:
            lookupFileName = @"filter_langman";
            break;
        case FilterType_qingxin:
            lookupFileName = @"filter_qingxin";
            break;
        case FilterType_weimei:
            lookupFileName = @"filter_weimei";
            break;
        case FilterType_fennen:
            lookupFileName = @"filter_fennen";
            break;
        case FilterType_huaijiu:
            lookupFileName = @"filter_huaijiu";
            break;
        case FilterType_landiao:
            lookupFileName = @"filter_landiao";
            break;
        case FilterType_qingliang:
            lookupFileName = @"filter_qingliang";
            break;
        case FilterType_rixi:
            lookupFileName = @"filter_rixi";
            break;
        default:
            break;
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:lookupFileName ofType:@"png"];
    if (path != nil && index != FilterType_None && _txLivePublisher != nil) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [_txLivePublisher setFilter:image];
    }
    else if(_txLivePublisher != nil) {
        [_txLivePublisher setFilter:nil];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (moreMenuView) {
        moreMenuView.hidden = YES;
        moreBtn.selected = NO;
    }
    //腾讯基础美颜
    if (_vBeauty && _vBeauty.hidden == NO) {
        _vBeauty.hidden = YES;
         _preFrontView.hidden = NO;
    }

}

#pragma mark ================ TXVideoProcessDelegate ===============
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{

    return texture;
}



- (void)onTextureDestoryed{
    NSLog(@"[self.tiSDKManager destroy];");
}
#pragma mark ===========================   腾讯推流end   =======================================
-(void)viewWillAppear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    //弹出相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
     
    }];
    //弹出麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
      
    }];

    //开始定位
//    [self location];
    //初始化一些基本信息
    [self chushihua];
    //注册通知
    [self nsnotifition];

    //创建预览视图
    [self creatPreFrontView];
    WeakSelf;
    AFNetworkReachabilityManager *managerAFH = [AFNetworkReachabilityManager sharedManager];
    [managerAFH setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                [weakSelf backGround];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                [weakSelf backGround];
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                [weakSelf forwardGround];

                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [weakSelf forwardGround];
                break;
            default:
                break;
        }
    }];
    [managerAFH startMonitoring];

#pragma mark 回到后台+来电话
    self.callCenter = [CTCallCenter new];
    
    self.callCenter.callEventHandler = ^(CTCall *call) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([call.callState isEqualToString:CTCallStateDialing]) {
                NSLog(@"电话主动拨打电话");
                [weakSelf reciverPhoneCall];
            } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                NSLog(@"电话接通");
                [weakSelf reciverPhoneCall];
            } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                NSLog(@"电话挂断");
                [weakSelf phoneCallEnd];
            } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                NSLog(@"电话被叫");
                [weakSelf reciverPhoneCall];
            } else {
                NSLog(@"电话其他状态");
            }
        });
    };
    
    [MBProgressHUD hideHUD];
//    [self creatPreFrontView];
    [self getHomeConfig];
    
}
- (void)getHomeConfig{
    [WYToolClass getQCloudWithUrl:@"/live/config" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            //腾讯
            _pushSettings = [info valueForKey:@"ios"];
            [self txRtmpPush];

        }
    } Fail:^{
        
    }];
}
- (void)chushihua{
    liveClassID = @"未选择";
    _chatArray = [NSMutableArray array];
}
-(void)nsnotifition{
    //注册进入后台的处理
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [notification addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [notification addObserver:self
           selector:@selector(shajincheng)
               name:@"shajincheng"
             object:nil];


}
#pragma mark ================ 直播开始之前的预览 ===============
- (void)creatPreFrontView{
    _preFrontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _preFrontView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_preFrontView];
//    UIView *zhezhaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
//    zhezhaoView.backgroundColor = RGB_COLOR(@"#000000", 0.4);
//    [_preFrontView addSubview:zhezhaoView];
    /*
    UIImageView *loactionImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 42+statusbarHeight, 16, 16)];
    loactionImgView.image = [UIImage imageNamed:@"pre_location"];
    [_preFrontView addSubview:loactionImgView];
    UIView *locationLabelView = [[UIView alloc]init];
    locationLabelView.backgroundColor = RGB_COLOR(@"#000000", 0.3);
    locationLabelView.layer.cornerRadius = 8;
    locationLabelView.layer.masksToBounds = YES;
    [_preFrontView addSubview:locationLabelView];
    [locationLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loactionImgView);
        make.left.equalTo(loactionImgView.mas_right).offset(-8);
        make.height.mas_equalTo(16);
    }];

    locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"  ";
    locationLabel.font = [UIFont systemFontOfSize:11];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.text = [cityDefault getMyCity];
    [locationLabelView addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationLabelView);
        make.height.mas_equalTo(16);
        make.left.equalTo(locationLabelView).offset(10);
        make.right.equalTo(locationLabelView).offset(-10);
    }];
    [_preFrontView insertSubview:locationLabelView belowSubview:loactionImgView];
    UIButton *locationSwitchBtn = [UIButton buttonWithType:0];
    [locationSwitchBtn addTarget:self action:@selector(locationSwitchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_preFrontView addSubview:locationSwitchBtn];
    [locationSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(loactionImgView);
        make.right.equalTo(locationLabelView);
    }];
     */
    UIButton *switchBtn = [UIButton buttonWithType:0];
//    switchBtn.frame = CGRectMake(locationLabel.right+20, loactionImgView.top, loactionImgView.height, loactionImgView.height);
    [switchBtn setImage:[UIImage imageNamed:@"pre_camer"] forState:0];
    [switchBtn addTarget:self action:@selector(rotateCamera) forControlEvents:UIControlEventTouchUpInside];
    [_preFrontView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_preFrontView).offset(15);
        make.top.equalTo(_preFrontView).offset(40+statusbarHeight);
        make.height.width.mas_equalTo(20);
    }];
    
    UIButton *signOutbtn = [UIButton buttonWithType:0];
    [signOutbtn setImage:[UIImage imageNamed:@"pre_退出登录"] forState:0];
    [signOutbtn addTarget:self action:@selector(doSignOut) forControlEvents:UIControlEventTouchUpInside];
    signOutbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_preFrontView addSubview:signOutbtn];
    [signOutbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_preFrontView).offset(-10);
        make.centerY.equalTo(switchBtn);
        make.height.width.mas_equalTo(40);
    }];
    
    
    UIView *preMiddleView = [[UIView alloc]initWithFrame:CGRectMake(10, 110+statusbarHeight, _window_width-20, (_window_width-20)*0.4)];
    preMiddleView.backgroundColor = RGB_COLOR(@"#000000", 0.15);
    preMiddleView.layer.cornerRadius = 5;
    [_preFrontView addSubview:preMiddleView];
    
    preThumbBtn = [UIButton buttonWithType:0];
    preThumbBtn.frame = CGRectMake(10, 15, (preMiddleView.height-30)*0.91, preMiddleView.height-30);
    [preThumbBtn setImage:[UIImage imageNamed:@"pre_uploadThumb"] forState:0];
//    preThumbBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [preThumbBtn addTarget:self action:@selector(doUploadPicture) forControlEvents:UIControlEventTouchUpInside];
    preThumbBtn.layer.cornerRadius = 5.0;
    preThumbBtn.layer.masksToBounds = YES;
    [preMiddleView addSubview:preThumbBtn];
    thumbLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, preThumbBtn.height*0.75, preThumbBtn.width, preThumbBtn.height/4)];
    thumbLabel.textColor = RGB_COLOR(@"#ffffff", 1);
    thumbLabel.textAlignment = NSTextAlignmentCenter;
    thumbLabel.text = @"添加封面";
    thumbLabel.font = [UIFont systemFontOfSize:12];
    [preThumbBtn addSubview:thumbLabel];
    

//    UILabel *preTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(preThumbBtn.right+5, preThumbBtn.top, 100, preThumbBtn.height/4)];
//    preTitlelabel.font = [UIFont systemFontOfSize:13];
//    preTitlelabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
//    preTitlelabel.text = @"直播标题";
//    [preMiddleView addSubview:preTitlelabel];
    liveTitleTextView = [[UITextView alloc]initWithFrame:CGRectMake(preThumbBtn.right+5, preThumbBtn.top + 5, preMiddleView.width-10-preThumbBtn.right, preThumbBtn.height-10)];
    liveTitleTextView.delegate = self;
    liveTitleTextView.font = [UIFont systemFontOfSize:17];
    liveTitleTextView.textColor = [UIColor whiteColor];
    liveTitleTextView.backgroundColor = [UIColor clearColor];
    [preMiddleView addSubview:liveTitleTextView];
    textPlaceholdLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, liveTitleTextView.width, 22)];
    textPlaceholdLabel.font = [UIFont systemFontOfSize:17];
    textPlaceholdLabel.textColor = [UIColor whiteColor];
    textPlaceholdLabel.text = @"给直播写个标题吧";
    [liveTitleTextView addSubview:textPlaceholdLabel];

    UIView *liveClassView = [[UIView alloc]initWithFrame:CGRectMake(preMiddleView.left, preMiddleView.bottom + 10, preMiddleView.width, 50)];
    liveClassView.backgroundColor = RGB_COLOR(@"#000000", 0.15);
    liveClassView.layer.cornerRadius = 5;
    [_preFrontView addSubview:liveClassView];
    classTipL = [[UILabel alloc]init];
    classTipL.text = @"请选择直播分类";
    classTipL.textColor = RGB_COLOR(@"#ffffff", 1);
    classTipL.font = SYS_Font(14);
    [liveClassView addSubview:classTipL];
    [classTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liveClassView).offset(15);
        make.centerY.equalTo(liveClassView);
        make.right.equalTo(liveClassView).offset(-35);
    }];
    UIImageView *classRightImgV = [[UIImageView alloc]init];
    classRightImgV.image = [UIImage imageNamed:@"pre_right"];
    [liveClassView addSubview:classRightImgV];
    [classRightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(liveClassView);
        make.right.equalTo(liveClassView).offset(-13);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(14);
    }];
    UIButton *liveClassBtn = [UIButton buttonWithType:0];
    liveClassBtn.frame = CGRectMake(0, 0, liveClassView.width, liveClassView.height);
    [liveClassBtn addTarget:self action:@selector(showAllClassView) forControlEvents:UIControlEventTouchUpInside];
    [liveClassView addSubview:liveClassBtn];

    //开播按钮
    startLiveBtn = [UIButton buttonWithType:0];
    startLiveBtn.layer.cornerRadius = 20.0;
    startLiveBtn.layer.masksToBounds = YES;
    [startLiveBtn setBackgroundColor:normalColors];
//    [startLiveBtn setBackgroundImage:[UIImage imageNamed:@"startLive_back"]];
    [startLiveBtn addTarget:self action:@selector(doHidden:) forControlEvents:UIControlEventTouchUpInside];
    [startLiveBtn setTitle:@"开始直播" forState:0];
    startLiveBtn.userInteractionEnabled = NO;
    startLiveBtn.alpha = 0.5;
    startLiveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_preFrontView addSubview:startLiveBtn];
    [startLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_preFrontView).offset(-80-ShowDiff);
        make.width.equalTo(_preFrontView).multipliedBy(0.8);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(_preFrontView);
    }];
    //美颜
    UIButton *preFitterBtn = [UIButton buttonWithType:0];
    [preFitterBtn setTitle:@"美颜" forState:0];
    [preFitterBtn setImage:[UIImage imageNamed:@"pre_fitter"] forState:0];
    preFitterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [preFitterBtn addTarget:self action:@selector(showFitterView) forControlEvents:UIControlEventTouchUpInside];
    [_preFrontView addSubview:preFitterBtn];
    [preFitterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(startLiveBtn.mas_top).offset(-15);
        make.centerX.equalTo(startLiveBtn);
        make.height.mas_equalTo(30);
    }];
}
#pragma mark ============定位开关=============
- (void)locationSwitchBtnClick{
//    if ([locationLabel.text isEqual:YZMsg(@"开定位")]) {
//        loactionImgView.image = [UIImage imageNamed:@"pre_location"];
//        locationLabel.text = [cityDefault getMyCity];
//        locationSwitch = YES;
//    }else{
//        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:@"关闭定位，直播不会被附近的人看到，直播间人数可能会减少，确认关闭吗？" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            locationSwitch = YES;
//        }];
//        [cancleAction setValue:RGB_COLOR(@"#969696", 1) forKey:@"_titleTextColor"];
//
//        [alertContro addAction:cancleAction];
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"坚决关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            loactionImgView.image = [UIImage imageNamed:@"pre_location_off"];
//            locationLabel.text = YZMsg(@"开定位");
//            locationSwitch = NO;
//         }];
//        [sureAction setValue:normalColors forKey:@"_titleTextColor"];
//        [alertContro addAction:sureAction];
//        [self presentViewController:alertContro animated:YES completion:nil];
//
//    }
}
#pragma mark -- 切换摄像头

-(void)rotateCamera{
    [_txLivePublisher switchCamera];
    [_txLivePublisher setMirror:_txLivePublisher.config.frontCamera];
}

#pragma mark -- 选择封面
-(void)doUploadPicture{
    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePC.allowCameraLocation = YES;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.showSelectBtn = NO;
    imagePC.allowCrop = YES;
    imagePC.allowPickingOriginalPhoto = NO;
    imagePC.scaleAspectFillCrop = YES;
    imagePC.photoWidth = 350;
    imagePC.photoPreviewMaxWidth = 300;
    imagePC.cropRect = CGRectMake(0, (_window_height-_window_width*1.1)/2, _window_width, _window_width*1.1);
    [self presentViewController:imagePC animated:YES completion:nil];

}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (photos.count > 0) {
        thumbImage = [photos firstObject];
        [preThumbBtn setImage:thumbImage forState:UIControlStateNormal];
        thumbLabel.text = @"更换封面";
        thumbLabel.backgroundColor = RGB_COLOR(@"#0000000", 0.3);
    }
    [self changeStartLiveButtonState];

}



- (void)textViewDidChange:(UITextView *)textView

{
    if (textView.text.length == 0) {
        textPlaceholdLabel.text = @"给直播写个标题吧";
    }else{
        textPlaceholdLabel.text = @"";
    }
    [self changeStartLiveButtonState];

}
#pragma mark -- 选择直播分类

- (void)showAllClassView{
    startLiveClassVC *vc = [[startLiveClassVC alloc]init];
    vc.classID = liveClassID;
    vc.block = ^(NSDictionary * _Nonnull dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            liveClassID = minstr([dic valueForKey:@"id"]);
            classTipL.text = minstr([dic valueForKey:@"name"]);
            [self changeStartLiveButtonState];
        });
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark -- 展示美颜

- (void)showFitterView{
    _preFrontView.hidden = YES;
        [self userTXBase];
}
#pragma mark -- 开播按钮点击
-(void)doHidden:(UIButton *)sender{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"权限受阻" message:@"请在设置中开启相机权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"权限受阻" message:@"请在设置中开启麦克风权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            return ;
            
        }
        
    }];
    [self creatRoom];
}
//创建房间
-(void)creatRoom{
    [MBProgressHUD showMessage:@""];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@upload/image",purl];
    [session POST:url parameters:nil headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (thumbImage) {
            
//            UIImage *img = UIImagePNGRepresentation(thumbImage);
            [formData appendPartWithFileData:UIImageJPEGRepresentation(thumbImage,0.5) name:@"file" fileName:[WYToolClass getNameBaseCurrentTime:@"livethumb.png"] mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];

        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([code isEqual:@"200"]) {
            [self creatRommStepSecond:minstr([data valueForKey:@"url"])];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[data valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];

}
- (void)creatRommStepSecond:(NSString *)thumbUrl{
    NSString *deviceinfo = [NSString stringWithFormat:@"%@_%@_%@",[WYToolClass getCurrentDeviceModel],[[UIDevice currentDevice] systemVersion],[WYToolClass getNetworkType]];
    NSDictionary *dic = @{
        @"title":minstr(liveTitleTextView.text),
        @"thumb":thumbUrl,
        @"classid":liveClassID,
        @"province":@"",
        @"city":@"",//minstr([cityDefault getMyCity])
        @"deviceinfo":deviceinfo,
        @"source":@"2"
    };
    [WYToolClass postNetworkWithUrl:@"live/start" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        [_preFrontView removeFromSuperview];
        _preFrontView = nil;
        _roomDic = [info mutableCopy];
        [_roomDic setObject:[Config getOwnID] forKey:@"uid"];
        [_roomDic setObject:[Config getavatar] forKey:@"avatar"];
        [_roomDic setObject:[Config getOwnNicename] forKey:@"nickname"];
        [_roomDic setObject:thumbUrl forKey:@"thumb"];
        [_roomDic setObject:minstr([dic valueForKey:@"title"]) forKey:@"title"];

        [self startUI];
    } fail:^{
        
    }];
}
-(void)startUI{
    _frontView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    _frontView.clipsToBounds = YES;
    [self.view addSubview:_frontView];
    [self.view insertSubview:_frontView atIndex:3];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setView];//加载信息页面
        [self hideBTN];
    });
    //倒计时动画
    animationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    animationBackView.opaque = YES;
    aniLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    aniLabel1.textColor = [UIColor whiteColor];
    aniLabel1.font = [UIFont systemFontOfSize:90];
    aniLabel1.text = @"3";
    aniLabel1.textAlignment = NSTextAlignmentCenter;
    aniLabel1.center = animationBackView.center;
    aniLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    aniLabel2.textColor = [UIColor whiteColor];
    aniLabel2.font = [UIFont systemFontOfSize:90];
    aniLabel2.text = @"2";
    aniLabel2.textAlignment = NSTextAlignmentCenter;
    aniLabel2.center = animationBackView.center;
    aniLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    aniLabel3.textColor = [UIColor whiteColor];
    aniLabel3.font = [UIFont systemFontOfSize:90];
    aniLabel3.text = @"1";
    aniLabel3.textAlignment = NSTextAlignmentCenter;
    aniLabel3.center = animationBackView.center;
    aniLabel1.hidden = YES;
    aniLabel2.hidden = YES;
    aniLabel3.hidden = YES;
    [animationBackView addSubview:aniLabel3];
    [animationBackView addSubview:aniLabel1];
    [animationBackView addSubview:aniLabel2];
    [_frontView addSubview:animationBackView];
    [self kaishidonghua];
    self.view.backgroundColor = [UIColor clearColor];
}
//开始321
-(void)kaishidonghua{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        aniLabel1.hidden = NO;
        [self donghua:aniLabel1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        aniLabel1.hidden = YES;
        aniLabel2.hidden = NO;
        [self donghua:aniLabel2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        aniLabel2.hidden = YES;
        aniLabel3.hidden = NO;
        [self donghua:aniLabel3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        aniLabel3.hidden = YES;
        animationBackView.hidden = YES;
        [animationBackView removeFromSuperview];
        animationBackView = nil;
        [self showBTN];
        [self getStartShow];//请求直播
    });
}
//请求直播
-(void)getStartShow
{
    _hostURL = minstr([_roomDic valueForKey:@"push"]);

    _socketL = [[socketLive alloc]init];
    _socketL.delegate = self;
    [_socketL addNodeListen:minstr([_roomDic valueForKey:@"chatserver"]) andRoomMessage:_roomDic];

    [self txStartRtmp];
    // for test
    [self changePlayState:1];
}

-(void)donghua:(UILabel *)labels{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 4.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 3.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;//是不是移除动画的效果
    animation.fillMode = kCAFillModeForwards;//保持最新状态
    [labels.layer addAnimation:animation forKey:nil];
}
//创建直播间视图按钮
- (void)setView{
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
    userNumLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkUseList)];
    [userNumLabel addGestureRecognizer:tap];
    userNumLabel.layer.cornerRadius = 15;
    userNumLabel.layer.masksToBounds = YES;
    [_frontView addSubview:userNumLabel];
    [userNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeRoomBtn.mas_left).offset(-10);
        make.centerY.height.equalTo(closeRoomBtn);
        make.width.mas_greaterThanOrEqualTo(40);
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
        make.bottom.equalTo(_frontView).offset(-10-ShowDiff);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(128);
    }];
    
    moreBtn = [UIButton buttonWithType:0];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"功能"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"功能_s"] forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(showmoreview) forControlEvents:UIControlEventTouchUpInside];
    [_frontView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chatBtn);
        make.right.equalTo(_frontView).offset(-10);
        make.width.height.mas_equalTo(36);
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
    heartTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showHeart) userInfo:nil repeats:YES];
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
        [_socketL sendMessage:textField.text andisAtt:@"0" userType:kAnchorUser];
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
    UIImageView *iconImgView = [[UIImageView alloc]init];
    iconImgView.layer.cornerRadius = 15;
    iconImgView.layer.masksToBounds = YES;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
    [leftView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(leftView).offset(2);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.font = SYS_Font(14);
    nameL.textColor = [UIColor whiteColor];
    nameL.text = [Config getOwnNicename];
    [leftView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView).offset(3);
        make.left.equalTo(iconImgView.mas_right).offset(4);
        make.right.lessThanOrEqualTo(leftView).offset(-14);
    }];
    
    UIImageView *likeImgView = [[UIImageView alloc]init];
    likeImgView.image = [UIImage imageNamed:@"likeImage"];
    likeImgView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:likeImgView];
    [likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.width.height.mas_equalTo(9);
        make.bottom.equalTo(iconImgView).offset(-1);
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
//展示底部按钮
- (void)showBTN{
    closeRoomBtn.hidden = NO;
    userNumLabel.hidden = NO;
    chatBtn.hidden = NO;
    moreBtn.hidden = NO;
}
//隐藏底部按钮
- (void)hideBTN{
    closeRoomBtn.hidden = YES;
    userNumLabel.hidden = YES;
    chatBtn.hidden = YES;
    moreBtn.hidden = YES;
}
#pragma mark - 警告弹窗
- (void)jinggaoUser:(NSString *)content{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 在线用户列表相关
- (void)checkUseList{
    if (!onlineList) {
        onlineList = [[LiveOnlineList alloc] initWithFrame:CGRectMake(0, 0, _window_width, _window_height) stream:_roomDic[@"stream"] liveUID:[Config getOwnID]];
        onlineList.delegate = self;
    }
    [onlineList requestData];
    [self.view addSubview:onlineList];
}
//delegate
- (void)showUserToast:(chatModel *)model {
    [self showUserPopupView:model isonline:YES];
}

#pragma mark -- 改变开播按钮的状态
- (void)changeStartLiveButtonState{
    if (thumbImage && liveTitleTextView.text.length > 0 && ![liveClassID isEqual:@"未选择"]) {
        startLiveBtn.userInteractionEnabled = YES;
        startLiveBtn.alpha = 1;
    }else{
        startLiveBtn.userInteractionEnabled = NO;
        startLiveBtn.alpha = 0.5;
    }
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
    if (model.userID && model.userID.length > 0 && ![model.userID isEqual:[Config getOwnID]]) {
        [self showUserPopupView:model isonline:NO];
    }
}
#pragma mark -- 用户弹窗相关
- (void)showUserPopupView:(chatModel *)model isonline:(BOOL)isOnline{
    if (userPview) {
        [userPview removeFromSuperview];
        userPview = nil;
    }
    userPview = [[userPopupView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andModel:model liveUid:[Config getOwnID]];
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
//踢出房间
- (void)anchorKickUser:(NSString *)touid{
    
}
- (void)setAdminUser:(NSString *)userID andUserName:(NSString *)uname{
    [_socketL setAdmin:userID andName:uname];
}
-(void)cancelAdminUser:(NSString *)userID andUserName:(NSString *)uname{
    [_socketL cancelSetAdmin:userID andName:uname];
}
#pragma mark -- 回到后台
-(void)backgroundselector{
    backTime +=1;
    NSLog(@"返回后台时间%d",backTime);
    if (backTime > 60) {
        [self getCloseShow];
    }
}
-(void)backGround{
    //进入后台
    if (!backGroundTimer) {
        [self sendEmccBack];
        backGroundTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backgroundselector) userInfo:nil repeats:YES];
    }
}
-(void)forwardGround{
    if (backTime != 0) {
//        [_socketL sendMessage:@"主播回来了"];
    }
    //进入前台
    if (backTime > 60) {
        [self getCloseShow];
    }
    [backGroundTimer invalidate];
    backGroundTimer  = nil;
    backTime = 0;
}
-(void)appactive{
    NSLog(@"哈哈哈哈哈哈哈哈哈哈哈哈 app回到前台");
    [_socketL sendRoomSystemNotMessage:@"主播回来了！"];
    [_txLivePublisher resumePush];
}
-(void)appnoactive{
    [_socketL sendRoomSystemNotMessage:@"主播离开一下，精彩不中断，不要走开哦"];
    [_txLivePublisher pausePush];
    NSLog(@"0000000000000000000 app进入后台");
}
-(void)sendEmccBack {
//    [_socketL phoneCall:YZMsg(@"主播离开一下，精彩不中断，不要走开哦")];
}

#pragma mark ============电话监听=============
- (void)reciverPhoneCall{
    [self appnoactive];
}
- (void)phoneCallEnd{
    [self appactive];

}
#pragma mark -- 关闭直播
- (void)showCloseAlert{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:@"确定退出直播吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getCloseShow];
    }];
    [sureAction setValue:normalColors forKey:@"_titleTextColor"];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];

}
-(void)getCloseShow
{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"live/stop" andParameter:@{@"stream":minstr([_roomDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        [_socketL closeRoom];//发送关闭直播的socket
        [_socketL colseSocket];//注销socket
        _socketL = nil;//注销socket
        [self txStopRtmp];
        [self invalidateTimer];
        [self requestLiveAllTimeandVotes];

    } fail:^{
        [_socketL closeRoom];//发送关闭直播的socket
        [_socketL colseSocket];//注销socket
        _socketL = nil;//注销socket
        [self txStopRtmp];
        [self invalidateTimer];
        [self requestLiveAllTimeandVotes];

    }];
}
#pragma mark -- 注销计时器
- (void)invalidateTimer{
    if (heartTimer) {
        [heartTimer invalidate];
        heartTimer = nil;
    }
    if (backGroundTimer) {
        [backGroundTimer invalidate];
        backGroundTimer = nil;
    }
    if (reloadTimer) {
        [reloadTimer invalidate];
        reloadTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
#pragma mark ================ 直播结束 ===============
- (void)requestLiveAllTimeandVotes{
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
    [headerImgView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]] placeholderImage:[UIImage imageNamed:@"bg1"]];
    headerImgView.layer.masksToBounds = YES;
    headerImgView.layer.cornerRadius = 50;
    [lastView addSubview:headerImgView];

    
    UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,50, backView.width, backView.height*0.55-50)];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = [Config getOwnNicename];
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
    [button addTarget:self action:@selector(doNewRoom) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:normalColors];
//    [button setBackgroundImage:[UIImage imageNamed:@"startLive_back"]];

    [button setTitle:@"返回首页" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds  =YES;
    [lastView addSubview:button];
    [self.view addSubview:lastView];
    
}
- (void)doNewRoom{
    [self.navigationController popViewControllerAnimated:YES];
//    LivebroadViewController *vc = [[LivebroadViewController alloc]init];
//    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
#pragma mark ================ 直播结束 ===============

#pragma mark -- 展示输入框
- (void)showToolbarView{
    if (moreMenuView) {
        moreMenuView.hidden = YES;
        moreBtn.selected = NO;
    }
    [_inputTextView becomeFirstResponder];
//    NSDictionary *dic = @{
//        @"id":@"1",
//        @"userName":@"张三",
//        @"contentChat":@"sdffwewfewffw水电费舒舒服服是分身乏术分身乏术三方分身乏术分身乏术防辐射啥地方放松放松放松",
//        @"type":@"1",
//        @"isAnchor":@"1",
//        @"uhead":@""
//    };
//    chatModel *model = [[chatModel alloc]initWithDic:dic];
//    [_chatArray addObject:model];
//    [_chatTableView reloadData];
//    [self jumpLast];
}
- (void)jumpLast{
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatArray.count-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
#pragma mark -- 底部更多按钮点击
- (void)showmoreview{
    if (!moreMenuView) {
        moreMenuView = [[anchorMoreMenuView alloc]initWithFrame:CGRectMake(10, _window_height-46-ShowDiff-100, _window_width-20, 97.5)];
        WeakSelf;
        moreMenuView.block = ^(NSString * _Nonnull name) {
            if ([name isEqual:@"翻转"]) {
                [weakSelf rotateCamera];
            }
            if ([name isEqual:@"闪光灯"]) {
                [weakSelf toggleTorch];
            }
            if ([name isEqual:@"美颜"]) {
                [weakSelf showFitterView];
            }
            if ([name isEqual:@"分享"]) {
                [weakSelf doShare];
            }
            moreMenuView.hidden = YES;
            moreBtn.selected = NO;
        };
        [self.view addSubview:moreMenuView];
    }
    moreMenuView.isTorch = isTorch;
    moreMenuView.hidden = NO;
    moreBtn.selected = YES;

}
#pragma mark -- 闪光灯
-(void)toggleTorch{
    isTorch = !isTorch;
    if (![_txLivePublisher toggleTorch:isTorch]) {
        isTorch = !isTorch;
    }
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
#pragma mark -- 飘心展示
- (void)showHeart{
    heartShowCount = arc4random()%5 + 1;
    [self socketLight];
}
-(void)socketLight{
    CGFloat starX = moreBtn.frame.origin.x ;
    CGFloat starY = moreBtn.frame.origin.y - 30;
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
    heartShowCount --;
    if (heartShowCount > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self socketLight];
        });
    }
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
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
        haohualiwuV = [[expensiveGiftV alloc]initWithIsPlat:isPlat];
        haohualiwuV.delegate = self;
        [self.view insertSubview:haohualiwuV atIndex:8];
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
#pragma mark -- 检测直播状态，防止断流或者其他情况服务端给主播关播了 主播还在直播
- (void)checkLiveState{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"checklive?stream=%@",minstr([_roomDic valueForKey:@"stream"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            if (![minstr([info valueForKey:@"islive"]) isEqual:@"1"]) {
                [self getCloseShow];
            }
        }
    } Fail:^{
        
    }];

}
- (void)reloadRoomMessage{
    [self getRoomLikeNums];
    [self getRoomUserNums];
    [self getRoomSellerGoodsNums];
    [self checkLiveState];
}


#pragma mark -- socket代理相关
-(void)setAdmin:(NSDictionary *)msg action:(NSString *)action{
    NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];

    if ([touid isEqual:[Config getOwnID]]) {
//        if ([action isEqual:@"0"]) {
//            usertype = @"0";
//        }else{
//            usertype = @"40";
//        }
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
///直播关闭
- (void)LiveEnd{
    [self getCloseShow];
}

- (void)shajincheng{
    [self getCloseShow];
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
