//
//  ChatBaseCell.h
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define Wself                           __weak typeof(self) wself = self;
#define Sself                           __strong typeof(wself) sself = wself;

#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height

/**
 *  头像到屏幕边缘的间距(左/右)
 */
#define ScreenSpaceToAuthorImage        12.
/**
 *  头像的宽高
 */
#define AuthorImageWidth                40.
/**
 *  头像到cell的间距(上/下)
 */
#define CellSpaceToAuthorImage          5.
/**
 *  头像到气泡的间距
 */
#define AuthorImageSpaceToBubble        5.
/**
 *  气泡最大宽度
 */
#define BubbleMaxWidth                  ScreenWidth-ScreenSpaceToAuthorImage-AuthorImageWidth-AuthorImageSpaceToBubble-80
/**
 *  警告图标宽高
 */
#define WarningViewW                    30.
/*********************************************************/
/**
 *  发送方默认头像
 */
#define SenderPlaceHolderImg            @"cat.jpg"
#define SenderBubbleImg                 @"send_bubber_normal"
/**
 *  接收方默认头像
 */
#define ReceiverPlaceHolderImg          @"cat.jpg"
#define ReceiverBubbleImg               @"receive_bubble_normal"

/**
 *  发送失败图片
 */
#define SendFailedImg                   @"chat_send_failed"


@class ChatBaseModel;

@interface ChatBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftBubbleView;
@property (nonatomic, strong) UIImageView * rightBubbleView;

/**
 *  加载数据 (.PS 子类重写此方法，添加各自的控件)
 */
- (void)reloadUIWithData:(ChatBaseModel *)bModel;

- (void)layoutWarningViewWithDict:(NSDictionary *)dic;

@end
