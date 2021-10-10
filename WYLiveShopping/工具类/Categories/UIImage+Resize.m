

#import "UIImage+Resize.h"

@implementation UIImage (Resize)


+(UIImage *)resizableImage:(NSString *)imageName
{
    UIImage *oldImage = [UIImage imageNamed:imageName];
    
    CGFloat w = oldImage.size.width/2;
    CGFloat h = oldImage.size.height/2;
    UIImage *newImage = [oldImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    return newImage;
    
}



@end
