//
//  SChatRecordDecibelView.h
//  SChatUI
//
//  Created by dufei on 16/8/2.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SChatRecordDecibelView : UIView

/**
 *  根据分贝更新ui
 *
 *  @param progress (0~1)
 */
- (void)updateDecibelImgWithProgress:(float)progress;
- (void)end;

@end
