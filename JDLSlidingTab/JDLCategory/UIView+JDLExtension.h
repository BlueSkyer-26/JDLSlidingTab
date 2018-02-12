//
//  UIView+JDLExtension.h
//  JDLCategory
//
//  Created by 胜炫电子 on 2017/1/29.
//  Copyright © 2017年 BlueSkyer-25. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDLExtension)
@property (nonatomic) CGFloat jdl_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat jdl_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat jdl_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat jdl_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat jdl_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat jdl_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat jdl_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat jdl_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint jdl_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  jdl_size;        ///< Shortcut for frame.size.

+ (instancetype)viewFromXib;

- (BOOL)intersectWithView:(UIView *)view;
@end
