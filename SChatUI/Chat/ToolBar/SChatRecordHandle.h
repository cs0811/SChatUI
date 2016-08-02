//
//  SChatRecordHandle.h
//  SChatUI
//
//  Created by tongxuan on 16/8/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  录音最大时长 (单位 /秒)
 *
 */
#define SChatRecordMaxTime              60.


@interface SChatRecordHandle : NSObject

- (void)startRecord;

- (void)stopRecord;

- (void)cancelRecord;

/**
 *  播放录音
 */
- (void)replayRecordWithUrl:(NSString *)url;
- (void)stopReplayRecord;

@end
