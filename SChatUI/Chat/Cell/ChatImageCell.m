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
            [wself resizeImage:image onView:imageView];
        }];
    }else {
        UIImage * image = [UIImage imageNamed:img];
        [self resizeImage:image onView:imageView];
    }
}

- (void)resizeImage:(UIImage *)image onView:(UIImageView *)imageView {
    CGFloat width = BubbleMaxWidth-LeftSpaceImg-RightSpaceImg-5;
    if (image.size.width<width) {
        width = image.size.width;
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

#pragma mark getter
- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView new];
    }
    return _leftImg;
}
- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [UIImageView new];
    }
    return _rightImg;
}


@end
