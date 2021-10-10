//
//  productView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/28.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "productView.h"

@implementation productView{
    NSDictionary *storeInfo;
    NSArray *productAttr;
    id productValue;
    UIView *whiteView;
    NSString *selectStr;
    NSString *nameStr;
    NSMutableArray *selectKeyArray;
    NSMutableArray *btnArray;
    
    UIImageView *thumbImgView;
    UILabel *nameL;
    UILabel *priceL;
    UILabel *stockL;
    
    UIButton *delBtn;
    UIButton *addBtn;
    int selectStockNum;
    int curNums;
}


-(instancetype)initWithFrame:(CGRect)frame andProductAttr:(NSArray *)array1 andProductValue:(id)dic andSelectStr:(NSString *)str andName:(NSString *)name andGoodsMessage:(NSDictionary *)goodsMsg{
    if (self = [super initWithFrame:frame]) {
        productAttr = array1;
        productValue = dic;
        selectStr = str;
        nameStr = name;
        btnArray = [NSMutableArray array];
        curNums = 1;
        storeInfo = goodsMsg;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self creatUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}
- (void)creatUI{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, _window_width, 160)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    thumbImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 75, 75)];
    thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
    thumbImgView.clipsToBounds = YES;
    thumbImgView.layer.cornerRadius = 5.0;
    thumbImgView.layer.masksToBounds = YES;
    [whiteView addSubview:thumbImgView];
    UIButton *closeBtn = [UIButton buttonWithType:0];
    [closeBtn setImage:[UIImage imageNamed:@"userMsg_close"] forState:0];
    [closeBtn addTarget:self action:@selector(doHide) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.right.equalTo(whiteView).offset(-10);
        make.centerY.equalTo(thumbImgView.mas_top).offset(4);
    }];
    nameL = [[UILabel alloc]init];
    nameL.font = [UIFont boldSystemFontOfSize:15];
    nameL.text = nameStr;
    nameL.numberOfLines = 2;
    nameL.textColor = color32;
    [whiteView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thumbImgView.mas_right).offset(8);
        make.top.equalTo(thumbImgView).offset(3);
        make.right.equalTo(closeBtn.mas_left).offset(-15);
    }];
    UILabel *biaozhiL = [[UILabel alloc]init];
    biaozhiL.font = SYS_Font(12);
    biaozhiL.textColor = normalColors;
    biaozhiL.text = @"¥";
    [whiteView addSubview:biaozhiL];
    [biaozhiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.bottom.equalTo(thumbImgView).offset(-8);
    }];
    priceL = [[UILabel alloc]init];
    priceL.font = [UIFont boldSystemFontOfSize:15];
    priceL.textColor = normalColors;
    [whiteView addSubview:priceL];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(biaozhiL.mas_right).offset(1);
        make.bottom.equalTo(biaozhiL);
    }];
    stockL = [[UILabel alloc]init];
    stockL.font = SYS_Font(12);
    stockL.textColor = color96;
    [whiteView addSubview:stockL];
    [stockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceL.mas_right).offset(10);
        make.bottom.equalTo(thumbImgView).offset(-8);
    }];
    NSDictionary *selectDic;
    if (productAttr.count > 0) {
        if ([productValue isKindOfClass:[NSDictionary class]]) {
            selectDic = [productValue valueForKey:selectStr];
            selectKeyArray = [[selectStr componentsSeparatedByString:@","] mutableCopy];
        }else{
            selectDic = productValue[[selectStr intValue]];
            selectKeyArray = @[selectStr].mutableCopy;
        }
        CGFloat btnTopValue = thumbImgView.bottom + 5;
        for (int i = 0; i < productAttr.count; i ++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, btnTopValue, _window_width-30, 40)];
            label.font = SYS_Font(15);
            label.textColor = color96;
            label.text = minstr([productAttr[i] valueForKey:@"attr_name"]);
            [whiteView addSubview:label];
            btnTopValue = label.bottom;
            NSArray *array = [productAttr[i] valueForKey:@"attr_values"];
            CGFloat btnLeft = 15;
            for (int j = 0; j < array.count; j ++) {
                UIButton *btn = [UIButton buttonWithType:0];
                CGFloat btnWidth = [[WYToolClass sharedInstance] widthOfString:minstr(array[j]) andFont:SYS_Font(12) andHeight:28] + 30;
                if (btnLeft + btnWidth + 15 > _window_width) {
                    btnLeft = 15;
                    btnTopValue += 38;
                }
                btn.frame = CGRectMake(btnLeft, btnTopValue, btnWidth, 28);
                btn.tag = 1000 * i + j;
                [btn setTitle:array[j] forState:0];
                [btn setBackgroundImage:[WYToolClass getImgWithColor:[UIColor whiteColor]] forState:0];
                [btn setBackgroundImage:[WYToolClass getImgWithColor:normalColors] forState:UIControlStateSelected];
                [btn setTitleColor:color32 forState:0];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                btn.layer.cornerRadius = 3.0;
                btn.layer.masksToBounds = YES;
                btn.titleLabel.font = SYS_Font(12);
                if ([selectKeyArray[i] isEqual:array[j]]) {
                    btn.selected = YES;
                    [btn setBorderColor:[UIColor clearColor]];
                    [btn setBorderWidth:0];
                }else{
                    btn.selected = NO;
                    [btn setBorderColor:color96];
                    [btn setBorderWidth:1];
                }
                [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
                [whiteView addSubview:btn];
                [btnArray addObject:btn];
                btnLeft = btn.right + 10;
                if (j == array.count - 1) {
                    btnTopValue = btn.bottom + 5;
                    if (i == productAttr.count - 1) {
                        whiteView.height = btn.bottom + 85;
                    }
                }
            }
        }

    }else{
        selectDic = storeInfo;
    }
    
    UILabel *label222 = [[UILabel alloc]initWithFrame:CGRectMake(15, whiteView.height-80, _window_width-30, 40)];
    label222.font = SYS_Font(15);
    label222.textColor = color96;
    label222.text = @"数量";
    [whiteView addSubview:label222];
    NSArray *array = @[@"-",@"+"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(15+84*i, label222.bottom, 43, 28);
        [btn setTitle:array[i] forState:0];
        [btn setTitleColor:color32 forState:0];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn addTarget:self action:@selector(numsBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        UIBezierPath *maskPath;
        if (i == 0) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
            delBtn = btn;
            delBtn.alpha = 0.5;
        }else{
            maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
            addBtn = btn;
        }
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = btn.bounds;
        maskLayer.path = maskPath.CGPath;
        btn.layer.mask = maskLayer;
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = btn.bounds;
        borderLayer.path = maskPath.CGPath;
        borderLayer.lineWidth = 2;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = color32.CGColor;
        [btn.layer addSublayer:borderLayer];
    }
    _numsTextF = [[UITextField alloc]initWithFrame:CGRectMake(15+42, label222.bottom, 43, 28)];
    _numsTextF.font = SYS_Font(12);
    _numsTextF.text = @"1";
    [_numsTextF setBorderWidth:1];
    [_numsTextF setBorderColor:color32];
    _numsTextF.textColor = color32;
    _numsTextF.textAlignment = NSTextAlignmentCenter;
    _numsTextF.keyboardType = UIKeyboardTypeNumberPad;
    [whiteView addSubview:_numsTextF];
    whiteView.layer.mask = [[WYToolClass sharedInstance] setViewLeftTop:10 andRightTop:10 andView:whiteView];

    UIButton *hideBtn = [UIButton buttonWithType:0];
    hideBtn.frame = CGRectMake(0, 0, _window_width, self.height-whiteView.height);
    [hideBtn addTarget:self action:@selector(doHide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideBtn];
    
    
    [self changeGoods:selectDic];

}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = self.height-whiteView.height;
    }];
}
- (void)btnCLick:(UIButton *)sender{
    NSInteger oneIndex = sender.tag/1000;
    NSInteger towIndex = sender.tag%1000;
    for (UIButton *btn in btnArray) {
        if (btn == sender) {
            btn.selected = YES;
            [btn setBorderColor:[UIColor clearColor]];
            [btn setBorderWidth:0];
        }else{
            if (btn.tag/1000 == oneIndex) {
                btn.selected = NO;
                [btn setBorderColor:color96];
                [btn setBorderWidth:1];
            }
        }
    }
    [selectKeyArray replaceObjectAtIndex:oneIndex withObject:sender.titleLabel.text];
    NSDictionary *selctDic;
//    if ([productAttr count] == 1) {
//        selctDic = productValue[towIndex];
//    }else{
    NSString *key = @"";
    for (NSString *str in selectKeyArray) {
        if (key.length == 0) {
            key = str;
        }else{
            key = [NSString stringWithFormat:@"%@,%@",key,str];
        }
    }
    selctDic = [productValue valueForKey:key];
//    }
    [self changeGoods:selctDic];
    if ([minstr([selctDic valueForKey:@"stock"]) intValue] > 0) {
        if (self.block) {
            self.block(minstr([selctDic valueForKey:@"unique"]), selectKeyArray.count == 0 ? [NSString stringWithFormat:@"%ld",towIndex] : minstr([selctDic valueForKey:@"suk"]));
        }
    }
}
- (void)numsBtnCLick:(UIButton *)sender{
    if (sender == delBtn) {
        if (curNums > 1) {
            addBtn.alpha = 1;
            curNums --;
        }else{
            curNums = 1;
        }
    }else{
        if (curNums >= selectStockNum) {
            addBtn.alpha = 0.5;
        }else{
            curNums ++;
        }
    }
    _numsTextF.text = [NSString stringWithFormat:@"%d",curNums];

}
- (void)changeGoods:(NSDictionary *)dic{
    [thumbImgView sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"image"])]];
    priceL.text = minstr([dic valueForKey:@"price"]);
    selectStockNum = [minstr([dic valueForKey:@"stock"]) intValue];
    stockL.text = [NSString stringWithFormat:@"库存:%d",selectStockNum];
    if (selectStockNum == 0) {
        curNums = 0;
        delBtn.alpha = 0.5;
        _numsTextF.text = @"0";
    }else{
        delBtn.alpha = 1;
        curNums = 1;
        _numsTextF.text = @"1";
    }
}
- (void)ChangeBtnBackground{
    
    if ([_numsTextF.text intValue] <= 1) {
        curNums = 1;
        delBtn.alpha = 0.5;
    }else{
        curNums = [_numsTextF.text intValue];
    }
}
- (void)doHide{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = self.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
