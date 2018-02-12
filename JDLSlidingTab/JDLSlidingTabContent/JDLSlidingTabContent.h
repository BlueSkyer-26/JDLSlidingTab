//
//  JDLSlidingTabContent.h
//  JDLSlidingTabDemo
//
//  Created by 胜炫电子 on 2018/2/12.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDLSlidingTabContent;

@protocol JDLSlidingTabContentDelegate <NSObject>
@optional
/**
 *  联动 JDLSlidingTabTitle 的方法
 *
 *  @param pageContentView      JDLSlidingTabContent
 *  @param progress             JDLSlidingTabContent 内部视图滚动时的偏移量
 *  @param originalIndex        原始视图所在下标
 *  @param targetIndex          目标视图所在下标
 */
- (void)pageContentView:(JDLSlidingTabContent *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  给 JDLSlidingTabContent 所在控制器提供的方法（根据偏移量来处理返回手势的问题）
 *
 *  @param pageContentView     JDLSlidingTabContent
 *  @param offsetX             JDLSlidingTabContent 内部视图的偏移量
 */
- (void)pageContentView:(JDLSlidingTabContent *)pageContentView offsetX:(CGFloat)offsetX;
@end

@interface JDLSlidingTabContent : UIView
/**
 *  对象方法创建 JDLSlidingTabContent
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 JDLSlidingTabContent
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)jdl_SlidingTabContentViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** JDLSlidingTabContentDelegate */
@property (nonatomic, weak) id<JDLSlidingTabContentDelegate> delegatePageContentView;
/** 是否需要滚动 JDLSlidingTabContent 默认为 YES；设为 NO 时，不必设置 JDLSlidingTabContent 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 给外界提供的方法，获取 JDLSlidingTabTitle 选中按钮的下标 */
- (void)setPageContentViewCurrentIndex:(NSInteger)currentIndex;
@end
