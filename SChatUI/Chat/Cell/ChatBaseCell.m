//
//  ChatBaseCell.m
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseCell.h"
#import "ChatBaseModel.h"


@interface ChatBaseCell ()
/**
 *  收到信息的头像
 */
@property (nonatomic, strong) UIImageView * leftAuthorView;
@property (nonatomic, strong) UIButton * leftWarningView;        // 发送失败警告
/**
 *  发出信息的头像
 */
@property (nonatomic, strong) UIImageView * rightAuthorView;
@property (nonatomic, strong) UIButton * rightWarningView;       // 发送失败警告
@end

@implementation ChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

#pragma mark loadUI
- (void)loadUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    Wself
    [self addSubview:self.leftAuthorView];
    [self addSubview:self.leftBubbleView];
    [self addSubview:self.leftWarningView];
    [self addSubview:self.rightAuthorView];
    [self addSubview:self.rightBubbleView];
    [self addSubview:self.rightWarningView];
    
    self.leftWarningView.hidden = YES;
    self.rightWarningView.hidden = YES;
    
    [self.leftAuthorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@CellSpaceToAuthorImage);
        make.left.equalTo(wself).offset(ScreenSpaceToAuthorImage);
        make.width.height.equalTo(@(AuthorImageWidth));
    }];
    [self.rightAuthorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@CellSpaceToAuthorImage);
        make.right.equalTo(wself).offset(-ScreenSpaceToAuthorImage);
        make.width.height.equalTo(@(AuthorImageWidth));
    }];
    
    [self.leftBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.leftAuthorView.mas_right).offset(AuthorImageSpaceToBubble);
        make.top.equalTo(wself.leftAuthorView);
        make.width.lessThanOrEqualTo(@(BubbleMaxWidth));
        make.bottom.equalTo(wself).offset(-CellSpaceToAuthorImage);
    }];
    [self.rightBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.rightAuthorView.mas_left).offset(-AuthorImageSpaceToBubble);
        make.top.equalTo(wself.rightAuthorView);
        make.width.lessThanOrEqualTo(@(BubbleMaxWidth));
        make.bottom.equalTo(wself).offset(-CellSpaceToAuthorImage);
    }];
}

#pragma mark reloadUI
- (void)reloadUIWithData:(ChatBaseModel *)bModel {
    // 判断 发送/接收
    self.leftAuthorView.hidden = bModel.isSender;
    self.leftBubbleView.hidden = bModel.isSender;
    self.rightAuthorView.hidden = !bModel.isSender;
    self.rightBubbleView.hidden = !bModel.isSender;
    
    // 加载头像
    [self.leftAuthorView sd_setImageWithURL:[NSURL URLWithString:bModel.sendAuthorImg] placeholderImage:[UIImage imageNamed:ReceiverPlaceHolderImg]];
    [self.rightAuthorView sd_setImageWithURL:[NSURL URLWithString:bModel.receiveAuthorImg] placeholderImage:[UIImage imageNamed:SenderPlaceHolderImg]];
    
}

#pragma mark getter
- (UIImageView *)leftAuthorView {
    if (!_leftAuthorView) {
        _leftAuthorView = [UIImageView new];
        _leftAuthorView.backgroundColor = [UIColor lightGrayColor];
        _leftAuthorView.layer.cornerRadius = AuthorImageWidth/2;
        _leftAuthorView.clipsToBounds = YES;
        _leftAuthorView.layer.shouldRasterize = YES;
        _leftAuthorView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _leftAuthorView.image = [UIImage imageNamed:ReceiverPlaceHolderImg];
    }
    return _leftAuthorView;
}
- (UIImageView *)leftBubbleView {
    if (!_leftBubbleView) {
        _leftBubbleView = [UIImageView new];
        _leftBubbleView.userInteractionEnabled = YES;
        UIImage * tempImage = [UIImage imageNamed:ReceiverBubbleImg];
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 20) resizingMode:UIImageResizingModeStretch];
        _leftBubbleView.image = tempImage;
    }
    return _leftBubbleView;
}
- (UIButton *)leftWarningView {
    if (!_leftWarningView) {
        _leftWarningView = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _leftWarningView;
}
- (UIImageView *)rightAuthorView {
    if (!_rightAuthorView) {
        _rightAuthorView = [UIImageView new];
        _rightAuthorView.backgroundColor = [UIColor lightGrayColor];
        _rightAuthorView.layer.cornerRadius = AuthorImageWidth/2;
        _rightAuthorView.clipsToBounds = YES;
        _rightAuthorView.layer.shouldRasterize = YES;
        _rightAuthorView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _rightAuthorView.image = [UIImage imageNamed:SenderPlaceHolderImg];
    }
    return _rightAuthorView;
}
- (UIImageView *)rightBubbleView {
    if (!_rightBubbleView) {
        _rightBubbleView = [UIImageView new];
        _rightBubbleView.userInteractionEnabled = YES;
        UIImage * tempImage = [UIImage imageNamed:SenderBubbleImg];
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 30) resizingMode:UIImageResizingModeStretch];
        _rightBubbleView.image = tempImage;
    }
    return _rightBubbleView;
}
- (UIButton *)rightWarningView {
    if (!_rightWarningView) {
        _rightWarningView = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightWarningView;
}

@end
