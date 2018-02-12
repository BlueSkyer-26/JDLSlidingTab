//
//  JDLSlidingTabContentScrollView.h
//  JDLSlidingTabDemo
//
//  Created by https://github.com/BlueSkyer-26 on 2018/2/12.
//  Copyright © 2018年 BlueSkyer-26. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDLSlidingTabContentScrollView;

@protocol JDLSlidingTabContentScrollViewDelegate <NSObject>
@optional
/**
 *  联动 JDLSlidingTabTitle 的方法
 *
 *  @param pageContentScrollView      JDLSlidingTabContentScrollView
 *  @param progress                   JDLSlidingTabContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(JDLSlidingTabContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  给 JDLSlidingTabContentScrollView 所在控制器提供的方法（根据偏移量来处理返回手势的问题）
 *
 *  @param pageContentScrollView     JDLSlidingTabContentScrollView
 *  @param offsetX                   JDLSlidingTabContentScrollView 内部视图的偏移量
 */
- (void)pageContentScrollView:(JDLSlidingTabContentScrollView *)pageContentScrollView offsetX:(CGFloat)offsetX;
@end

@interface JDLSlidingTabContentScrollView : UIView
/**
 *  对象方法创建 JDLSlidingTabContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 JDLSlidingTabContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)jdl_SlidingTabContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** JDLSlidingTabContentScrollViewDelegate */
@property (nonatomic, weak) id<JDLSlidingTabContentScrollViewDelegate> delegatePageContentScrollView;
/** 是否需要滚动 JDLSlidingTabContentScrollView 默认为 YES；设为 NO 时，不必设置 JDLSlidingTabContentScrollView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 给外界提供的方法，获取 JDLSlidingTabTitle 选中按钮的下标 */
- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex;

@end
