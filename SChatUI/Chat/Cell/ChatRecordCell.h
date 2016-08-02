//
//  ChatRecordCell.h
//  SChatUI
//
//  Created by tongxuan on 16/8/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ChatBaseCell.h"

// 录音图标的位置 (已接收方为参考,即左列)
#define RecordTopSpaceImg               10.
#define RecordLeftSpaceImg              15.
#define RecordBottomSpaceImg            15.
#define RecordImgWidth                  40.

// 录音时长和图标的间距
#define RecordTimeSpaceToImg            5.

// 最小宽度
#define RecordBuddleMinW                90.


#define RecordLeftImg                   @"chat_receive_voice_3"
#define RecordRightImg                  @"chat_send_voice_3"

@interface ChatRecordCell : ChatBaseCell

/**
 *  停止播放语音 (当播放另一条语音时，关闭其他语音)
 */
- (void)stopReplayRecord;

@end
