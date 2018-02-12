//
//  JDLSlidingTabTitle.m
//  JDLSlidingTabDemo
//
//  Created by https://github.com/BlueSkyer-26 on 2017/2/11.
//  Copyright © 2017年 BlueSkyer-26. All rights reserved.
//

#import "JDLSlidingTabTitle.h"
#import "UIView+JDLExtension.h"
#import "JDLSlidingTitleButton.h"
#import "JDLSlidingTabConfigure.h"

#define JDLSlidingTabTitleViewWidth self.frame.size.width
#define JDLSlidingTabTitleViewHeight self.frame.size.height
@interface JDLSlidingTabTitle ()

/// JDLSlidingTabTitleDelegate
@property (nonatomic, weak) id<JDLSlidingTabTitleDelegate> delegatePageTitleView;
/// JDLSlidingTabTitle 配置信息
@property (nonatomic, strong) JDLSlidingTabConfigure *configure;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 指示器
@property (nonatomic, strong) UIImageView *indicatorView;
/// 底部分割线
@property (nonatomic, strong) UIView *bottomSeparator;
/// 保存外界传递过来的标题数组
@property (nonatomic, strong) NSArray *titleArr;
/// 存储标题按钮的数组
@property (nonatomic, strong) NSMutableArray *btnMArr;
/// tempBtn
@property (nonatomic, strong) UIButton *tempBtn;
/// 记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
/// 记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;
/// 标记按钮下标
@property (nonatomic, assign) NSInteger signBtnIndex;

/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@end
@implementation JDLSlidingTabTitle

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JDLSlidingTabTitleDelegate>)delegate titleNames:(NSArray *)titleNames configure:(JDLSlidingTabConfigure *)configure {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.77];
        if (delegate == nil) {
            @throw [NSException exceptionWithName:@"JDLSlidingTabTitle" reason:@"JDLSlidingTabTitle 的代理方法必须设置" userInfo:nil];
        }
        self.delegatePageTitleView = delegate;
        if (titleNames == nil) {
            @throw [NSException exceptionWithName:@"JDLSlidingTabTitle" reason:@"JDLSlidingTabTitle 的标题数组必须设置" userInfo:nil];
        }
        self.titleArr = titleNames;
        if (configure == nil) {
            @throw [NSException exceptionWithName:@"JDLSlidingTabTitle" reason:@"JDLSlidingTabTitle 的配置属性必须设置" userInfo:nil];
        }
        self.configure = configure;
        
        [self initialization];
        [self setupSubviews];
    }
    return self;
}
+ (instancetype)jdl_SlidingTabViewWithFrame:(CGRect)frame delegate:(id<JDLSlidingTabTitleDelegate>)delegate titleNames:(NSArray *)titleNames configure:(JDLSlidingTabConfigure *)configure {
    return [[self alloc] initWithFrame:frame delegate:delegate titleNames:titleNames configure:configure];
}

- (void)initialization {
    _isTitleGradientEffect = YES;
    _isOpenTitleTextZoom = NO;
    _isShowIndicator = YES;
    _isNeedBounces = YES;
    _isShowBottomSeparator = YES;
    
    _selectedIndex = 0;
    _titleTextScaling = 0.1;
}

- (void)setupSubviews {
    // 0、处理偏移量
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    // 2、添加标题按钮
    [self setupTitleButtons];
    // 3、添加底部分割线
    [self addSubview:self.bottomSeparator];
    // 4、添加指示器
    [self.scrollView insertSubview:self.indicatorView atIndex:0];
}

#pragma mark - - - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 选中按钮下标初始值
    UIButton *lastBtn = self.btnMArr.lastObject;
    if (lastBtn.tag >= _selectedIndex && _selectedIndex >= 0) {
        [self jdl_btn_action:self.btnMArr[_selectedIndex]];
    } else {
        return;
    }
}

