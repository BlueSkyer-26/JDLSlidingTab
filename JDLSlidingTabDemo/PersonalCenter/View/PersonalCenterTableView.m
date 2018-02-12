//
//  PersonalCenterTableView.m
//  JDLSlidingTabDemo
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 BlueSkyer-26. All rights reserved.
//

#import "PersonalCenterTableView.h"

@implementation PersonalCenterTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
