//
//  continueGift.m
//  yunbaolive
//
//  Created by 王敏欣 on 2016/11/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "continueGift.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"

@implementation continueGift{
//    UIButton *prizeBtn;
}


-(void)GiftPopView:(NSDictionary *)giftData andLianSong:(NSString *)liansong
{
    
    _newheight = 5;
    
    _haohualiwus = liansong;
    
    NSNumber *uid       = [giftData valueForKey:@"uid"];
    int giftid = [[giftData valueForKey:@"giftid"] intValue];
    NSString *nicename  = [giftData valueForKey:@"nicename"];
    NSString *giftname  = [giftData valueForKey:@"giftname"];
    NSString *giftcount =  [NSString stringWithFormat:@"%@",[giftData valueForKey:@"giftcount"]] ;
//    NSString *giftcount = @"1";
    NSString *avatar    = [giftData valueForKey:@"avatar"];
    NSString *gifticon  = [giftData valueForKey:@"gifticon"];
    NSString *level  = [giftData valueForKey:@"level"];
    NSString *content   = [NSString stringWithFormat:@"送 %@",giftname];
    BOOL isLucky = [minstr([giftData valueForKey:@"mark"]) isEqual:@"3"] ? YES : NO;
    UIView * GiftPopView = [[UIView alloc] init];//礼物
    CFGradientLabel *labGiftNum = [[CFGradientLabel alloc] init];//礼物数量
    int tagID = [uid intValue]+60000+giftid + [minstr([giftData valueForKey:@"giftcount"]) intValue];
    NSInteger btnTag = [uid intValue]*99+giftid*88+[minstr([giftData valueForKey:@"giftcount"]) intValue];
    labGiftNum.tag = [uid intValue]+60000+giftid + [minstr([giftData valueForKey:@"giftcount"]) intValue];
    int height = 66;
    int width = 270;
    int x = 5;
    int flag = 0;
        if (_popListItem1!=0) {
            if (_popListItem1 == tagID && _previousGiftID1 == [giftData valueForKey:@"giftid"]) {
                _popShowTime1=3;
                [self GiftNumAdd:tagID];
                if ([minstr([giftData valueForKey:@"isluck"]) isEqual:@"1"]) {
                    UIButton *btn = (UIButton*)[self viewWithTag:btnTag];
                    [self changePrizeBtnTitle:minstr([giftData valueForKey:@"lucktimes"]) andButton:btn];
                }
                flag = 1;
            }
            else if(_popListItem1 == tagID  && _previousGiftID1 != [giftData valueForKey:@"giftid"])
            {
                [_GiftqueueArray addObject:giftData];
                [self startGiftTimer];
                flag = 1;
                
            }
        }
        if (_popListItem2!=0) {
            if (_popListItem2 == tagID  && _previousGiftID2 == [giftData valueForKey:@"giftid"]) {
                _popShowTime2 = 3;
                [self GiftNumAdd:tagID];
                if ([minstr([giftData valueForKey:@"isluck"]) isEqual:@"1"]) {
                    UIButton *btn = (UIButton*)[self viewWithTag:btnTag];
                    [self changePrizeBtnTitle:minstr([giftData valueForKey:@"lucktimes"]) andButton:btn];
                }

                flag = 1;
            }
            else  if(_popListItem2 == tagID  && _previousGiftID1 != [giftData valueForKey:@"giftid"])
            {
                //如果换了礼物则替换礼物
                [_GiftqueueArray addObject:giftData];
                [self startGiftTimer];
                flag = 1;
            }
    }
    if (flag == 1) {
        
        return;
    }
    int y = 0;
    if (_GiftPosition ==0) {//全空显示在第一
        y = _newheight;
        _GiftPosition = 1;
        _popListItem1 = (int)labGiftNum.tag;
        _previousGiftID1 = [giftData valueForKey:@"giftid"];
        
        
    }
    else if(_GiftPosition ==1)//一位有显示在二
    {
        y = _newheight+height+5;
        _GiftPosition = 3;
        _popListItem2 = (int)labGiftNum.tag;
        _previousGiftID2 = [giftData valueForKey:@"giftid"];
        
    }
    else if (_GiftPosition == 2)//二为有显示在一
    {
        y = _newheight;
        _GiftPosition = 3;
        _popListItem1 = (int)labGiftNum.tag;
        _previousGiftID1 = [giftData valueForKey:@"giftid"];
        
    }
    else                       //全有执行队列
    {
        y = 0;
    }
    if(y==0)//当前位置已满，启动队列
    {
        [_GiftqueueArray addObject:giftData];
        [self startGiftTimer];
        return;
    }
    [self addSubview:GiftPopView];

    [GiftPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(x);
        make.top.equalTo(self).offset(y);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    UIImageView *animationImgView = [[UIImageView alloc]init];
    if (isLucky) {
        animationImgView.image = [UIImage imageNamed:@"gift_lucky_anima1"];
    }else{
        animationImgView.image = [UIImage imageNamed:@"gift_anima1"];
    }
    [GiftPopView addSubview:animationImgView];
    [animationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(GiftPopView).offset(-270);
        make.top.equalTo(GiftPopView);
        make.height.mas_equalTo(66);
        make.width.mas_equalTo(width);
    }];

    GiftPopView.backgroundColor = [UIColor clearColor];
    //pop背景图
    UIImageView *giftBGView = [[UIImageView alloc] init];
    if (isLucky) {
        giftBGView.image = [UIImage imageNamed:@"giftBG_lucky"];
    }else{
        giftBGView.image = [UIImage imageNamed:@"giftBG"];
    }
    giftBGView.contentMode = UIViewContentModeScaleAspectFill;
    [GiftPopView addSubview:giftBGView];
    [giftBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(GiftPopView);
        make.top.equalTo(GiftPopView);
        make.height.mas_equalTo(66);
        make.width.mas_equalTo(width);
    }];
    

    //用户    显示头像
    UIImage *headerImg = [UIImage imageNamed:@"bg1"];
    UIImageView *headerView = [[UIImageView alloc] init];
    [headerView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:headerImg];
    headerView.layer.masksToBounds = YES;
    [headerView.layer setCornerRadius:20];
    [giftBGView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(giftBGView).offset(7);
        make.top.equalTo(giftBGView).offset(13);
        make.height.width.mas_equalTo(40);
    }];

    //礼物名称
    UILabel *labName = [[UILabel alloc] init];
    labName.text = nicename;
    labName.font = SYS_Font(15);
    labName.textColor = [UIColor whiteColor];
    [giftBGView addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_right).offset(5);
        make.top.equalTo(headerView).offset(3);
        make.height.mas_equalTo(19);
        make.width.mas_lessThanOrEqualTo(105);
    }];

    //礼物信息
    UILabel *labContent = [[UILabel alloc] init];
    labContent.textColor = [UIColor whiteColor];
    labContent.tag = tagID+68959;
    labContent.font = SYS_Font(15);
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange redRange = NSMakeRange(2, minstr([giftData valueForKey:@"giftname"]).length);
    [contentStr addAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(@"#FFDD00", 1),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:redRange];

    [labContent setAttributedText:contentStr];

    [giftBGView addSubview:labContent];
    [labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_right).offset(5);
        make.top.equalTo(labName.mas_bottom);
        make.height.mas_equalTo(15);
    }];

    
    //礼物图片
    UIImageView *giftImage = [[UIImageView alloc] init];
    NSURL *giftImageURL = [NSURL URLWithString:gifticon];
    giftImage.tag = [uid intValue]+20000+giftid + [minstr([giftData valueForKey:@"giftcount"]) intValue];
    [giftImage sd_setImageWithURL:giftImageURL];
    [giftBGView addSubview:giftImage];
    [giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(labName.mas_right).offset(3);
        make.left.greaterThanOrEqualTo(labContent.mas_right).offset(5);
//        make.top.equalTo(giftBGView).offset(-15);
        make.centerY.equalTo(giftBGView);
        make.height.width.mas_equalTo(40);
    }];
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-8 * (CGFloat)M_PI / 180), 1, 0, 0);

    UILabel *numL = [[UILabel alloc]init];
    numL.font = [UIFont boldSystemFontOfSize:15];
    numL.textColor = [UIColor whiteColor];
    [giftBGView addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(labName).offset(-2);
        make.left.equalTo(giftImage.mas_right).offset(8);
    }];
    
    CFGradientLabel *giftXL = [[CFGradientLabel alloc] init];
    giftXL.outLinetextColor = RGB_COLOR(@"#FFDD00", 1);
    giftXL.outLineWidth = 1.5;
    giftXL.font = [UIFont boldSystemFontOfSize:15];
    giftXL.labelTextColor = RGB_COLOR(@"#FFDD00", 1);
    
    
    
    giftXL.transform = matrix;
    [giftBGView addSubview:giftXL];
    [giftXL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numL.mas_left);
        make.top.equalTo(labContent).offset(-2);
        make.height.mas_equalTo(20);
    }];
    if ([giftcount isEqual:@"1"]) {
        numL.text = @"";
        giftXL.text = @"X";
    }else{
        numL.text = [NSString stringWithFormat:@"x%@",giftcount];
        giftXL.text = @"连送  X";
    }

