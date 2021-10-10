//
//  MXtabbar.h
//  MXtabbar
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "ZYPathItemButton.h"

@import UIKit;
@import QuartzCore;
@import AudioToolbox;

@class MXtabbar;

/*!
 *  The direction of a `MXtabbar` object's bloom animation.
 */
typedef NS_ENUM(NSUInteger, kMXtabbarBloomDirection) {
    /*!
     *  Bloom animation gose to the top of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionTop = 1,
    /*!
     *  Bloom animation gose to top left of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionTopLeft = 2,
    /*!
     *  Bloom animation gose to the left of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionLeft = 3,
    /*!
     *  Bloom animation gose to bottom left of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionBottomLeft = 4,
    /*!
     *  Bloom animation gose to the bottom of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionBottom = 5,
    /*!
     *  Bloom animation gose to bottom right of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionBottomRight = 6,
    /*!
     *  Bloom animation gose to the right of the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionRight = 7,
    /*!
     *  Bloom animation gose around the `MXtabbar` object.
     */
    kMXtabbarBloomDirectionTopRight = 8,
};

/*!
 *  `MXtabbarDelegate` protocol defines methods that inform the delegate object the events of item button's selection, presentation and dismissal.
 */
@protocol MXtabbarDelegate <NSObject>

/*!
 *  Tells the delegate that the item button at an index is clicked.
 *
 *  @param MXtabbar    A `MXtabbar` object informing the delegate about the button click.
 *  @param itemButtonIndex The index of the item button being clicked.
 */
- (void)pathButton:(MXtabbar *)MXtabbar clickItemButtonAtIndex:(NSUInteger)itemButtonIndex;

@optional

/*!
 *  Tells the delegate that the `MXtabbar` object will present its items.
 *
 *  @param MXtabbar A `MXtabbar` object that is about to present its items.
 */
- (void)willPresentMXtabbarItems:(MXtabbar *)MXtabbar;
/*!
 *  Tells the delegate that the `MXtabbar` object has already presented its items.
 *
 *  @param MXtabbar A `MXtabbar` object that has presented its items.
 */
- (void)didPresentMXtabbarItems:(MXtabbar *)MXtabbar;

/*!
 *  Tells the delegate that the `MXtabbar` object will dismiss its items.
 *
 *  @param MXtabbar A `MXtabbar` object that is about to dismiss its items
 */
- (void)willDismissMXtabbarItems:(MXtabbar *)MXtabbar;
/*!
 *  Tells the delegate that the `MXtabbar` object has already dismissed its items.
 *
 *  @param MXtabbar A `MXtabbar` object that has dismissed its items.
 */
- (void)didDismissMXtabbarItems:(MXtabbar *)MXtabbar;

@end

@interface MXtabbar : UIView <UIGestureRecognizerDelegate>

/*!
 *  The object that acts as the delegate of the `MXtabbar` object.
 */
@property (weak, nonatomic) id<MXtabbarDelegate> delegate;

/*!
 *  `MXtabbar` object's bloom animation's duration.
 */
@property (assign, nonatomic) NSTimeInterval basicDuration;
/*!
 *  `YES` if allows `MXtabbar` object's sub items to rotate. Otherwise `NO`.
 */
@property (assign, nonatomic) BOOL allowSubItemRotation;

/*!
 *  `MXtabbar` object's bloom radius. The default value is 105.0f.
 */
@property (assign, nonatomic) CGFloat bloomRadius;

/*!
 *  `MXtabbar` object's bloom angle.
 */
@property (assign, nonatomic) CGFloat bloomAngel;

/*!
 *  The center of a `MXtabbar` object's position. The default value positions the `MXtabbar` object in bottom center.
 */
@property (assign, nonatomic) CGPoint ZYButtonCenter;

/*!
 *  If set to `YES` a sound will be played when the `MXtabbar` object is being interacted. The default value is `YES`.
 */
@property (assign, nonatomic) BOOL allowSounds;

/*!
 *  The path to the `MXtabbar` object's bloom effect sound file.
 */
@property (copy, nonatomic) NSString *bloomSoundPath;

/*!
 *  The path to the `MXtabbar` object's fold effect sound file.
 */
@property (copy, nonatomic) NSString *foldSoundPath;

/*!
 *  The path to the `MXtabbar` object's item action sound file.
 */
@property (copy, nonatomic) NSString *itemSoundPath;

/*!
 *  `YES` if allows the `MXtabbar` object's center button to rotate. Otherwise `NO`.
 */
@property (assign, nonatomic) BOOL allowCenterButtonRotation;

/*!
 *  Color of the backdrop view when `MXtabbar` object's sub items are shown.
 */
@property (strong, nonatomic) UIColor *bottomViewColor;

/*!
 *  Direction of `MXtabbar` object's bloom animation.
 */
@property (assign, nonatomic) kMXtabbarBloomDirection bloomDirection;

/*!
 *  Creates a `MXtabbar` object with a given normal image and highlited images for center button.
 *
 *  @param centerImage            The normal image for `MXtabbar` object's center button.
 *  @param centerHighlightedImage The highlighted image for `MXtabbar` object's center button.
 *
 *  @return A `MXtabbar` object.
 */
- (instancetype)initWithCenterImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage;

/*!
 *  Creates a `MXtabbar` object with a given frame, normal and highlighted images for its center button.
 *
 *  @param centerButtonFrame      The frame of `MXtabbar` object.
 *  @param centerImage            The normal image for `MXtabbar` object's center button.
 *  @param centerHighlightedImage The highlighted image for `MXtabbar` object's center button.
 *
 *  @return A `MXtabbar` object.
 */
- (instancetype)initWithButtonFrame:(CGRect)centerButtonFrame
                        centerImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage;

/*!
 *  Adds item buttons to an existing `MXtabbar` object.
 *
 *  @param pathItemButtons The item buttons to be added.
 */
- (void)addPathItems:(NSArray *)pathItemButtons;

@end
