//
//  PersonalCenterVC.m
//  JDLSlidingTabDemo
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 BlueSkyer-25. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "PersonalCenterTableView.h"
#import "PersonalCenterTopView.h"
#import "JDLSlidingTab.h"
#import "ChildVCOne.h"
#import "ChildVCTwo.h"
#import "ChildVCThree.h"
#import "UIView+JDLExtension.h"

@interface PersonalCenterVC () <UITableViewDelegate, UITableViewDataSource, JDLSlidingTabTitleDelegate, JDLSlidingTabContentDelegate, PersonalCenterChildBaseVCDelegate>
@property (nonatomic, strong) JDLSlidingTabTitle *pageTitleView;
@property (nonatomic, strong) JDLSlidingTabContent *pageContentView;
@property (nonatomic, strong) PersonalCenterTableView *tableView;
@property (nonatomic, strong) PersonalCenterTopView *topView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;

@end

@implementation PersonalCenterVC

static CGFloat const PersonalCenterVCPageTitleViewHeight = 44;
static CGFloat const PersonalCenterVCNavHeight = 64;
static CGFloat const PersonalCenterVCTopViewHeight = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self foundTableView];
}

- (void)foundTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY = PersonalCenterVCNavHeight;
    CGFloat tableViewW = self.view.frame.size.width;
    CGFloat tableViewH = self.view.frame.size.height;
    self.tableView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.tableHeaderView = self.topView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (PersonalCenterTopView *)topView {
    if (!_topView) {
        _topView = [PersonalCenterTopView viewFromXib];
        _topView.frame = CGRectMake(0, 0, 0, PersonalCenterVCTopViewHeight);
    }
    return _topView;
}

- (JDLSlidingTabTitle *)pageTitleView {
    if (!_pageTitleView) {
        NSArray *titleArr = @[@"主页", @"微博", @"相册"];
        JDLSlidingTabConfigure *configure = [JDLSlidingTabConfigure jdl_SlidingTabConfigure];

        /// pageTitleView
        _pageTitleView = [JDLSlidingTabTitle jdl_SlidingTabViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:titleArr configure:configure];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _pageTitleView;
}

- (JDLSlidingTabContent *)pageContentView {
    if (!_pageContentView) {
        ChildVCOne *oneVC = [[ChildVCOne alloc] init];
        oneVC.delegatePersonalCenterChildBaseVC = self;
        ChildVCTwo *twoVC = [[ChildVCTwo alloc] init];
        twoVC.delegatePersonalCenterChildBaseVC = self;
        ChildVCThree *threeVC = [[ChildVCThree alloc] init];
        threeVC.delegatePersonalCenterChildBaseVC = self;

        NSArray *childArr = @[oneVC, twoVC, threeVC];
        /// pageContentView
        CGFloat contentViewHeight = self.view.frame.size.height - PersonalCenterVCNavHeight - PersonalCenterVCPageTitleViewHeight;
        _pageContentView = [[JDLSlidingTabContent alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < PersonalCenterVCTopViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
}

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < PersonalCenterVCTopViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView addSubview:self.pageContentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.pageTitleView;
}

#pragma mark - - - JDLSlidingTabTitleDelegate - JDLSlidingTabContentDelegate
- (void)pageTitleView:(JDLSlidingTabTitle *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(JDLSlidingTabContent *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    _tableView.scrollEnabled = NO;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentView:(JDLSlidingTabContent *)pageContentView offsetX:(CGFloat)offsetX {
    _tableView.scrollEnabled = YES;
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
