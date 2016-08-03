//
//  SChatToolBar.m
//  SChatUI
//
//  Created by tongxuan on 16/7/28.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SChatToolBar.h"
#import "SChatToolBarInputView.h"
#import "STextField.h"
#import "UIResponder+Router.h"
#import "SChatRecordHandle.h"
#import "Masonry.h"


#define Wself                           __weak typeof(self) wself = self;
#define Sself                           __strong typeof(wself) sself = wself;
#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height

@interface SChatToolBar ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) STextField * inputTF;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) SChatToolBarInputView * chatInputView;

/**
 *  放置在输入框上的按钮(录音时候放置)
 */
@property (nonatomic,strong) UIButton * recordBtn;
@property (nonatomic,strong) SChatRecordHandle * recordHandle;
@end

@implementation SChatToolBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return  self;
}

#pragma mark loadUI
- (void)loadUI {
    Wself
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputViewItemDidChoose) name:@"kInputViewItemDidChoose" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputViewDidFinishRecord:) name:@"kInputViewDidFinishRecord" object:nil];
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:ToolBarBGColorImg]];
    [self addSubview:self.leftBtn];
    [self addSubview:self.inputTF];
    [self addSubview:self.rightBtn];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(wself).offset(ToolBarLeftSpace);
        make.bottom.equalTo(wself).offset(-ToolBarLeftSpace);
        make.width.height.mas_equalTo(ToolBarHeight-ToolBarTopSpace).priority(300);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.leftBtn);
        make.left.equalTo(wself.leftBtn.mas_right).offset(ToolBarLeftBtnRightSpace);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(wself.leftBtn);
        make.right.equalTo(wself).offset(-ToolBarLeftSpace);
        make.left.equalTo(wself.inputTF.mas_right).offset(ToolBarRightBtnLeftSpace);
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text && textField.text.length>0) {
        [self routerEventWithName:@"SChatToolBarSendTextEvent" userInfo:@{@"text":textField.text}];
        textField.text = @"";
    }
    return YES;
}

#pragma mark action
- (void)observeChatText:(UITextField *)sender {
    // 弹出选择项时，输入无效
    if (self.rightBtn.selected) {
        sender.text = @"";
    }
}
// 右边按钮事件
- (void)rightBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.inputTF.inputView = self.chatInputView;
    }else {
        self.inputTF.inputView = nil;
    }
    [self.inputTF reloadInputViews];
    [self.inputTF becomeFirstResponder];
}

// 左边按钮事件 (录音)
- (void)leftBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        self.recordBtn.frame = self.inputTF.frame;
        [self addSubview:self.recordBtn];
    }else {
        [self.recordBtn removeFromSuperview];
    }
}

- (void)inputViewItemDidChoose {
    [self.inputTF resignFirstResponder];
}

/**
 *  完成录音
 */
- (void)inputViewDidFinishRecord:(NSNotification *)sender {
    [self leftBtnClick:self.leftBtn];
    [self routerEventWithName:@"SChatToolBarRecordDidFinishEvent" userInfo:sender.object];
}

/**
 *  取消录音
 */
- (void)cancelRecord:(UIButton *)sender {
    [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [self.recordHandle cancelRecord];
}

/**
 *  开始录音
 */
- (void)startRecord:(UIButton *)sender {
    [_recordBtn setTitle:@"向上滑动，取消录音" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    self.recordHandle = [SChatRecordHandle new];
    [self.recordHandle startRecord];
}

- (void)stopRecord:(UIButton *)sender {
    [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.recordHandle stopRecord];
}

#pragma mark getter
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:ToolBarLeftBtnNorImg] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:ToolBarLeftBtnHLightImg] forState:UIControlStateHighlighted];
        [_leftBtn setImage:[UIImage imageNamed:TollBarLeftBtnSelImg] forState:UIControlStateSelected];
        _leftBtn.selected = NO;
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:ToolBarRightBtnNorImg] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:ToolBarRightBtnHLightImg] forState:UIControlStateHighlighted];
        [_rightBtn setImage:[UIImage imageNamed:ToolBarRightBtnSelImg] forState:UIControlStateSelected];
        _rightBtn.selected = NO;
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (STextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [STextField new];
        _inputTF.placeholder = ToolBarInputViewPlaceHolder;
//        [_inputTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//        [_inputTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//        // 左边站位图
//        _inputTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _inputTF.frame.size.height)];
//        _inputTF.leftViewMode = UITextFieldViewModeAlways;
        UIImage * tempImage = [UIImage imageNamed:ToolBarInputViewBGImg];
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 10, 40) resizingMode:UIImageResizingModeStretch];
        _inputTF.background = tempImage;
        _inputTF.returnKeyType = UIReturnKeySend;
        _inputTF.delegate = self;
        [_inputTF addTarget:self action:@selector(observeChatText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTF;
}
- (SChatToolBarInputView *)chatInputView {
    if (!_chatInputView) {
        _chatInputView = [SChatToolBarInputView new];
        SChatToolBarInputSingleItem * item = [SChatToolBarInputSingleItem new];
        item.icon = @"chat_input_pic";
        item.title = @"发送照片";
        _chatInputView.allItems = @[item];
    }
    return _chatInputView;
}
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        _recordBtn.layer.cornerRadius = 5;
        
        [_recordBtn addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@ 销毁了",self.class);
}

@end
