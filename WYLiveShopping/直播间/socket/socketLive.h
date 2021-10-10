//
//  socketLive.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketIO/SocketIO-Swift.h>
@protocol socketLiveDelegate <NSObject>
//收到聊天消息
- (void)reciveMessage:(NSDictionary *)dic;
//用户进入房间
- (void)userEnterRoom:(NSDictionary *)dic;
//用户离开房间
- (void)userLeaveRoom;
//禁言
- (void)anchorShutUser:(NSString *)touid andAction:(int)action content:(NSString *)content;
//踢出房间
- (void)anchorKickUser:(NSString *)touid;
///直播关闭
- (void)LiveEnd;
//关注等系统消息
-(void)setSystemNot:(NSString *)msg;
//设置管理员
-(void)setAdmin:(NSDictionary *)msg action:(NSString *)action;
//送礼物
-(void)sendGift:(NSDictionary *)msg andLiansong:(NSString *)liansong andTotalCoin:(NSString *)votestotal andGiftInfo:(NSDictionary *)giftInfo andCt:(NSDictionary *)ct;
- (void)jinggaoUser:(NSString *)content;
@optional
@end
@interface socketLive : NSObject

@property(nonatomic,weak)id<socketLiveDelegate>delegate;
@property(nonatomic,strong)NSDictionary *roomDic;
//连接socket
-(void)addNodeListen:(NSString *)socketUrl andRoomMessage:(NSDictionary *)roomDic;//添加cosket监听
//断开socket连接
-(void)colseSocket;
-(void)closeRoom;
-(void)userLeaveRoom;
//超管关播
- (void)superAdminCloseLive;
///发送聊天消息
/// @param text 聊天内容
/// @param isAtt 是否关注主播
-(void)sendMessage:(NSString *)text andisAtt:(NSString *)isAtt userType:(NSString *)usertype;

/// 禁言用户
/// @param touid 被禁言用户ID
/// @param toname 被禁言用户昵称
/// @param action 1=禁言 2=解除
-(void)shutUpUser:(NSString *)touid andName:(NSString *)toname andAction:(NSString *)action content:(NSString *)content;
/// 踢出用户
/// @param touid 被踢出用户ID
/// @param toname 被踢出用户昵称
-(void)kickUser:(NSString *)touid andName:(NSString *)toname;

/// 设置管理员
/// @param touid 被设置管理的用户ID
/// @param toname 被设置为管理的用户昵称
-(void)setAdmin:(NSString *)touid andName:(NSString *)toname;

/// 发送直播间系统消息
/// @param message 消息内容
- (void)sendRoomSystemNotMessage:(NSString *)message;
///点赞=点亮
- (void)startLike;
//取消管理员
- (void)cancelSetAdmin:(NSString *)touid andName:(NSString *)toname;
//送礼物
-(void)sendGiftAndINfo:(NSString *)info andlianfa:(NSString *)lianfa;
@end