#pragma mark - - - 懒加载
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)btnMArr {
    if (!_btnMArr) {
        _btnMArr = [NSMutableArray array];
    }
    return _btnMArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.frame = CGRectMake(0, 0, JDLSlidingTabTitleViewWidth, JDLSlidingTabTitleViewHeight);
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] init];
        if (self.configure.indicatorStyle == JDLIndicatorStyleCover) {
            CGFloat tempIndicatorViewH = [self jdl_heightWithString:[self.btnMArr[0] currentTitle] font:self.configure.titleFont];
            if (self.configure.indicatorHeight > self.jdl_height) {
                _indicatorView.jdl_bottom = 0;
                _indicatorView.jdl_height = self.jdl_height;
            } else if (self.configure.indicatorHeight < tempIndicatorViewH) {
                _indicatorView.jdl_bottom = 0.5 * (self.jdl_height - tempIndicatorViewH);
                _indicatorView.jdl_height = tempIndicatorViewH;
            } else {
                _indicatorView.jdl_bottom = 0.5 * (self.jdl_height - self.configure.indicatorHeight);
                _indicatorView.jdl_height = self.configure.indicatorHeight;
            }
            
            // 圆角处理
            if (self.configure.indicatorCornerRadius > 0.5 * _indicatorView.jdl_height) {
                _indicatorView.layer.cornerRadius = 0.5 * _indicatorView.jdl_height;
            } else {
                _indicatorView.layer.cornerRadius = self.configure.indicatorCornerRadius;
            }
            
            // 边框宽度及边框颜色
            _indicatorView.layer.borderWidth = self.configure.indicatorBorderWidth;
            _indicatorView.layer.borderColor = self.configure.indicatorBorderColor.CGColor;
            
        } else {
            CGFloat indicatorViewH = self.configure.indicatorHeight;
            _indicatorView.jdl_height = indicatorViewH;
            _indicatorView.jdl_bottom = self.jdl_height - indicatorViewH;
        }
        _indicatorView.backgroundColor = self.configure.indicatorColor;
        _indicatorView.image =self.configure.indicatorImage;
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] init];
        CGFloat bottomSeparatorW = self.jdl_width;
        CGFloat bottomSeparatorH = 0.5;
        CGFloat bottomSeparatorX = 0;
        CGFloat bottomSeparatorY = self.jdl_height - bottomSeparatorH;
        _bottomSeparator.frame = CGRectMake(bottomSeparatorX, bottomSeparatorY, bottomSeparatorW, bottomSeparatorH);
        _bottomSeparator.backgroundColor = self.configure.bottomSeparatorColor;
    }
    return _bottomSeparator;
}

#pragma mark - - - 计算字符串宽度
- (CGFloat)jdl_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
#pragma mark - - - 计算字符串高度
- (CGFloat)jdl_heightWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

