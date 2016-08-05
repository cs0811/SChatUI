//
//  SChatToolBarInputView.h
//  SChatUI
//
//  Created by tongxuan on 16/7/29.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  item宽高比(宽/高)
 */
#define ToolBarInputViewItemRatio           3/3.5
/**
 *  左右边距
 */
#define ToolBarInputViewLeftSpace           10.
/**
 *  上下边距
 */
#define ToolBarInputViewTopSpace            10.
/**
 *  item间距（竖直）
 */
#define ToolBarInputViewItemSpaceV          5.
/**
 *  item间距（水平）
 */
#define ToolBarInputViewItemSpaceH          10.
/**
 *  每行的最大个数
 */
#define ToolBarInputViewMaxLineNum          3


@interface SChatToolBarInputSingleItem : NSObject
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * title;
@end

@interface SChatToolBarInputView : UIView

/**
 *  单个item数据的集合
 */
@property (nonatomic, strong) NSArray<SChatToolBarInputSingleItem *> * allItems;

@end
