//
//  ZYPathItemButton.h
//  MXtabbar
//
//  Created by tang dixi on 31/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

@import UIKit;

@class ZYPathItemButton;

/*!
 *  `ZYPathItemButtonDelegate` protocol defines method that informs the delegate object the event of item button's selection.
 */
@protocol ZYPathItemButtonDelegate <NSObject>

/*!
 *  Tells the delegate that the `ZYPathItemButton` has been selected.
 *
 *  @param itemButton A `ZYPathItemButton` that has been selected.
 */
- (void)itemButtonTapped:(ZYPathItemButton *)itemButton;

@end

@interface ZYPathItemButton : UIButton

/*!
 *  The location of the `ZYPathItemButton` object in a `MXtabbar` object.
 */
@property (assign, nonatomic) NSUInteger index;

/*!
 *  The object that acts as the delegate of the `ZYPathItemButton` object.
 */
@property (weak, nonatomic) id<ZYPathItemButtonDelegate> delegate;

/*!
 *  Creates a `ZYPathItemButton` with normal and highlighted foreground and background images of the button.
 *
 *  @param image                      The normal foreground image.
 *  @param highlightedImage           The highlighted foreground image.
 *  @param backgroundImage            The normal background image.
 *  @param backgroundHighlightedImage The highlighted background image.
 *
 *  @return A `ZYPathItemButton` object.
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
              backgroundImage:(UIImage *)backgroundImage
   backgroundHighlightedImage:(UIImage *)backgroundHighlightedImage;

@end