#pragma mark - - - 添加标题按钮
- (void)setupTitleButtons {
    // 计算所有按钮的文字宽度
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempWidth = [self jdl_widthWithString:obj font:self.configure.titleFont];
        self.allBtnTextWidth += tempWidth;
    }];
    // 所有按钮文字宽度 ＋ 按钮之间的间隔
    self.allBtnWidth = self.configure.spacingBetweenButtons * (self.titleArr.count + 1) + self.allBtnTextWidth;
    self.allBtnWidth = ceilf(self.allBtnWidth);
    
    NSInteger titleCount = self.titleArr.count;
    if (self.allBtnWidth <= self.bounds.size.width) { // JDLSlidingTabTitle 静止样式
        CGFloat btnY = 0;
        CGFloat btnW = JDLSlidingTabTitleViewWidth / self.titleArr.count;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == JDLIndicatorStyleDefault) {
            btnH = JDLSlidingTabTitleViewHeight - self.configure.indicatorHeight;
        } else {
            btnH = JDLSlidingTabTitleViewHeight;
        }
        for (NSInteger index = 0; index < titleCount; index++) {
            JDLSlidingTitleButton *btn = [[JDLSlidingTitleButton alloc] init];
            CGFloat btnX = btnW * index;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleSelectedColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(jdl_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
            
            [self setupStartColor:self.configure.titleColor];
            [self setupEndColor:self.configure.titleSelectedColor];
        }
        self.scrollView.contentSize = CGSizeMake(JDLSlidingTabTitleViewWidth, JDLSlidingTabTitleViewHeight);
        
    } else { // JDLSlidingTabTitle 滚动样式
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnH = 0;
        if (self.configure.indicatorStyle == JDLIndicatorStyleDefault) {
            btnH = JDLSlidingTabTitleViewHeight - self.configure.indicatorHeight;
        } else {
            btnH = JDLSlidingTabTitleViewHeight;
        }
        for (NSInteger index = 0; index < titleCount; index++) {
            JDLSlidingTitleButton *btn = [[JDLSlidingTitleButton alloc] init];
            CGFloat btnW = [self jdl_widthWithString:self.titleArr[index] font:self.configure.titleFont] + self.configure.spacingBetweenButtons;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btnX = btnX + btnW;
            btn.tag = index;
            btn.titleLabel.font = self.configure.titleFont;
            [btn setTitle:self.titleArr[index] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleColor forState:(UIControlStateNormal)];
            [btn setTitleColor:self.configure.titleSelectedColor forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(jdl_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
            
            [self setupStartColor:self.configure.titleColor];
            [self setupEndColor:self.configure.titleSelectedColor];
        }
        
        CGFloat scrollViewWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, JDLSlidingTabTitleViewHeight);
    }
}

#pragma mark - - - 标题按钮的点击事件
- (void)jdl_btn_action:(UIButton *)button {
    // 1、改变按钮的选择状态
    [self jdl_changeSelectedButton:button];
    // 2、滚动标题选中按钮居中
    if (self.allBtnWidth > JDLSlidingTabTitleViewWidth) {
        [self jdl_selectedBtnCenter:button];
    }
    // 3、改变指示器的位置以及指示器宽度样式
    [self jdl_changeIndicatorViewLocationWithButton:button];
    // 4、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
        [self.delegatePageTitleView pageTitleView:self selectedIndex:button.tag];
    }
    // 5、标记按钮下标
    self.signBtnIndex = button.tag;
}

#pragma mark - - - 改变按钮的选择状态
- (void)jdl_changeSelectedButton:(UIButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    } else if (self.tempBtn != nil && self.tempBtn == button){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    } else if (self.tempBtn != button && self.tempBtn != nil){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
    // 此处作用：避免滚动内容视图时手指不离开屏幕的前提下点击按钮后再次滚动内容视图图导致按钮文字由于文字渐变导致未选中按钮文字的不标准化处理
    if (self.isTitleGradientEffect == YES) {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            btn.titleLabel.textColor = self.configure.titleColor;
        }];
    }
    
    // 标题文字缩放属性
    if (self.isOpenTitleTextZoom) {
        [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            btn.transform = CGAffineTransformMakeScale(1, 1);
        }];
        button.transform = CGAffineTransformMakeScale(1 + self.titleTextScaling, 1 + self.titleTextScaling);
    }
}

#pragma mark - - - 滚动标题选中按钮居中
- (void)jdl_selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - JDLSlidingTabTitleViewWidth * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - JDLSlidingTabTitleViewWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - - - 改变指示器的位置以及指示器宽度样式
- (void)jdl_changeIndicatorViewLocationWithButton:(UIButton *)button {
    [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
        if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
            self.indicatorView.jdl_width = self.configure.indicatorFixedWidth;
            self.indicatorView.jdl_centerX = button.jdl_centerX;
            
        } else if (self.configure.indicatorStyle == JDLIndicatorStyleDynamic) {
            self.indicatorView.jdl_width = self.configure.indicatorDynamicWidth;
            self.indicatorView.jdl_centerX = button.jdl_centerX;
            
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:button.currentTitle font:self.configure.titleFont];
            if (tempIndicatorWidth > button.jdl_width) {
                tempIndicatorWidth = button.jdl_width;
            }
            self.indicatorView.jdl_width = tempIndicatorWidth;
            self.indicatorView.jdl_centerX = button.jdl_centerX;
        }
    }];
}

