//
//  socketLive.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "socketLive.h"
#import "NSObject+SBJson.h"
@interface socketLive ()
{
    SocketIOClient *ChatSocket;
    NSString *roomStream;
}
@property(nonatomic,strong)SocketManager *sokManager;
@end

@implementation socketLive
//
-(void)sendMessage:(NSString *)text andisAtt:(NSString *)isAtt userType:(NSString *)usertype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"1",
                                        @"content":text,
                                        @"uid": [Config getOwnID],
                                        @"usernickname": [Config getOwnNicename],
                                        @"avatar":[Config getavatar],
                                        @"isattent": isAtt,
                                        @"usertype":usertype, @"equipment": @"app",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
-(void)userLeaveRoom{
    NSArray *msgData1 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_": @"stopplay",
                                         @"action": @"19",
                                         @"ct":@"直播关闭",
                                         @"msgtype": @"1",
                                
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"equipment": @"app",
                                         @"roomnum": [Config getOwnID]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData1];
    
}
- (void)superAdminCloseLive{
    NSArray *msgData1 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_": @"stopplay",
                                         @"action": @"19",
                                         @"ct":@"直播关闭",
                                         @"msgtype": @"1",
                                
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"equipment": @"app",
                                         @"roomnum": [Config getOwnID]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData1];
    
}

-(void)closeRoom{
    NSArray *msgData1 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_": @"StartEndLive",
                                         @"action": @"19",
                                         @"ct":@"直播关闭",
                                         @"msgtype": @"1",
                                
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"equipment": @"app",
                                         @"roomnum": [Config getOwnID]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData1];
    
}
-(void)colseSocket{
    [ChatSocket disconnect];
    [ChatSocket off:@""];
    [ChatSocket leaveNamespace];
    ChatSocket = nil;
}
-(void)addNodeListen:(NSString *)socketUrl andRoomMessage:(NSDictionary *)roomDic{
    _roomDic = roomDic;
    roomStream = minstr([_roomDic valueForKey:@"stream"]);
    __weak socketLive *weakself = self;
    NSURL* url = [[NSURL alloc] initWithString:socketUrl];//@"http://live.yunbaozhibo.com:19965"
    
    
    _sokManager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO, @"compress": @YES}];
    ChatSocket = _sokManager.defaultSocket;

    NSArray *cur = @[@{@"username":[Config getOwnNicename],
                       @"uid":[Config getOwnID],
                       @"token":minstr([_roomDic valueForKey:@"token"]),
                       @"roomnum":minstr([_roomDic valueForKey:@"uid"]),
                       @"stream":roomStream
                       }];
    [ChatSocket connect];
    [ChatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {        
        [ChatSocket emit:@"conn" with:cur];
        NSLog(@"socket链接");
    }];
    [ChatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"进入房间");
    }];
    
    [ChatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {

            if([[data[0] firstObject] isEqual:@"stopplay"])
            {
            NSLog(@"%@",[data[0] firstObject]);
            [self.delegate LiveEnd];
            if ([self.delegate respondsToSelector:@selector(jinggaoUser:)]) {
                [self.delegate jinggaoUser:@"涉嫌违规，被下播"];
            }
            return ;
                
            
            
          }
        
            for (NSString *path in data[0]) {
            NSDictionary *jsonArray = [path JSONValue];
            NSDictionary *msg = [[jsonArray valueForKey:@"msg"] firstObject];
            NSString *action = [NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"action"]];
                
            if ([action isEqual:@"409002"]) {
                [MBProgressHUD showError:@"你已被禁言"];
                return;
            }
            NSString *method = [msg valueForKey:@"_method_"];
            [weakself getmessage:msg andMethod:method];
        }
       
        
    }];
}
-(void)getmessage:(NSDictionary *)msg andMethod:(NSString *)method{
    NSLog(@"收到sokcet \nmethod=%@\n msg=%@",method,msg);
    int action = [minstr([msg valueForKey:@"action"]) intValue];
    if ([method isEqual:@"SendMsg"]) {
        // action 0=用户进入 1=直播间聊天
        if (action == 0) {
            [self.delegate userEnterRoom:msg];
        }
        if (action == 1) {
            [self.delegate reciveMessage:msg];
        }
    }
    else if ([method isEqualToString:@"StartEndLive"]){
        [self.delegate LiveEnd];
    }
    else if ([method isEqualToString:@"jinggao"]){
        if ([self.delegate respondsToSelector:@selector(jinggaoUser:)]) {
            [self.delegate jinggaoUser:minstr(msg[@"ct"])];
        }
    }
    else if ([method isEqual:@"SystemNot"]) {
        //系统公告
        [self.delegate reciveMessage:msg];
    }
    else if ([method isEqual:@"disconnect"]) {
        //用户离开
        [self.delegate userLeaveRoom];
    }
    else if ([method isEqual:@"SendLight"]) {
        //点亮
        [self.delegate reciveMessage:msg];
    }
    else if ([method isEqual:@"Shutup"]) {
        //禁言
        NSString *content = minstr(msg[@"content"]);
        [self.delegate anchorShutUser:minstr([msg valueForKey:@"touid"]) andAction:action content:content];
    }
    else if ([method isEqual:@"Kick"]) {
        //踢出直播间
        [self.delegate anchorKickUser:minstr([msg valueForKey:@"touid"])];
    }
    else if ([method isEqual:@"setAdmin"]) {
        [self.delegate setAdmin:msg action:minstr(msg[@"action"])];
    }
    else if ([method isEqualToString:@"SendGift"]){
        NSString *haohualiwu =  [NSString stringWithFormat:@"%@",[msg valueForKey:@"evensend"]];
        NSDictionary *ct;
        if ([[msg valueForKey:@"ct"] isKindOfClass:[NSDictionary class]]) {
            ct = [msg valueForKey:@"ct"];
        }else{
            ct = [[WYToolClass sharedInstance] dictionaryWithJsonString:[msg valueForKey:@"ct"]];
        }
        
        NSString *head = minstr(msg[@"uhead"]);
        NSDictionary *GiftInfo = [NSDictionary dictionaryWithObjectsAndKeys:[msg valueForKey:@"uid"],@"uid",[msg valueForKey:@"uname"],@"nicename",[ct valueForKey:@"giftname"],@"giftname",[ct valueForKey:@"gifticon"],@"gifticon",[ct valueForKey:@"giftcount"],@"giftcount",[ct valueForKey:@"giftid"],@"giftid",[msg valueForKey:@"level"],@"level",head,@"avatar",[ct valueForKey:@"type"],@"type",minstr([ct valueForKey:@"swf"]),@"swf",minstr([ct valueForKey:@"swftime"]),@"swftime",minstr([ct valueForKey:@"swftype"]),@"swftype",minstr([ct valueForKey:@"isluck"]),@"isluck",minstr([ct valueForKey:@"lucktimes"]),@"lucktimes", minstr([ct valueForKey:@"mark"]),@"mark",minstr([msg valueForKey:@"livename"]),@"livename",minstr([ct valueForKey:@"isplatgift"]),@"isplatgift",nil];
        
            [self.delegate sendGift:msg andLiansong:haohualiwu andTotalCoin:minstr([ct valueForKey:@"votestotal"]) andGiftInfo:GiftInfo andCt:ct];

    }
}


