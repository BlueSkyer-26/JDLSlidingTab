//
//  DefaultFixedVC.m
//  JDLSlidingTabDemo
//
//  Created by 胜炫电子 on 2017/12/7.
//  Copyright © 2017年 BlueSkyer-25. All rights reserved.
//

#import "DefaultFixedVC.h"
#import "JDLSlidingTab.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"

@interface DefaultFixedVC () <JDLSlidingTabTitleDelegate, JDLSlidingTabContentDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContent *pageContentView;

@end

@implementation DefaultFixedVC

- (void)dealloc {
    NSLog(@"DefaultFixedVC - - dealloc");
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
    
    NSArray *titleArr = @[@"精选", @"新建", @"QQGroup", @"429899752"];
    JDLSlidingTabConfigure *configure = [JDLSlidingTabConfigure jdl_SlidingTabConfigure];
    configure.indicatorStyle = JDLIndicatorStyleFixed;
//    configure.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
//    configure.indicatorFixedWidth = 50;
    
    self.pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 1;
    _pageTitleView.isNeedBounces = NO;
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[JDLSlidingTabContent alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(JDLSlidingTabTitle *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(JDLSlidingTabContent *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
