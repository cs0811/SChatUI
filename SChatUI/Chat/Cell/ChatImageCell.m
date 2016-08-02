//
//  ChatImageCell.m
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatImageCell.h"
#import "ChatImageModel.h"


@interface ChatImageCell ()
{
    UIImage * _largeImg;
}
@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UIImageView * rightImg;
@end

@implementation ChatImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadImgUI];
    }
    return self;
}

#pragma mark loadUI
- (void)loadImgUI {
    Wself
    
    [self addSubview:self.leftImg];
    [self addSubview:self.rightImg];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.leftBubbleView).offset(LeftSpaceImg+5);
        make.top.equalTo(wself.leftBubbleView).offset(TopSpaceImg);
        make.right.equalTo(wself.leftBubbleView).offset(-RightSpaceImg);
        make.bottom.equalTo(wself.leftBubbleView).offset(-BottomSpaceImg);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightBubbleView).offset(RightSpaceImg);
        make.top.equalTo(wself.rightBubbleView).offset(TopSpaceImg);
        make.right.equalTo(wself.rightBubbleView).offset(-LeftSpaceImg-5);
        make.bottom.equalTo(wself.rightBubbleView).offset(-BottomSpaceImg);
    }];
}

#pragma mark reloadUI
- (void)reloadUIWithData:(ChatBaseModel *)bModel {
    [super reloadUIWithData:bModel];
    
    self.leftImg.hidden = bModel.isSender;
    self.rightImg.hidden = !bModel.isSender;
    
    ChatImageModel * model = (ChatImageModel *)bModel;
    if (bModel.isSender) {
        if (model.sendLocalImg) {
            [self resizeImage:model.sendLocalImg onView:self.rightImg];
            _largeImg = model.sendLocalImg;
        }else {
            [self loadImg:model.sendImg onView:self.rightImg];
        }
        self.leftImg.image = nil;
    }else {
        [self loadImg:model.receiveImg onView:self.leftImg];
        self.rightImg.image = nil;
    }
}

// 数据加工
- (void)loadImg:(NSString *)img onView:(UIImageView *)imageView {
    Wself
    if ([img hasPrefix:@"http"] || [img rangeOfString:@"/"].location != NSNotFound) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            Sself
            [wself resizeImage:image onView:imageView];
            sself->_largeImg = image;
        }];
    }else {
        UIImage * image = [UIImage imageNamed:img];
        [self resizeImage:image onView:imageView];
        _largeImg = image;
    }
}

- (void)resizeImage:(UIImage *)image onView:(UIImageView *)imageView {
    CGFloat width = BubbleMaxWidth-LeftSpaceImg-RightSpaceImg-5;
    if (image.size.width<width) {
        width = image.size.width;
    }else if (image.size.width==width && imageView.image) {
        return;
    }
    CGFloat height = width*image.size.height/image.size.width;
    
    /*
     *  放在线程里面处理图片，不能自适应cell，未知？
     */
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    });
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), 0, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = tempImage;
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priority(300);
    }];
}

// 重写父视图方法
- (void)menuCopyBtnPressed {
    if (self.leftImg.image) {
        [UIPasteboard generalPasteboard].image = self.leftImg.image;
    }else {
        [UIPasteboard generalPasteboard].image = self.rightImg.image;
    }
}

/**
 *  展示原图
 */
- (void)showLargeImage:(UITapGestureRecognizer *)sender {
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    UIView * baseView = [UIView new];
    baseView.backgroundColor = [UIColor blackColor];
    baseView.frame = [UIScreen mainScreen].bounds;
    [window addSubview:baseView];
    
    UIImageView * largeImg = [UIImageView new];
    largeImg.userInteractionEnabled = YES;
    largeImg.image = _largeImg;
    CGFloat h = largeImg.image.size.height*ScreenWidth/largeImg.image.size.width;
    largeImg.frame = CGRectMake(0, 0, ScreenWidth, h);
    largeImg.center = window.center;
    [baseView addSubview:largeImg];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSmallImage:)];
    [baseView addGestureRecognizer:tap];
}

/**
 *  展示小图
 */
- (void)showSmallImage:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
    [sender.view.superview removeFromSuperview];
}

#pragma mark getter
- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView new];
        _leftImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLargeImage:)];
        [_leftImg addGestureRecognizer:tap];
    }
    return _leftImg;
}
- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [UIImageView new];
        _rightImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLargeImage:)];
        [_rightImg addGestureRecognizer:tap];
    }
    return _rightImg;
}


@end
