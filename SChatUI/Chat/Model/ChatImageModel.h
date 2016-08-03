//
//  ChatImageModel.h
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseModel.h"

@interface ChatImageModel : ChatBaseModel

/**
 *  接收到网络的图
 */
@property (nonatomic, copy) NSString * sendImg;
@property (nonatomic, copy) NSString * receiveImg;

// 网络图片的宽高
@property (nonatomic, assign) float imgW;
@property (nonatomic, assign) float imgH;

/**
 *  本地读取图库发送的图
 */
@property (nonatomic, strong) UIImage * sendLocalImg;


@end