#pragma mark - - - 给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    // 1、取出 originalBtn／targetBtn
    UIButton *originalBtn = self.btnMArr[originalIndex];
    UIButton *targetBtn = self.btnMArr[targetIndex];
    self.signBtnIndex = targetBtn.tag;
    // 2、 滚动标题选中居中
    [self jdl_selectedBtnCenter:targetBtn];
    // 3、处理指示器的逻辑
    if (self.allBtnWidth <= self.bounds.size.width) { /// JDLSlidingTabTitle 不可滚动
        if (self.configure.indicatorScrollStyle == JDLIndicatorScrollStyleDefault) {
            [self jdl_smallIndicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self jdl_smallIndicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
        
    } else { /// JDLSlidingTabTitle 可滚动
        if (self.configure.indicatorScrollStyle == JDLIndicatorScrollStyleDefault) {
            [self jdl_indicatorScrollStyleDefaultWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        } else {
            [self jdl_indicatorScrollStyleHalfEndWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
        }
    }
    // 4、颜色的渐变(复杂)
    if (self.isTitleGradientEffect) {
        [self jdl_isTitleGradientEffectWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
    }
    // 5 、标题文字缩放属性
    if (self.isOpenTitleTextZoom) {
        // 左边缩放
        originalBtn.transform = CGAffineTransformMakeScale((1 - progress) * self.titleTextScaling + 1, (1 - progress) * self.titleTextScaling + 1);
        // 右边缩放
        targetBtn.transform = CGAffineTransformMakeScale(progress * self.titleTextScaling + 1, progress * self.titleTextScaling + 1);
    }
}
/**
 *  根据下标重置标题文字
 *
 *  @param index 标题所对应的下标
 *  @param title 新标题名
 */
- (void)resetTitleWithIndex:(NSInteger)index newTitle:(NSString *)title {
    if (index < self.btnMArr.count) {
        UIButton *button = (UIButton *)self.btnMArr[index];
        [button setTitle:title forState:UIControlStateNormal];
        if (self.signBtnIndex == index) {
            if (self.configure.indicatorStyle == JDLIndicatorStyleDefault || self.configure.indicatorStyle == JDLIndicatorStyleCover) {
                CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:button.currentTitle font:self.configure.titleFont];
                if (tempIndicatorWidth > button.jdl_width) {
                    tempIndicatorWidth = button.jdl_width;
                }
                self.indicatorView.jdl_width = tempIndicatorWidth;
                self.indicatorView.jdl_centerX = button.jdl_centerX;
            }
        }
    }
}

#pragma mark - - - JDLSlidingTabTitle 静止样式下指示器默认滚动样式（JDLIndicatorScrollStyleDefault）
- (void)jdl_smallIndicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 1、改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self jdl_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == JDLIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        // 按钮之间的距离
        CGFloat distance = self.jdl_width / self.titleArr.count;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            if (progress <= 0.5) {
                self.indicatorView.jdl_width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.jdl_left = targetBtnIndicatorX + 2 * (progress - 1) * distance;
                self.indicatorView.jdl_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        } else {
            if (progress <= 0.5) {
                CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (distance - self.configure.indicatorDynamicWidth) - self.configure.indicatorDynamicWidth;
                self.indicatorView.jdl_left = originalBtnIndicatorX - 2 * progress * distance;
                self.indicatorView.jdl_width = self.configure.indicatorDynamicWidth + 2 * progress * distance;
            } else {
                CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (distance - self.configure.indicatorDynamicWidth);
                self.indicatorView.jdl_left = targetBtnIndicatorX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.jdl_width = self.configure.indicatorDynamicWidth + 2 * (1 - progress) * distance;
            }
        }
        
    } else if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.jdl_width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.jdl_width / self.titleArr.count - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        self.indicatorView.jdl_left = originalBtnIndicatorX + progress * totalOffsetX;
        
    } else {
        /// 1、计算 indicator 偏移量
        // targetBtn 文字宽度
        CGFloat targetBtnTextWidth = [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - targetBtnTextWidth - 0.5 * (self.jdl_width / self.titleArr.count - targetBtnTextWidth + self.configure.indicatorAdditionalWidth);
        // originalBtn 文字宽度
        CGFloat originalBtnTextWidth = [self jdl_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - originalBtnTextWidth - 0.5 * (self.jdl_width / self.titleArr.count - originalBtnTextWidth + self.configure.indicatorAdditionalWidth);
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        
        /// 2、计算文字之间差值
        // 按钮宽度的距离
        CGFloat btnWidth = self.jdl_width / self.titleArr.count;
        // targetBtn 文字右边的 x 值
        CGFloat targetBtnRightTextX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (btnWidth - targetBtnTextWidth);
        // originalBtn 文字右边的 x 值
        CGFloat originalBtnRightTextX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (btnWidth - originalBtnTextWidth);
        CGFloat totalRightTextDistance = targetBtnRightTextX - originalBtnRightTextX;
        
        // 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = totalOffsetX * progress;
        // 计算 indicatorView 滚动时文字宽度的偏移量
        CGFloat distance = progress * (totalRightTextDistance - totalOffsetX);
        
        /// 3、计算 indicatorView 新的 frame
        self.indicatorView.jdl_left = originalBtnIndicatorX + offsetX;
        
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + originalBtnTextWidth + distance;
        if (tempIndicatorWidth >= targetBtn.jdl_width) {
            CGFloat moveTotalX = targetBtn.jdl_origin.x - originalBtn.jdl_origin.x;
            CGFloat moveX = moveTotalX * progress;
            self.indicatorView.jdl_centerX = originalBtn.jdl_centerX + moveX;
        } else {
            self.indicatorView.jdl_width = tempIndicatorWidth;
        }
    }
}

#pragma mark - - - JDLSlidingTabTitle 滚动样式下指示器默认滚动样式（JDLIndicatorScrollStyleDefault）
- (void)jdl_indicatorScrollStyleDefaultWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    /// 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self jdl_changeSelectedButton:targetBtn];
    }
    
    if (self.configure.indicatorStyle == JDLIndicatorStyleDynamic) {
        NSInteger originalBtnTag = originalBtn.tag;
        NSInteger targetBtnTag = targetBtn.tag;
        if (originalBtnTag <= targetBtnTag) { // 往左滑
            // targetBtn 与 originalBtn 中心点之间的距离
            CGFloat btnCenterXDistance = targetBtn.jdl_centerX - originalBtn.jdl_centerX;
            if (progress <= 0.5) {
                self.indicatorView.jdl_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.jdl_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.jdl_left = targetBtnX + 2 * (progress - 1) * btnCenterXDistance;
                self.indicatorView.jdl_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        } else {
            // originalBtn 与 targetBtn 中心点之间的距离
            CGFloat btnCenterXDistance = originalBtn.jdl_centerX - targetBtn.jdl_centerX;
            if (progress <= 0.5) {
                CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (originalBtn.jdl_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.jdl_left = originalBtnX - 2 * progress * btnCenterXDistance;
                self.indicatorView.jdl_width = 2 * progress * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            } else {
                CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - self.configure.indicatorDynamicWidth - 0.5 * (targetBtn.jdl_width - self.configure.indicatorDynamicWidth);
                self.indicatorView.jdl_left = targetBtnX; // 这句代码必须写，防止滚动结束之后指示器位置存在偏差，这里的偏差是由于 progress >= 0.8 导致的
                self.indicatorView.jdl_width = 2 * (1 - progress) * btnCenterXDistance + self.configure.indicatorDynamicWidth;
            }
        }
        
    } else if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
        CGFloat targetBtnIndicatorX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (targetBtn.jdl_width - self.configure.indicatorFixedWidth) - self.configure.indicatorFixedWidth;
        CGFloat originalBtnIndicatorX = CGRectGetMaxX(originalBtn.frame) - self.configure.indicatorFixedWidth - 0.5 * (originalBtn.jdl_width - self.configure.indicatorFixedWidth);
        CGFloat totalOffsetX = targetBtnIndicatorX - originalBtnIndicatorX;
        CGFloat offsetX = totalOffsetX * progress;
        self.indicatorView.jdl_left = originalBtnIndicatorX + offsetX;
        
    } else {
        // 1、计算 targetBtn／originalBtn 之间的 x 差值
        CGFloat totalOffsetX = targetBtn.jdl_origin.x - originalBtn.jdl_origin.x;
        // 2、计算 targetBtn／originalBtn 之间的差值
        CGFloat totalDistance = CGRectGetMaxX(targetBtn.frame) - CGRectGetMaxX(originalBtn.frame);
        /// 计算 indicatorView 滚动时 x 的偏移量
        CGFloat offsetX = 0.0;
        /// 计算 indicatorView 滚动时宽度的偏移量
        CGFloat distance = 0.0;
        
        CGFloat targetBtnTextWidth = [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + targetBtnTextWidth;
        if (tempIndicatorWidth >= targetBtn.jdl_width) {
            offsetX = totalOffsetX * progress;
            distance = progress * (totalDistance - totalOffsetX);
            self.indicatorView.jdl_left = originalBtn.jdl_origin.x + offsetX;
            self.indicatorView.jdl_width = originalBtn.jdl_width + distance;
        } else {
            offsetX = totalOffsetX * progress + 0.5 * self.configure.spacingBetweenButtons - 0.5 * self.configure.indicatorAdditionalWidth;
            distance = progress * (totalDistance - totalOffsetX) - self.configure.spacingBetweenButtons;
            /// 计算 indicatorView 新的 frame
            self.indicatorView.jdl_left = originalBtn.jdl_origin.x + offsetX;
            self.indicatorView.jdl_width = originalBtn.jdl_width + distance + self.configure.indicatorAdditionalWidth;
        }
    }
}

#pragma mark - - - JDLSlidingTabTitle 静止样式下指示器 JDLIndicatorScrollStyleHalf 和 JDLIndicatorScrollStyleEnd 滚动样式
- (void)jdl_smallIndicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == JDLIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                    [self jdl_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                    [self jdl_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.jdl_width) {
                    self.indicatorView.jdl_width = targetBtn.jdl_width;
                } else {
                    self.indicatorView.jdl_width = tempIndicatorWidth;
                }
                self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                [self jdl_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.jdl_width) {
                    self.indicatorView.jdl_width = originalBtn.jdl_width;
                } else {
                    self.indicatorView.jdl_width = tempIndicatorWidth;
                }
                self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                [self jdl_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                [self jdl_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                [self jdl_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.jdl_width) {
                self.indicatorView.jdl_width = targetBtn.jdl_width;
            } else {
                self.indicatorView.jdl_width = tempIndicatorWidth;
            }
            self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
            [self jdl_changeSelectedButton:targetBtn];
        }];
    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.jdl_width) {
                self.indicatorView.jdl_width = originalBtn.jdl_width;
            } else {
                self.indicatorView.jdl_width = tempIndicatorWidth;
            }
            self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
            [self jdl_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - JDLSlidingTabTitle 滚动样式下指示器 JDLIndicatorScrollStyleHalf 和 JDLIndicatorScrollStyleEnd 滚动样式
- (void)jdl_indicatorScrollStyleHalfEndWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    if (self.configure.indicatorScrollStyle == JDLIndicatorScrollStyleHalf) {
        if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
            if (progress >= 0.5) {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                    [self jdl_changeSelectedButton:targetBtn];
                }];
            } else {
                [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                    self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                    [self jdl_changeSelectedButton:originalBtn];
                }];
            }
            return;
        }
        
        /// 指示器默认样式以及遮盖样式处理
        if (progress >= 0.5) {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= targetBtn.jdl_width) {
                    self.indicatorView.jdl_width = targetBtn.jdl_width;
                } else {
                    self.indicatorView.jdl_width = tempIndicatorWidth;
                }
                self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                [self jdl_changeSelectedButton:targetBtn];
            }];
        } else {
            CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                if (tempIndicatorWidth >= originalBtn.jdl_width) {
                    self.indicatorView.jdl_width = originalBtn.jdl_width;
                } else {
                    self.indicatorView.jdl_width = tempIndicatorWidth;
                }
                self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                [self jdl_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    /// 滚动内容结束指示器处理 ____ 指示器默认样式以及遮盖样式处理
    if (self.configure.indicatorStyle == JDLIndicatorStyleFixed) {
        if (progress == 1.0) {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
                [self jdl_changeSelectedButton:targetBtn];
            }];
        } else {
            [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
                self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
                [self jdl_changeSelectedButton:originalBtn];
            }];
        }
        return;
    }
    
    if (progress == 1.0) {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:targetBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= targetBtn.jdl_width) {
                self.indicatorView.jdl_width = targetBtn.jdl_width;
            } else {
                self.indicatorView.jdl_width = tempIndicatorWidth;
            }
            self.indicatorView.jdl_centerX = targetBtn.jdl_centerX;
            [self jdl_changeSelectedButton:targetBtn];
        }];
        
    } else {
        CGFloat tempIndicatorWidth = self.configure.indicatorAdditionalWidth + [self jdl_widthWithString:originalBtn.currentTitle font:self.configure.titleFont];
        [UIView animateWithDuration:self.configure.indicatorAnimationTime animations:^{
            if (tempIndicatorWidth >= originalBtn.jdl_width) {
                self.indicatorView.jdl_width = originalBtn.jdl_width;
            } else {
                self.indicatorView.jdl_width = tempIndicatorWidth;
            }
            self.indicatorView.jdl_centerX = originalBtn.jdl_centerX;
            [self jdl_changeSelectedButton:originalBtn];
        }];
    }
}

