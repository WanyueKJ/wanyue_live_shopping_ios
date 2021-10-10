
#import "NSString+StringSize.h"

@implementation NSString (StringSize)

-(CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxW
{
    return [self boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

-(NSArray *)catchArrayWithORC:(NSString*)lrcStr{
    lrcStr = [lrcStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSMutableArray *rootList = [[NSMutableArray alloc]init];
    NSArray *array = [lrcStr componentsSeparatedByString:@"["];
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = [array objectAtIndex:i];
        if (tempStr.length > 8){
            NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]init];
            NSString *str1 = [tempStr substringWithRange:NSMakeRange(2, 1)];
            NSString *str2 = [tempStr substringWithRange:NSMakeRange(5, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]){
                NSString *biaoji=[array objectAtIndex:i];
                NSString *lrcStr=[NSString string];
                if (biaoji.length>9) {
                    lrcStr = [[array objectAtIndex:i] substringWithRange:NSMakeRange(9, 1)];
                } else {
                    lrcStr=@"";
                }
                NSString *timeStr = [[array objectAtIndex:i] substringWithRange:NSMakeRange(0, 8)];
                if (![lrcStr isEqualToString:@"\\"]) {
                    [rootDic setObject:lrcStr forKey:@"lrc"];
                }
                [rootDic setObject:timeStr forKey:@"lrctime"];
                [rootList addObject:rootDic];
            }
        }
    }
    for (int i=0; i<rootList.count; i++){
        NSDictionary *dic=[rootList objectAtIndex:i];
        NSString *lrc=[dic valueForKey:@"lrc"];
        if (lrc.length<1){
            [rootList removeObject:dic];
        }
    }
    return rootList;
}
@end
