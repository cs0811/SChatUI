//
//  SChatToolBar.h
//  SChatUI
//
//  Created by tongxuan on 16/7/28.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  左边按钮的右边距
 */
#define ToolBarLeftBtnRightSpace                5.
/**
 *  右边按钮的左边距
 */
#define ToolBarRightBtnLeftSpace                5.
/**
 *  高度
 */
#define ToolBarHeight                           50.
/**
 *  内边距（上下）
 */
#define ToolBarTopSpace                         5.
/**
 *  内边距（左右）
 */
#define ToolBarLeftSpace                        5.

/******************************************************/
// 右侧按钮
#define ToolBarLeftBtnNorImg                    @"chat_bottom_voice_press"
#define ToolBarLeftBtnHLightImg                 @""
#define TollBarLeftBtnSelImg                    @"chat_bottom_keyboard_nor"

// 左侧按钮
#define ToolBarRightBtnNorImg                   @"chat_bottom_up_nor"
#define ToolBarRightBtnHLightImg                @""     //右侧按钮通常为‘+’,不设置高亮状态
#define ToolBarRightBtnSelImg                   @"chat_bottom_keyboard_nor"

#define ToolBarInputViewBGImg                   @"chat_bottom_textfield"
#define ToolBarInputViewPlaceHolder             @"请输入您的内容"

#define ToolBarBGColorImg                       @"toolbar_bottom_bar"


@interface SChatToolBar : UIImageView


@end