//    [giftXImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(giftImage.mas_right);
//        make.top.equalTo(giftBGView).offset(-15);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(56);
//    }];
    
    //礼物数量
   labGiftNum.outLinetextColor = RGB_COLOR(@"#FFDD00", 1);
    labGiftNum.outLineWidth  = 2;
    labGiftNum.text = @"1";
    labGiftNum.font = [UIFont boldSystemFontOfSize:40];
    labGiftNum.labelTextColor = RGB_COLOR(@"#FFDD00", 1);
   // labGiftNum.colors = @[(id)RGB_COLOR(@"#FFDD00", 1).CGColor ,(id)RGB_COLOR(@"#FFF47C", 1).CGColor];
    labGiftNum.transform = matrix;
    [giftBGView addSubview:labGiftNum];
    [labGiftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(giftXL.mas_right).offset(8);
        make.centerY.equalTo(giftBGView.mas_centerY);
    }];
    
    
//    [leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(giftBGView).offset(-3);
//        make.bottom.equalTo(giftBGView).offset(3);
//        make.right.equalTo(giftBGView.mas_left).offset(30);
//        make.width.mas_equalTo(115);
//    }];
    
    
//    [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(giftBGView).offset(-3);
//        make.bottom.equalTo(giftBGView).offset(3);
//        make.right.equalTo(giftBGView.mas_right).offset(55);
////        make.width.equalTo(rightImgV.mas_height).offset(1.65);
//        make.width.mas_equalTo(115);
//
//    }];

    [self layoutIfNeeded];
    UIImageView *leftImgV;
    UIImageView *rightImgV;
    if (isLucky) {
        leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(-80, -3, 115, 72)];
        leftImgV.image = [UIImage imageNamed:@"gift_leftWhite"];
        //    leftImgV.hidden = YES;
        [giftBGView addSubview:leftImgV];
        
        rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(giftBGView.width-50, -3, 115, 72)];
        rightImgV.image = [UIImage imageNamed:@"gift_rightWhite"];
        //    rightImgV.hidden = YES;
        [giftBGView addSubview:rightImgV];
        
        UIButton *prizeBtn = [UIButton buttonWithType:0];
        [prizeBtn setBackgroundImage:[UIImage imageNamed:@"gift_prize"] forState:0];
        prizeBtn.layer.cornerRadius = 3.0;
        prizeBtn.layer.masksToBounds = YES;
        prizeBtn.frame = CGRectMake(-14, 57-7, 50, 14);
        prizeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        prizeBtn.titleLabel.transform = matrix;
        prizeBtn.hidden = YES;
        prizeBtn.tag = btnTag;
        [giftBGView addSubview:prizeBtn];
        if ([minstr([giftData valueForKey:@"isluck"]) isEqual:@"1"]) {
            [self changePrizeBtnTitle:minstr([giftData valueForKey:@"lucktimes"]) andButton:prizeBtn];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        [animationImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(x);
            make.top.equalTo(self).offset(y);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width+20);
        }];
        [GiftPopView layoutIfNeeded];
        if (isLucky) {
            leftImgV.x = giftBGView.width-50;
            rightImgV.x = 0;
            leftImgV.alpha = 0;
            rightImgV.alpha = 0;
        }

        [self layoutIfNeeded];

    } completion:^(BOOL finished) {
        if (isLucky) {
            animationImgView.image = [UIImage imageNamed:@"git_lucky_bg"];
        }else{
            animationImgView.image = [UIImage imageNamed:@"gift_anima2"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [animationImgView removeFromSuperview];
            });

        }
    }];
    if (isLucky) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [leftImgV removeFromSuperview];
            [rightImgV removeFromSuperview];
        });
    }

    if(_GiftPosition == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(hideGiftPop1:) withObject:GiftPopView  waitUntilDone:NO];
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(hideGiftPop2:) withObject:GiftPopView  waitUntilDone:NO];
        });
    }
}
-(void)startGiftTimer
{
    if (_GiftqueueTIME==nil) {
        _GiftqueueTIME = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(EnGiftqueue) userInfo:nil repeats:YES];
    }
}
-(int)returnGiftPos:(int)height
{
    int y = 0;
    if (_GiftPosition ==0) {//全空显示在第一
        y = _newheight;
        _GiftPosition = 1;
    }
    else if(_GiftPosition ==1)//一位有显示在二
    {
        y = _newheight+height+5;
        _GiftPosition = 3;
    }
    else if (_GiftPosition == 2)//二为有显示在一
    {
        y = _newheight;
        _GiftPosition = 3;
    }
    else                       //全有执行队列
    {
        y = 0;
    }
    
    return y;
}
-(void)hideGiftPop2:(UIView *)agr
{
    UIView *GiftPopView = agr;
    int height = _window_height/15;
    int width = _window_width/2;
    
    
    if (_popListItem2 != 0) {
        //判断显示时间 如果显示时间大于0则继续递归 否则 让其消失
        
        if (_popShowTime2 >0) {
            _popShowTime2 -= 0.5;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self performSelectorOnMainThread:@selector(hideGiftPop2:) withObject:GiftPopView  waitUntilDone:NO];
            });
        }
        else
        {
            [UIView animateWithDuration:0.8 animations:^{
                GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
                GiftPopView.alpha = 0;
                
                if (GiftPopView.frame.origin.y<= _newheight) {
                    //移除一级弹出
                    _popListItem1 = 0;
                    if(_GiftPosition == 3)
                        _GiftPosition = 2;//如果现在上下都有则设置成仅下有
                    else _GiftPosition = 0;                   //否则设置成全无
                }
                else
                {
                    _popListItem2 = 0;
                    //移除二级弹出
                    if(_GiftPosition == 3)   _GiftPosition = 1;//如果现在上下都有则设置成仅上有
                    else _GiftPosition = 0;                   //否则设置成全无
                }
            }];
            
            //0.8秒后删除视图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
            });
            
        }
        return;
    }
    [UIView animateWithDuration:0.8 animations:^{
        GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
        GiftPopView.alpha = 0;
        
        if (GiftPopView.frame.origin.y<= _newheight) {
            //移除一级弹出
            _popListItem1 = 0;
            if(_GiftPosition == 3)
                _GiftPosition = 2;//如果现在上下都有则设置成仅下有
            else _GiftPosition = 0;                   //否则设置成全无
        }
        else
        {
            _popListItem2 = 0;
            //移除二级弹出
            if(_GiftPosition == 3)   _GiftPosition = 1;//如果现在上下都有则设置成仅上有
            else _GiftPosition = 0;                   //否则设置成全无
        }
    }];
    
    
    
    //0.8秒后删除视图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
    });
    
    
}
-(void)hideGiftPop1:(UIView *)agr
{
    
    UIView *GiftPopView = agr;
    int height = _window_height/15;
    int width = _window_width/2;
    
    
    if (_popListItem1 != 0) {
        //判断显示时间 如果显示时间大于0则继续递归 否则 让其消失
        
        if (_popShowTime1 >0) {
            _popShowTime1 -= 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self performSelectorOnMainThread:@selector(hideGiftPop1:) withObject:GiftPopView  waitUntilDone:NO];
            });
        }
        else
        {
            [UIView animateWithDuration:0.8 animations:^{
                GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
                GiftPopView.alpha = 0;
                
                if (GiftPopView.frame.origin.y<= _newheight) {
                    //移除一级弹出
                    _popListItem1 = 0;
                    if(_GiftPosition == 3)
                        _GiftPosition = 2;//如果现在上下都有则设置成仅下有
                    else _GiftPosition = 0;                   //否则设置成全无
                }
                else
                {
                    _popListItem2 = 0;
                    //移除二级弹出
                    if(_GiftPosition == 3)   _GiftPosition = 1;//如果现在上下都有则设置成仅上有
                    else _GiftPosition = 0;                   //否则设置成全无
                }
            }];
            
            //0.8秒后删除视图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
            });
            
        }
        
        
        
        return;
    }
    
    
    
    [UIView animateWithDuration:0.8 animations:^{
        GiftPopView.frame =  CGRectMake(GiftPopView.frame.origin.x, GiftPopView.frame.origin.y-25, width, height);
        GiftPopView.alpha = 0;
        
        if (GiftPopView.frame.origin.y<= _newheight) {
            //移除一级弹出
            _popListItem1 = 0;
            if(_GiftPosition == 3)
                _GiftPosition = 2;//如果现在上下都有则设置成仅下有
            else _GiftPosition = 0;                   //否则设置成全无
        }
        else
        {
            _popListItem2 = 0;
            //移除二级弹出
            if(_GiftPosition == 3)   _GiftPosition = 1;//如果现在上下都有则设置成仅上有
            else _GiftPosition = 0;                   //否则设置成全无
        }
    }];
    
    
    //0.8秒后删除视图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(removeGiftPop:) withObject:GiftPopView  waitUntilDone:NO];
    });
    
    
}
-(void)removeGiftPop:(UIView *)viewa
{
    [viewa removeFromSuperview];
    viewa=nil;
    NSLog(@"礼物送完了");
}
//礼物队列
-(void)EnGiftqueue
{
    NSLog(@"当前队列个数:%lu",(unsigned long)_GiftqueueArray.count);
    if (_GiftqueueArray.count == 0 || _GiftqueueArray == nil) {//判断队列中有item且不是满屏
        [_GiftqueueTIME invalidate];
        _GiftqueueTIME = nil;
        return;
    }
    NSDictionary *Dic = [_GiftqueueArray firstObject];
    [_GiftqueueArray removeObjectAtIndex:0];
    [self GiftPopView:Dic andLianSong:_haohualiwus];
}
//添加礼物数量
-(void)GiftNumAdd:(int)tag
{
    __weak CFGradientLabel *labGiftNum = (CFGradientLabel *)[self viewWithTag:tag];
//    __weak UIImageView *giftIcon = [self viewWithTag:tag-40000];

    int oldnum = [labGiftNum.text intValue];
    int newnum = oldnum +1;
    labGiftNum.text = [NSString stringWithFormat:@"%d",newnum];
    if(labGiftNum == nil)
    {
        return;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:1.5];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:0.8];     //结束伸缩倍数
    
    [labGiftNum.layer addAnimation:animation forKey:nil];
