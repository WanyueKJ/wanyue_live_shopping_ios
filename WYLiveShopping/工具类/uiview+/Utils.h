//
//  Utils.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "UIColor+Util.h"
#import "UIImageView+Util.h"
#import "UIImage+Util.h"
#import "NSTextAttachment+Util.h"



typedef NS_ENUM(NSUInteger, hudType) {
    hudTypeSendingTweet,
    hudTypeLoading,
    hudTypeCompleted
};

@class MBProgressHUD;

@interface Utils : NSObject
+ (NSDictionary *)emojiDict;
+ (NSAttributedString *)getAppclient:(int)clientType;
+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews;
+ (NSString *)generateTags:(NSArray *)tags;
+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString;
+ (NSAttributedString *)emojiStringFromAttrString:(NSAttributedString*)attrString;
+ (NSData *)compressImage:(UIImage *)image;
+ (NSString *)convertRichTextToRawText:(UITextView *)textView;
+ (BOOL)isURL:(NSString *)string;
+ (CGFloat)valueBetweenMin:(CGFloat)min andMax:(CGFloat)max percent:(CGFloat)percent;
+ (MBProgressHUD *)createHUD;
+ (UIImage *)createQRCodeFromString:(NSString *)string;
+ (NSAttributedString *)attributedCommentCount:(int)commentCount;
@end
