//
//  ChatRecordCell.m
//  SChatUI
//
//  Created by tongxuan on 16/8/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatRecordCell.h"
#import "ChatRecordModel.h"
#import "SChatRecordHandle.h"


@interface ChatRecordCell ()
{
    ChatRecordModel * _model;
}
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UIImageView * rightImg;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation ChatRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadRecordUI];
    }
    return self;
}

#pragma mark loadUI
- (void)loadRecordUI {
    Wself
    
    UITapGestureRecognizer * leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftReplayRecord)];
    [self.leftBubbleView addGestureRecognizer:leftTap];
    UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightReplayRecord)];
    [self.rightBubbleView addGestureRecognizer:rightTap];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.rightImg];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.leftBubbleView).offset(RecordLeftSpaceImg+5);
        make.top.equalTo(wself.leftBubbleView).offset(RecordTopSpaceImg);
        make.bottom.equalTo(wself.leftBubbleView).offset(-RecordBottomSpaceImg);
        make.width.height.mas_lessThanOrEqualTo(RecordImgWidth);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.rightBubbleView).offset(RecordTopSpaceImg);
        make.right.equalTo(wself.rightBubbleView).offset(-RecordLeftSpaceImg-5);
        make.bottom.equalTo(wself.rightBubbleView).offset(-RecordBottomSpaceImg);
        make.width.height.mas_lessThanOrEqualTo(RecordImgWidth);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.leftImg.mas_right).offset(RecordTimeSpaceToImg);
        make.top.bottom.equalTo(wself.leftImg);
        make.right.lessThanOrEqualTo(wself.leftBubbleView).offset(-10);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.rightImg.mas_left).offset(-RecordTimeSpaceToImg);
        make.top.bottom.equalTo(wself.rightImg);
        make.left.lessThanOrEqualTo(wself.rightBubbleView).offset(10);
    }];
    
}

#pragma mark reloadUI
- (void)reloadUIWithData:(ChatBaseModel *)bModel {
    [super reloadUIWithData:bModel];
    self.leftImg.hidden = bModel.isSender;
    self.rightImg.hidden = !bModel.isSender;
    
    ChatRecordModel * model = (ChatRecordModel *)bModel;
    _model = model;
    
    CGFloat maxW = BubbleMaxWidth;
    CGFloat minW = RecordBuddleMinW;
    CGFloat buddleW = (maxW-minW)*model.timeLength/SChatRecordMaxTime;
    if (model.isSender) {
        self.rightLabel.text = [NSString stringWithFormat:@"%.1f“",model.timeLength];
        self.leftLabel.text = @"";
        [self.rightBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buddleW+minW);
        }];
    }else {
        self.leftLabel.text = [NSString stringWithFormat:@"%.1f”",model.timeLength];
        self.rightLabel.text = @"";
        [self.leftBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buddleW+minW);
        }];
    }
}

#pragma mark action
- (void)leftReplayRecord {
    [[SChatRecordHandle new] repalyRecordWithUrl:_model.receiveUrl];
}
- (void)rightReplayRecord {
    [[SChatRecordHandle new] repalyRecordWithUrl:_model.sendUrl];
}

#pragma mark getter
- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView new];
        _leftImg.userInteractionEnabled = YES;
        _leftImg.image = [UIImage imageNamed:RecordLeftImg];
        _leftImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImg;
}
- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [UIImageView new];
        _rightImg.userInteractionEnabled = YES;
        _rightImg.image = [UIImage imageNamed:RecordRightImg];
        _rightImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImg;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = [UIColor lightGrayColor];
        _leftLabel.font = [UIFont systemFontOfSize:17.];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:17.];
    }
    return _rightLabel;
}

@end
