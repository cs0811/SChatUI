//
//  ChatImageModel.h
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseModel.h"

@interface ChatImageModel : ChatBaseModel

@property (nonatomic, copy) NSString * sendImg;
@property (nonatomic, strong) UIImage * sendLocalImg;
@property (nonatomic, copy) NSString * receiveImg;

@end
