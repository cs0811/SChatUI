//
//  ChatTextModel.h
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseModel.h"

@interface ChatTextModel : ChatBaseModel

@property (nonatomic, copy) NSString * sendText;
@property (nonatomic, copy) NSString * receiveText;

@end
