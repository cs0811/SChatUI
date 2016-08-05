//
//  ChatBaseModel.h
//  SChatUI
//
//  Created by tongxuan on 16/7/27.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatBaseModel : NSObject

/**
 *  是否为发出方
 */
@property (nonatomic,assign) BOOL isSender;
/**
 *  发送方头像
 */
@property (nonatomic,copy) NSString * sendAuthorImg;
/**
 *  接收方头像
 */
@property (nonatomic,copy) NSString * receiveAuthorImg;


/**
 *  发送状态
 */
@property (nonatomic,assign) BOOL start;
@property (nonatomic,assign) BOOL success;
@property (nonatomic,assign) BOOL failed;
@property (nonatomic,strong) id resendData;

@end
