//
//  UIResponder+Router.m
//  Categorys
//
//  Created by tongxuan on 16/7/1.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
}

@end
