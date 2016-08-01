//
//  SChatRecordHandle.m
//  SChatUI
//
//  Created by tongxuan on 16/8/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SChatRecordHandle.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define Wself                           __weak typeof(self) wself = self;
#define Sself                           __strong typeof(wself) sself = wself;

@interface SChatRecordHandle ()<AVAudioRecorderDelegate>
{
    int _timeRepeatNum;
    BOOL _isCanceled;
    BOOL _allowRecord;
}
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation SChatRecordHandle

- (instancetype)init {
    self = [super init];
    if (self) {
        Wself
        _allowRecord = NO;
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession requestRecordPermission:^(BOOL granted) {
                Sself
                sself->_allowRecord = granted;
            }];
        }
    }
    return self;
}

/**
 *  开始录音
 */
- (void)startRecord {
    if ([self.recorder isRecording] || !_allowRecord) {
        return;
    }
    
    _timeRepeatNum = 0;
    _isCanceled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    
    //  URL是本地的URL AVAudioRecorder需要一个存储的路径
    NSString *name = [NSString stringWithFormat:@"%d.wav",(int)[NSDate date].timeIntervalSince1970];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name];
    NSError *error;
    //  录音机 初始化
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:@{AVNumberOfChannelsKey:@2,AVSampleRateKey:@44100,AVLinearPCMBitDepthKey:@32,AVEncoderAudioQualityKey:@(AVAudioQualityMax),AVEncoderBitRateKey:@128000} error:&error];
    [self.recorder prepareToRecord];
    self.recorder.delegate = self;
    [self.recorder record];

    /*
     1.AVNumberOfChannelsKey 通道数 通常为双声道 值2
     2.AVSampleRateKey 采样率 单位HZ 通常设置成44100 也就是44.1k
     3.AVLinearPCMBitDepthKey 比特率 8 16 24 32
     4.AVEncoderAudioQualityKey 声音质量
     ① AVAudioQualityMin  = 0, 最小的质量
     ② AVAudioQualityLow  = 0x20, 比较低的质量
     ③ AVAudioQualityMedium = 0x40, 中间的质量
     ④ AVAudioQualityHigh  = 0x60,高的质量
     ⑤ AVAudioQualityMax  = 0x7F 最好的质量
     5.AVEncoderBitRateKey 音频编码的比特率 单位Kbps 传输的速率 一般设置128000 也就是128kbps
     */
    
}

/**
 *  结束录音
 */
- (void)stopRecord {
    if ([self.recorder isRecording] && _allowRecord) {
        [self.recorder stop];
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  取消录音
 */
- (void)cancelRecord {
    _isCanceled = YES;
    [self stopRecord];
    [self.recorder deleteRecording];
}

/**
 *  播放录音
 */
- (void)repalyRecordWithUrl:(NSString *)url {
    NSError *error = nil;
    if (!url || url.length==0 || [url isEqual:@"<null>"]) {
        NSLog(@"语音播放地址出错");
        return;
    }
    
    NSString * hostUrl = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    if ([url rangeOfString:hostUrl].location != NSNotFound) {
        // 本地
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:url] error:&error];
    }else {
        // 网络获取
        NSData * recordData = [url dataUsingEncoding:NSUTF8StringEncoding];
        self.player = [[AVAudioPlayer alloc]initWithData:recordData error:&error];
    }
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
        [self.player setVolume:1];
        [self.player play];
    }
}

#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (_isCanceled) {
        return;
    }
    
//    NSString * url = recorder.url.absoluteString;
//    if ([url hasPrefix:@"file://"]) {
//        url = [url substringFromIndex:[url rangeOfString:@"file://"].length];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kInputViewDidFinishRecord" object:@{@"recordUrl":recorder.url.absoluteString?:@"",@"recordTime":[NSString stringWithFormat:@"%.1f",_timeRepeatNum/10.]}];
}

#pragma mark action
/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    // 限制最大录音时长
    _timeRepeatNum = _timeRepeatNum + 1;
    if (_timeRepeatNum >= SChatRecordMaxTime*10) {
        [self stopRecord];
        return;
    }
    [self.recorder updateMeters];//更新测量值
    float power= [self.recorder averagePowerForChannel:1];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    NSLog(@"power  -- %f",power);
    NSLog(@"recordProgress -- %f",progress);
}


@end
