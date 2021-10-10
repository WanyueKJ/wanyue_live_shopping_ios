//
//  ZYPathButton.m
//  ZYPathButton
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "MXtabbar.h"
#import <sys/utsname.h>
@interface MXtabbar ()<ZYPathItemButtonDelegate>

#pragma mark - Private Property


@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImage *centerHighlightedImage;

@property (assign, nonatomic) CGSize bloomSize;
@property (assign, nonatomic) CGSize foldedSize;

@property (assign, nonatomic) CGPoint folZYenter;
@property (assign, nonatomic) CGPoint bloomCenter;
@property (assign, nonatomic) CGPoint expanZYenter;
@property (assign, nonatomic) CGPoint pathCenterButtonBloomCenter;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *pathCenterButton;
@property (strong, nonatomic) NSMutableArray *itemButtons;

@property (assign, nonatomic) SystemSoundID foldSound;
@property (assign, nonatomic) SystemSoundID bloomSound;
@property (assign, nonatomic) SystemSoundID selectedSound;

@property (assign, nonatomic, getter = isBloom) BOOL bloom;

@end

@implementation MXtabbar

#pragma mark - Initialization


- (instancetype)initWithCenterImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage {
    return [self initWithButtonFrame:CGRectZero
                         centerImage:centerImage
                    highlightedImage:centerHighlightedImage];
}
- (instancetype)initWithButtonFrame:(CGRect)centerButtonFrame
                        centerImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage {
    if (self = [super init]) {
        // Configure center and high light center image
        //
        self.centerImage = centerImage;
        self.centerHighlightedImage = centerHighlightedImage;
        // Init button and image array
        //
        self.itemButtons = [[NSMutableArray alloc]init];
        // Configure views layout
        //
        if (centerButtonFrame.size.width == 0 && centerButtonFrame.size.height == 0) {
            [self configureViewsLayoutWithButtonSize:self.centerImage.size];
        }
        else {
            [self configureViewsLayoutWithButtonSize:centerButtonFrame.size];
            self.ZYButtonCenter = centerButtonFrame.origin;
        }
        // Configure the bloom direction
        //
        // _bloomDirection = kZYPathButtonBloomDirectionTop;
        // Configure sounds
        //
        _bloomSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"bloom" ofType:@"caf"];
        _foldSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"fold" ofType:@"caf"];
        _itemSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"selected" ofType:@"caf"];
        _allowSounds = YES;
        _bottomViewColor = [UIColor blackColor];
        _allowSubItemRotation = YES;
        _basicDuration = 0.3f;
    }
    return self;
}
- (void)configureViewsLayoutWithButtonSize:(CGSize)centerButtonSize {
    // Init some property only once
    self.foldedSize = centerButtonSize;
    self.bloomSize = [UIScreen mainScreen].bounds.size;
    self.bloom = NO;
    self.bloomRadius = 105.0f;
    self.bloomAngel = 120.0f;
    // Configure the view's center, it will change after the frame folded or bloomed
    //
    if (iPhoneX) {
        self.folZYenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 30-34);
    }else{
        self.folZYenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 30);
    }
    self.bloomCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);
    // Configure the ZYPathButton's origin frame
    //
    self.frame = CGRectMake(0,0,self.foldedSize.width / 2*0.8, self.foldedSize.height / 2*0.8);//1.5
    // Default set the folZYenter as the ZYPathButton's center
    //
    self.center = self.folZYenter;
    // Configure center button
    //设置中间按钮
    _pathCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.centerImage.size.width/2*0.8, self.centerImage.size.height/2*0.8)];
    [_pathCenterButton setImage:self.centerImage forState:UIControlStateNormal];
    [_pathCenterButton addTarget:self action:@selector(centerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _pathCenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 10);
    
    [self addSubview:_pathCenterButton];
}
#pragma mark - Configure Bottom View Color
#pragma mark - Center Button Delegate
//点击中间按钮
- (void)centerButtonTapped {
    [self.delegate pathButton:_pathCenterButton clickItemButtonAtIndex:0];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
    return YES;
}


@end

