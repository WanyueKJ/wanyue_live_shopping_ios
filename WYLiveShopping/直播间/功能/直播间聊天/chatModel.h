
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface chatModel : NSObject


@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *contentChat;

@property(nonatomic,copy)NSString *userID;

@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *userType;
@property (nonatomic,assign) BOOL isattent;


-(instancetype)initWithDic:(NSDictionary *)dic;
- (instancetype)initOnlineDic:(NSDictionary *)dic;

@end
