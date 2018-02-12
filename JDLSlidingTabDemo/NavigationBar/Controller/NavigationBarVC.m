//
//  NavigationBarVC.m
//  JDLSlidingTabDemo
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 BlueSkyer-26. All rights reserved.
//

#import "NavigationBarVC.h"
#import "JDLSlidingTab.h"
#import "NavigationBarTitleView.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"
#import "ChildVCFive.h"
#import "ChildVCSix.h"
#import "ChildVCSeven.h"
#import "ChildVCEight.h"
#import "ChildVCNine.h"

@interface NavigationBarVC () <JDLSlidingTabTitleDelegate, JDLSlidingTabContentDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContent *pageContentView;
@property (nonatomic, assign) BOOL isPushNextVC;
@end

@implementation NavigationBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    JDLSlidingTabConfigure *configure = [JDLSlidingTabConfigure jdl_SlidingTabConfigure];

    /// pageTitleView
    // 这里的 - 10 是为了让 JDLSlidingTabTitle 超出父视图，给用户一种效果体验
    self.pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(- 10, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.backgroundColor = [UIColor clearColor];
    // 对 navigationItem.titleView 的包装，为的是 让View 占据整个视图宽度
    NavigationBarTitleView *view = [[NavigationBarTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.navigationItem.titleView = view;
    [view addSubview:_pageTitleView];
    view.backgroundColor = [UIColor greenColor];
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    ChildVCFive *fiveVC = [[ChildVCFive alloc] init];
    ChildVCSix *sixVC = [[ChildVCSix alloc] init];
    ChildVCSeven *sevenVC = [[ChildVCSeven alloc] init];
    ChildVCEight *eightVC = [[ChildVCEight alloc] init];
    ChildVCNine *nineVC = [[ChildVCNine alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC, eightVC, nineVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 64;
    self.pageContentView = [[JDLSlidingTabContent alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}

- (void)pageTitleView:(JDLSlidingTabTitle *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(JDLSlidingTabContent *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


@end

