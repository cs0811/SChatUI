//
//  ChatRecordModel.h
//  SChatUI
//
//  Created by tongxuan on 16/8/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseModel.h"

@interface ChatRecordModel : ChatBaseModel

@property (nonatomic, copy) NSString * sendUrl;
@property (nonatomic, copy) NSString * receiveUrl;

/**
 *  语音时长
 */
@property (nonatomic, assign) float timeLength;

@end
