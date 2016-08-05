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
        make.bottom.equalTo(wself.leftBubbleView).offset(-BottomSpaceImg).priority(300);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightBubbleView).offset(RightSpaceImg);
        make.top.equalTo(wself.rightBubbleView).offset(TopSpaceImg);
        make.right.equalTo(wself.rightBubbleView).offset(-LeftSpaceImg-5);
        make.bottom.equalTo(wself.rightBubbleView).offset(-BottomSpaceImg).priority(300);
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
            [self loadImg:model.sendImg onView:self.rightImg width:model.imgW height:model.imgH];
        }
        self.leftImg.image = nil;
    }else {
        [self loadImg:model.receiveImg onView:self.leftImg width:model.imgW height:model.imgH];
        self.rightImg.image = nil;
    }
}

// 数据加工
- (void)loadImg:(NSString *)img onView:(UIImageView *)imageView width:(float)width height:(float)height {
    Wself
    if ([img hasPrefix:@"http"] || [img rangeOfString:@"/"].location != NSNotFound) {
        UIImage * placeHolderImg = [self resizePlaceHolderImage:PlaceHolderImg width:width height:height];
        [imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:placeHolderImg options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [wself resizeImage:image onView:imageView];
            }
        }];
    }else {
        UIImage * image = [UIImage imageNamed:img];
        if (image) {
            [self resizeImage:image onView:imageView];
        }
    }
}

- (UIImage *)resizePlaceHolderImage:(NSString *)image width:(float)width height:(float)height {
    if (!image) {
        return nil;
    }
    UIImage * oldImg = [UIImage imageNamed:image];
    if (!oldImg) {
        return nil;
    }
    CGFloat w = BubbleMaxWidth-LeftSpaceImg-RightSpaceImg-5;
    if (width<w) {
        w = width;
    }
    CGFloat h = w*height/width;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), 0, [UIScreen mainScreen].scale);
    [oldImg drawInRect:CGRectMake(0, 0, w, h)];
    UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  tempImage;
}

- (void)resizeImage:(UIImage *)image onView:(UIImageView *)imageView {
    _largeImg = image;

    CGFloat width = BubbleMaxWidth-LeftSpaceImg-RightSpaceImg-5;
    if (image.size.width<width) {
        width = image.size.width;
    }else if (image.size.width==width && imageView.image) {
        return;
    }
    CGFloat height = width*image.size.height/image.size.width;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        UIImage * image1 = [UIImage imageWithData:imageData];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), 0, [UIScreen mainScreen].scale);
        [image1 drawInRect:CGRectMake(0, 0, width, height)];
        UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = tempImage;
        });
    });
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
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
    if (!_largeImg) {
        return;
    }
    
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
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(ScreenWidth-100, ScreenHeight-60, 80, 30);
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.borderWidth = 1;
    saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    saveBtn.layer.cornerRadius = 5;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
    [saveBtn addTarget:self action:@selector(savePic) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:saveBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSmallImage:)];
    [baseView addGestureRecognizer:tap];
}

- (void)savePic {
    if (!_largeImg) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(_largeImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

/**
 *  返回小图
 */
- (void)showSmallImage:(UITapGestureRecognizer *)sender {
    [sender.view.superview removeFromSuperview];
    [sender.view removeFromSuperview];
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
