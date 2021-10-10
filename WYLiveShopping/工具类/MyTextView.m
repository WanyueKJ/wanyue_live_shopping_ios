//
//  MyTextView.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView


- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:)name:UITextViewTextDidChangeNotification object:nil];
           self.autoresizesSubviews = NO;
           self.placeholderColor = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:)name:UITextViewTextDidChangeNotification object:nil];
        self.autoresizesSubviews = NO;
        self.placeholderColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //内容为空时才绘制placeholder
    if ([self.text isEqual:@""]) {
        CGRect placeholderRect;
        placeholderRect.origin.y = 8;
        
        placeholderRect.origin.x = 8;
        placeholderRect.size.height = CGRectGetHeight(self.frame);
        placeholderRect.size.width = CGRectGetWidth(self.frame)-5;
        
        [self.placeholderColor set];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attribute=@{
                                  NSFontAttributeName:self.font,
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSForegroundColorAttributeName:self.placeholderColor,
                                  };
        [self.placeholder drawInRect:placeholderRect withAttributes:attribute];
    }
}

- (void)textChanged:(NSNotification *)not {
    
    [self setNeedsDisplay];
    
}
- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self setNeedsDisplay];
}


@end