-(void)shutUpUser:(NSString *)touid andName:(NSString *)toname andAction:(NSString *)action content:(NSString *)content{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"Shutup",
                                        @"action": action,
                                        @"touid":touid,
                                        @"toname":toname,
                                        @"uid": [Config getOwnID],
                                @"content":content,
                                        @"equipment": @"app",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}

-(void)kickUser:(NSString *)touid andName:(NSString *)toname{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"Kick",
                                        @"action": @"1",
                                        @"touid":touid,
                                        @"toname":toname,
                                        @"uid": [Config getOwnID],
                                        @"equipment": @"app",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
- (void)sendRoomSystemNotMessage:(NSString *)message{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SystemNot",
                                        @"action": @"13",
                                        @"msgtype": @"4",
                                        @"ct": message,
                                        @"equipment": @"app",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}

///点赞=点亮
- (void)startLike{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendLight",
                                        @"action": @"1",
                                        @"msgtype": @"4",
                                        @"usernickname": [Config getOwnNicename],
                                        @"uid": [Config getOwnID],
                                        @"avatar":[Config getavatar],
                                        @"isattent":@"0",
                                        @"equipment": @"app",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
//设置管理
-(void)setAdmin:(NSString *)touid andName:(NSString *)toname{
    NSString *content = [NSString stringWithFormat:@"%@被设为管理员",toname];
    [MBProgressHUD showError:@"设置管理员成功"];
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"setAdmin",
                                            @"action":@"1",
                                            @"ct":content,
                                            @"msgtype":@"1",
                                            @"uid":[Config getOwnID],
                                            @"uname":@"直播间消息",
                                            @"touid":touid,
                                            @"touname":toname
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
    
}

- (void)cancelSetAdmin:(NSString *)touid andName:(NSString *)toname{
    NSString *content = [NSString stringWithFormat:@"%@被取消管理员",toname];
    [MBProgressHUD showError:@"取消管理员成功"];
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"setAdmin",
                                            @"action":@"0",
                                            @"ct":content,
                                            @"msgtype":@"1",
                                            @"uid":[Config getOwnID],
                                            @"uname":@"直播间消息",
                                            @"touid":touid,
                                            @"touname":toname
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
//送礼物
-(void)sendGiftAndINfo:(NSString *)info andlianfa:(NSString *)lianfa{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendGift",
                                        @"action": @"0",
                                        @"ct":info ,
                                        @"msgtype": @"1",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.roomDic valueForKey: @"uid"],
                                        
                                        @"evensend":lianfa,
                                        @"uhead":[Config getavatar],
                                        
                                        
                                        @"livename":[self.roomDic valueForKey:@"user_nicename"]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
@end
