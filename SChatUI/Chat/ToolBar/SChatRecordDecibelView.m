//
//  SChatRecordDecibelView.m
//  SChatUI
//
//  Created by dufei on 16/8/2.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SChatRecordDecibelView.h"
#import "Masonry.h"

#define Wself                           __weak typeof(self) wself = self;
#define Sself                           __strong typeof(wself) sself = wself;

@interface SChatRecordDecibelView ()
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) UIImageView * decibelImg;
@end

@implementation SChatRecordDecibelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    UIWindow * window = [[UIApplication sharedApplication].delegate window];

    [window addSubview:self.baseView];
    [window addSubview:self.decibelImg];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.decibelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50*3/2);
    }];
}


- (void)updateDecibelImgWithProgress:(float)progress {
    int new = floorf(progress*10);
    self.decibelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"chat_decibel_%d",new]];
}

- (void)end {
    self.decibelImg.image = [UIImage imageNamed:@"chat_decibel_0"];
    [self.decibelImg removeFromSuperview];
    [self.baseView removeFromSuperview];
}

#pragma mark getter
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor lightGrayColor];
        _baseView.alpha = 0.6;
        _baseView.layer.cornerRadius = 5;
    }
    return _baseView;
}
- (UIImageView *)decibelImg {
    if (!_decibelImg) {
        _decibelImg = [UIImageView new];
        _decibelImg.image = [UIImage imageNamed:@"chat_decibel_0"];
    }
    return _decibelImg;
}

@end
