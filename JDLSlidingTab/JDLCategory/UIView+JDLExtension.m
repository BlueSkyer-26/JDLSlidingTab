//
//  UIView+JDLExtension.m
//  JDLCategory
//
//  Created by 胜炫电子 on 2017/1/29.
//  Copyright © 2017年 BlueSkyer-25. All rights reserved.
//

#import "UIView+JDLExtension.h"

@implementation UIView (JDLExtension)
- (CGFloat)jdl_left {
    return self.frame.origin.x;
}
-(void)setJdl_left:(CGFloat)jdl_left{
    CGRect frame = self.frame;
    frame.origin.x = jdl_left;
    self.frame = frame;
}


- (CGFloat)jdl_top {
    return self.frame.origin.y;
}

- (void)setJdl_top:(CGFloat)jdl_top {
    CGRect frame = self.frame;
    frame.origin.y = jdl_top;
    self.frame = frame;
}

- (CGFloat)jdl_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setJdl_right:(CGFloat)jdl_right {
    CGRect frame = self.frame;
    frame.origin.x = jdl_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)jdl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setJdl_bottom:(CGFloat)jdl_bottom {
    CGRect frame = self.frame;
    frame.origin.y = jdl_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)jdl_width {
    return self.frame.size.width;
}

- (void)setJdl_width:(CGFloat)jdl_width {
    CGRect frame = self.frame;
    frame.size.width = jdl_width;
    self.frame = frame;
}

- (CGFloat)jdl_height {
    return self.frame.size.height;
}

- (void)setJdl_height:(CGFloat)jdl_height {
    CGRect frame = self.frame;
    frame.size.height = jdl_height;
    self.frame = frame;
}

- (CGFloat)jdl_centerX {
    return self.center.x;
}

- (void)setJdl_centerX:(CGFloat)jdl_centerX {
    self.center = CGPointMake(jdl_centerX, self.center.y);
}

- (CGFloat)jdl_centerY {
    return self.center.y;
}

- (void)setJdl_centerY:(CGFloat)jdl_centerY {
    self.center = CGPointMake(self.center.x, jdl_centerY);
}

- (CGPoint)jdl_origin {
    return self.frame.origin;
}

- (void)setJdl_origin:(CGPoint)jdl_origin {
    CGRect frame = self.frame;
    frame.origin = jdl_origin;
    self.frame = frame;
}

- (CGSize)jdl_size {
    return self.frame.size;
}

- (void)setJdl_size:(CGSize)jdl_size {
    CGRect frame = self.frame;
    frame.size = jdl_size;
    self.frame = frame;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (BOOL)intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}
@end
