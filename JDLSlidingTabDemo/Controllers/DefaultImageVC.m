//
//  DefaultImageVC.m
//  JDLSlidingTabDemo
//
//  Created by 胜炫电子 on 2018/2/12.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import "DefaultImageVC.h"
#import "JDLSlidingTab.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "ChildVCFour.h"

@interface DefaultImageVC ()<JDLSlidingTabTitleDelegate, JDLSlidingTabContentDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContent *pageContentView;

@end

@implementation DefaultImageVC

- (void)dealloc {
    NSLog(@"DefaultStaticVC - - dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor orangeColor];
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
    
    NSArray *titleArr = @[@"精选", @"请等待2s", @"QQGroup", @"429899752"];
    JDLSlidingTabConfigure *configure = [JDLSlidingTabConfigure jdl_SlidingTabConfigure];
    configure.indicatorScrollStyle = JDLIndicatorScrollStyleDefault;
    configure.indicatorStyle =JDLIndicatorStyleFixed;
    configure.titleFont = [UIFont systemFontOfSize:15];
    configure.indicatorHeight = 5.0f;
    configure.indicatorFixedWidth =50.0f;
    configure.indicatorImage =[[UIImage imageNamed:@"LineImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.isNeedBounces = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pageTitleView resetTitleWithIndex:1 newTitle:@"等待已结束"];
    });
    
    ChildVCOne *oneVC = [[ChildVCOne alloc] init];
    ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
    ChildVCThree *threeVC = [[ChildVCThree alloc] init];
    ChildVCFour *fourVC = [[ChildVCFour alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC];
    // pageContentView
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
