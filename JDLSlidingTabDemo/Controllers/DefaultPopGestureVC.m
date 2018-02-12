//
//  DefaultPopGestureVC.m
//  JDLSlidingTabDemo
//
//  Created by https://github.com/BlueSkyer-26 on 2017/11/28.
//  Copyright © 2017年 BlueSkyer-26. All rights reserved.
//

#import "DefaultPopGestureVC.h"
#import "JDLSlidingTab.h"
#import "ChildFirstPopGestureVC.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildFourthPopGestureVC.h"

@interface DefaultPopGestureVC () <JDLSlidingTabTitleDelegate, JDLSlidingTabContentScrollViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContentScrollView *pageContentScrollView;

@end

@implementation DefaultPopGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self customLeftBarButtonItem];
    [self setupPageView];
}

- (void)customLeftBarButtonItem {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"back" forState:(UIControlStateNormal)];
    [button sizeToFit];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(popGesture) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    /// UINavigationControllerDelegate
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)popGesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupPageView {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[@"精选", @"电影", @"OC", @"Swift"];
    JDLSlidingTabConfigure *configure = [JDLSlidingTabConfigure jdl_SlidingTabConfigure];
    configure.indicatorAdditionalWidth = 20;
    configure.indicatorScrollStyle = JDLIndicatorScrollStyleEnd;
    
    /// pageTitleView
    self.pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    
    ChildFirstPopGestureVC *oneVC = [[ChildFirstPopGestureVC alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildFourthPopGestureVC *fourVC = [[ChildFourthPopGestureVC alloc] init];
    
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[JDLSlidingTabContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
}

- (void)pageTitleView:(JDLSlidingTabTitle *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(JDLSlidingTabContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(JDLSlidingTabContentScrollView *)pageContentScrollView offsetX:(CGFloat)offsetX {
    if (offsetX == 0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