#pragma mark - - - 颜色渐变方法抽取
- (void)jdl_isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    // 获取 targetProgress
    CGFloat targetProgress = progress;
    // 获取 originalProgress
    CGFloat originalProgress = 1 - targetProgress;
    
    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
    UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
    
    // 设置文字颜色渐变
    originalBtn.titleLabel.textColor = originalColor;
    targetBtn.titleLabel.textColor = targetColor;
}

#pragma mark - - - set
- (void)setIsNeedBounces:(BOOL)isNeedBounces {
    _isNeedBounces = isNeedBounces;
    if (isNeedBounces == NO) {
        self.scrollView.bounces = NO;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (selectedIndex) {
        _selectedIndex = selectedIndex;
    }
}

- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex {
    _resetSelectedIndex = resetSelectedIndex;
    [self jdl_btn_action:self.btnMArr[resetSelectedIndex]];
}

- (void)setIsTitleGradientEffect:(BOOL)isTitleGradientEffect {
    _isTitleGradientEffect = isTitleGradientEffect;
}

- (void)setIsOpenTitleTextZoom:(BOOL)isOpenTitleTextZoom {
    _isOpenTitleTextZoom = isOpenTitleTextZoom;
}

- (void)setTitleTextScaling:(CGFloat)titleTextScaling {
    _titleTextScaling = titleTextScaling;
    
    if (titleTextScaling) {
        if (titleTextScaling >= 0.3) {
            _titleTextScaling = 0.3;
        } else {
            _titleTextScaling = 0.1;
        }
    }
}

- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator == NO) {
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

- (void)setIsShowBottomSeparator:(BOOL)isShowBottomSeparator {
    _isShowBottomSeparator = isShowBottomSeparator;
    if (isShowBottomSeparator) {
        
    } else {
        [self.bottomSeparator removeFromSuperview];
        self.bottomSeparator = nil;
    }
}

#pragma mark - - - 颜色设置的计算
/// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}
/// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end
