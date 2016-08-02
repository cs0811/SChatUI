//
//  ChatTextCell.m
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatTextCell.h"
#import "ChatTextModel.h"


@interface ChatTextCell ()
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end

@implementation ChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadTextUI];
    }
    return self;
}

#pragma mark loadUI
- (void)loadTextUI {
    Wself
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.leftBubbleView).offset(LeftSpaceText);
        make.top.equalTo(wself.leftBubbleView).offset(TopSpaceText);
        make.right.equalTo(wself.leftBubbleView).offset(-RightSpaceText);
        make.bottom.equalTo(wself.leftBubbleView).offset(-BottomSpaceText);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightBubbleView).offset(RightSpaceText);
        make.top.equalTo(wself.rightBubbleView).offset(TopSpaceText);
        make.right.equalTo(wself.rightBubbleView).offset(-LeftSpaceText);
        make.bottom.equalTo(wself.rightBubbleView).offset(-BottomSpaceText);
    }];
}

#pragma mark reloadUI
- (void)reloadUIWithData:(ChatBaseModel *)bModel {
    [super reloadUIWithData:bModel];
    
    self.leftLabel.hidden = bModel.isSender;
    self.rightLabel.hidden = !bModel.isSender;
    
    ChatTextModel * model = (ChatTextModel *)bModel;
    self.leftLabel.text = bModel.isSender?@"":model.receiveText;
    self.rightLabel.text = bModel.isSender?model.sendText:@"";
    
}

// 重写父视图方法
- (void)menuCopyBtnPressed {
    if (self.leftLabel.text && self.leftLabel.text.length>0) {
        [UIPasteboard generalPasteboard].string = self.leftLabel.text;
    }else {
        [UIPasteboard generalPasteboard].string = self.rightLabel.text;
    }
}

#pragma mark getter
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = [UIColor lightGrayColor];
        _leftLabel.font = [UIFont systemFontOfSize:14.];
        _leftLabel.numberOfLines = 0;
        _leftLabel.preferredMaxLayoutWidth = BubbleMaxWidth-LeftSpaceText-RightSpaceText;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:14.];
        _rightLabel.numberOfLines = 0;
        _rightLabel.preferredMaxLayoutWidth = BubbleMaxWidth-LeftSpaceText-RightSpaceText;
    }
    return _rightLabel;
}


@end