//    [giftIcon.layer addAnimation:animation forKey:nil];
//    labGiftNum.font = [UIFont fontWithName:@"Marker Felt" size:height/2];

//    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    cakanimation.duration = 0.7;
////    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4,4,1.0)];
////    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
//    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
//    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
//    cakanimation.values = @[value3,value4];
//    [labGiftNum.layer addAnimation:cakanimation forKey:nil];
//    cakanimation.removedOnCompletion = NO;
//    cakanimation.fillMode = kCAFillModeForwards;
}
- (void)changePrizeBtnTitle:(NSString *)title andButton:(UIButton *)button{
    button.hidden = YES;
    [button setTitle:[NSString stringWithFormat:@"喜中%@",title] forState:0];
    button.x = -14;
    button.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        button.x = 52;
    }];
}
-(void)stopTimerAndArray{
    _GiftqueueArray = nil;
    _GiftqueueArray = [NSMutableArray array];
    [_GiftqueueTIME invalidate];
    _GiftqueueTIME = nil;
}
-(void)initGift{
    
    _GiftPosition = 0;
    _popListItem1 = 0;
    _popListItem2 = 0;
    _previousGiftID1 = 0;
    _previousGiftID1 = 0;
    _GiftqueueArray = [[NSMutableArray alloc] init];
}
@end
