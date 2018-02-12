//
//  DefaultThreeCoverVC.m
//  JDLSlidingTabDemo
//
//  Created by https://github.com/BlueSkyer-26 on 2017/10/17.
//  Copyright © 2017年 BlueSkyer-26. All rights reserved.
//

#import "DefaultThreeCoverVC.h"
#import "JDLSlidingTab.h"
#import "ChildVCFull.h"

@interface DefaultThreeCoverVC () <JDLSlidingTabTitleDelegate, JDLSlidingTabContentScrollViewDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContentScrollView *pageContentView;

@end

@implementation DefaultThreeCoverVC

- (void)dealloc {
    NSLog(@"DefaultThreeCoverVC - - dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageView];
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
    configure.titleSelectedColor = [UIColor whiteColor];
    configure.indicatorStyle = JDLIndicatorStyleCover;
    configure.indicatorColor = [UIColor blackColor];
    configure.indicatorAdditionalWidth = 20; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.indicatorCornerRadius = 30; // 说明：遮盖样式下，指示器的圆角大小，若设置的圆角大于指示器高度的 1/2，则指示器的圆角为指示器高度的 1/2
    
    self.pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.selectedIndex = 1;
    _pageTitleView.isNeedBounces = NO;
    
    ChildVCFull *oneVC = [[ChildVCFull alloc] init];
    ChildVCFull *twoVC = [[ChildVCFull alloc] init];
    ChildVCFull *threeVC = [[ChildVCFull alloc] init];
    ChildVCFull *fourVC = [[ChildVCFull alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    /// pageContentView
    self.pageContentView = [[JDLSlidingTabContentScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentScrollView = self;
    [self.view insertSubview:_pageContentView atIndex:0];
}

- (void)pageTitleView:(JDLSlidingTabTitle *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(JDLSlidingTabContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
