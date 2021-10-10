#import "liwuModel.h"
#import "UIImageView+WebCache.h"
@implementation liwuModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imagePath = [dic valueForKey:@"icon"];
        self.price = [dic valueForKey:@"coin"];
        self.num = [NSString stringWithFormat:@"%@",[dic valueForKey:@"nums"]];
        self.type = minstr([dic valueForKey:@"type"]);
        self.giftname = minstr([dic valueForKey:@"name"]);
        self.ID = minstr([dic valueForKey:@"id"]);
        self.mark =minstr([dic valueForKey:@"mark"]) ;
        self.duihaiOK = 0;
        
//        [self setView];
    }
    return self;
}
-(void)setView{
    
    CGFloat  H =( _window_height/3- _window_height/18)/2 - 30;
    //_imageVR = CGRectMake(20,5,_window_width/10,_window_width/10);
    
    _imageVR = CGRectMake(0,0,_window_width/4,H);
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize  size1 = [_price boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    _priceR = CGRectMake(0,H+15,_window_width/4,20);
    _countR = CGRectMake(0,H,_window_width/4,20);
    CGSize  size2 = [_num boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    _numR = CGRectMake(_imageVR.size.width/2,_imageVR.size.height + size1.height+10, size2.width, size2.height);
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return  [[self alloc]initWithDic:dic];
}
@end
