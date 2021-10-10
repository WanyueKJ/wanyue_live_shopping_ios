//
//  profitTypeCell.h
//  yunbaolive
//
//  Created by Boom on 2018/10/11.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cellDelegate <NSObject>
-(void)delateIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_BEGIN

@interface profitTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (nonatomic,assign) NSInteger indexRow;
@property(nonatomic,weak)id<cellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
