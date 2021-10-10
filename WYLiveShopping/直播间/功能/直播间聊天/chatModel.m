#import "chatModel.h"
@implementation chatModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userName = minstr([dic valueForKey:@"userName"]);
        self.contentChat = minstr([dic valueForKey:@"contentChat"]);
        self.userID = minstr([dic valueForKey:@"userID"]);
        self.type = minstr([dic valueForKey:@"type"]);
        self.icon = minstr([dic valueForKey:@"icon"]);
        self.isattent = [minstr([dic valueForKey:@"isattent"]) intValue];
        self.userType = minstr(dic[@"usertype"]);
    }
    return self;
}

- (instancetype)initOnlineDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userName = minstr([dic valueForKey:@"nickname"]);
        self.userID = minstr([dic valueForKey:@"uid"]);
        self.icon = minstr([dic valueForKey:@"avatar"]);
        self.money = minstr(dic[@"total"]);
    }
    return self;
}
@end
