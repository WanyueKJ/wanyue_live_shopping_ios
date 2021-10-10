

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (StringSize)
-(CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxW;
-(NSArray *)catchArrayWithORC:(NSString*)lrcStr;
@end
