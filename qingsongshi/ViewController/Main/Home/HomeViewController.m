//
//  HomeViewController.m
//  qingsongshi
//
//  Created by 郑丰 on OFFSET_CHANGE17/1/5.
//  Copyright © OFFSET_CHANGE17年 zhengfeng. All rights reserved.
//

#import "HomeViewController.h"
#import <AVKit/AVKit.h>
#import "UIScrollView+Extension.h"

#define OFFSET_CHANGE 20.0

#define OFFSET_REFRESH 64.0

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat contentViewOrgHeigh;
    CGFloat baseFuncViewOrgHeigh;
}

@property (weak, nonatomic) IBOutlet UIView *otherToolsView1;
@property (weak, nonatomic) IBOutlet UIView *otherToolsView2;
@property (weak, nonatomic) IBOutlet UIView *baseFuncView;
@property (weak, nonatomic) IBOutlet UIView *moduleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * scrollData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *scrollTableContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseFuncViewHeigh;

@property (copy, nonatomic) void (^refreshData)(void);
@property (assign) BOOL isRefreshing;

@end

@implementation HomeViewController
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.scrollView.delegate = self;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
   
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(autoMove:)];
    
    self.tableView.rowHeight = 135;
    int section = 0;
    NSInteger count = [self tableView: self.tableView numberOfRowsInSection:section];
    for (int i = 0; i< count; i++) {
        UITableViewCell* cell = [self tableView:self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:section]];
        cell.frame = CGRectMake(0, i*self.tableView.rowHeight, CGRectGetWidth(self.scrollView.frame), self.tableView.rowHeight);
        [self.scrollTableContentView addSubview:cell];
    }
    baseFuncViewOrgHeigh = CGRectGetHeight(self.baseFuncView.frame);
    contentViewOrgHeigh = baseFuncViewOrgHeigh + CGRectGetHeight(self.moduleView.frame)+10 + count*self.tableView.rowHeight;
    CGFloat heigh = CGRectGetHeight(self.scrollView.frame);
    if (contentViewOrgHeigh < heigh) {
        contentViewOrgHeigh = heigh + baseFuncViewOrgHeigh + CGRectGetHeight(self.moduleView.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame);
    }
    self.scrollContentHeigh.constant = contentViewOrgHeigh;
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) weakSelf = self;
    self.refreshData = ^(){
        [weakSelf questSeverData];
    };
}

- (void)questSeverData
{
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:10];
}


#pragma mark - KVO ScrollView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        
        [self viewPanChange:offset];
    }
}

#pragma mark - ScrollView Move
- (void)autoMove:(UIPanGestureRecognizer *)pan
{
    CGFloat offset = [pan translationInView:self.view].y;
    if  (offset > 0 && self.scrollView.contentOffset.y <=0) {
        
        if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged ) {
            if (self.isRefreshing) {
                offset += OFFSET_REFRESH;
            }
            if (offset > 200) {
                offset = 200;
            }
            self.scrollTableContentView.transform = CGAffineTransformMakeTranslation(0, offset);
        }else{
            if (offset >= OFFSET_REFRESH || self.isRefreshing) {
                if (self.refreshData && !self.isRefreshing) {
                    self.refreshData();
                }
                [self begainRefreshing];
            }else{
                [self endRefreshing];
            }
        }
    }
}

#pragma mark - Owner Refresh
- (void)endRefreshing
{
    self.isRefreshing = NO;    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollTableContentView.transform = CGAffineTransformIdentity;
    }];
    
    [self.scrollView layoutIfNeeded];
}

- (void)begainRefreshing
{
    self.isRefreshing = YES;

    [UIView animateWithDuration:0.25 animations:^{
        self.scrollTableContentView.transform = CGAffineTransformMakeTranslation(0, OFFSET_REFRESH);
    }];
    
}

#pragma mark - Scroll Animation
- (void)viewPanChange:(CGFloat)offset
{

    CGFloat currentOffset = offset;
    if (currentOffset <= OFFSET_CHANGE) {
        CGFloat alpha = 1 - currentOffset/OFFSET_CHANGE*0.5;
        if (currentOffset <= OFFSET_CHANGE) {
            self.baseFuncViewHeigh.constant = baseFuncViewOrgHeigh -currentOffset;
            self.scrollContentHeigh.constant = contentViewOrgHeigh - currentOffset;
        }
        for (UIView * view in self.baseFuncView.subviews) {
            view.hidden = NO;
            view.alpha =alpha;
        }
        for (UIView * view in self.otherToolsView1.subviews) {
            view.alpha =alpha;
        }

        self.otherToolsView1.hidden = NO;
        self.otherToolsView2.hidden = YES;
        
    }else if(currentOffset <= contentViewOrgHeigh - OFFSET_CHANGE ){
        
        CGFloat alpha = 0.5 + (currentOffset)/(baseFuncViewOrgHeigh - OFFSET_CHANGE)*0.5;
        for (UIView * view in self.otherToolsView2.subviews) {
            view.alpha =alpha;
        }
        for (UIView * view in self.baseFuncView.subviews) {
            view.hidden = YES;
        }
        self.otherToolsView2.hidden = NO;
        self.otherToolsView1.hidden = YES;
        for (UIView * view in self.otherToolsView2.subviews) {
            if (view.tag) {
                view.top = 54 - (54 -29)*alpha;
            }
        }
    }
    [self.scrollView layoutIfNeeded];
    
}

#pragma mark - Tools View Change
- (void)viewPanEnd:(CGFloat )offset
{
    if (offset < OFFSET_CHANGE) {
        [self viewStatus1];
    }else if (offset < baseFuncViewOrgHeigh - OFFSET_CHANGE ){
        [self viewStatus2];
    }
}

- (void)viewStatus1
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointZero];
    }];
}

- (void)viewStatus2
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, baseFuncViewOrgHeigh - OFFSET_CHANGE)];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @[@"HomeCellId1",@"HomeCellId2"][indexPath.row%2];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cell;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self viewPanEnd:scrollView.contentOffset.y];
}


@end
