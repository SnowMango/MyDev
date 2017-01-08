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

#define OFFSET_CHANGE 30.0

#define CHANGE_TOOLS 30.0

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat viewOffset;
    CGFloat tableViewSumHiegh;
    
    CGFloat baseOrgHeigh;
    CGFloat moduleOrgHeigh;
    CGFloat tableViewOrgOffset;
    CGFloat tableViewOrgBottom;
}

@property (weak, nonatomic) IBOutlet UIView *otherToolsView1;
@property (weak, nonatomic) IBOutlet UIView *otherToolsView2;
@property (weak, nonatomic) IBOutlet UIView *baseFuncView;
@property (weak, nonatomic) IBOutlet UIView *moduleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * scrollData;


@end

@implementation HomeViewController
- (void)dealloc
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.tableView.rowHeight = 135;
    baseOrgHeigh = CGRectGetHeight(self.baseFuncView.frame);
    moduleOrgHeigh = CGRectGetHeight(self.moduleView.frame);
    tableViewOrgBottom = CGRectGetMaxY(self.tableView.frame);
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(autoMove:)];
    [self.view addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *tableViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(autoMove:)];
    [self.tableView addGestureRecognizer:tableViewPan];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
    self.tableView.tableFooterView.backgroundColor =[UIColor colorWithRed:231/255.0 green:231.0/255 blue:231/255.0 alpha:1];
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:0];
    if([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        for (int i = 0; i < count; i++) {
            tableViewSumHiegh += [self tableView:self.tableView
                         heightForRowAtIndexPath:
                                  [NSIndexPath indexPathForRow:i inSection:0]];
        }
    }else{
        tableViewSumHiegh = count*self.tableView.rowHeight;
    }
    tableViewSumHiegh += CGRectGetHeight(self.tableView.tableHeaderView.frame);
    tableViewSumHiegh += CGRectGetHeight(self.tableView.tableFooterView.frame);
    
    
}

- (void)autoMove:(UIPanGestureRecognizer *)pan
{
    CGFloat offset = [pan translationInView:self.view].y;
    CGFloat toolsHeigh = CGRectGetHeight(self.otherToolsView1.frame);
    if (pan.state == UIGestureRecognizerStateBegan){
        tableViewOrgOffset = self.tableView.contentOffset.y;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat currentOffset = viewOffset + offset;
        NSLog(@"currentOffset = %.2f", currentOffset);
        if (currentOffset < 0) {
            CGFloat maxValue = baseOrgHeigh -OFFSET_CHANGE + moduleOrgHeigh + tableViewSumHiegh - tableViewOrgBottom + toolsHeigh;
            if (maxValue + currentOffset < 0 ) {
                offset = viewOffset - maxValue  ;
                return;
            }
            [self viewPanChange:offset];
        }else {
            [self tablePanChange:-currentOffset];
        }
    }
    else{
        viewOffset += offset;
        [UIView animateWithDuration:0.25 animations:^{
            if (viewOffset > 0 || viewOffset < OFFSET_CHANGE -baseOrgHeigh -moduleOrgHeigh) {
                CGFloat tabOffset = [self tablePanEnd];
                if (viewOffset >0) {
                    viewOffset = 0;
                }else{
                    CGFloat flag = viewOffset + tabOffset -OFFSET_CHANGE +baseOrgHeigh + moduleOrgHeigh;
                    if (flag < 0) {
                        viewOffset -= flag;
                    }
                }
            }
            [self viewPanEnd];
        }];
    }
}

- (void)tablePanChange:(CGFloat)offset
{
    CGFloat newY = tableViewOrgOffset + offset;
    CGPoint newOffset = {self.tableView.contentOffset.x,
        newY };
    [self.tableView setContentOffset:newOffset];
    if (offset <-100) {
        newOffset.y = 0;
        [self.tableView setContentOffset:newOffset ];
    }
}
#pragma mark - 拖动
- (void)viewPanChange:(CGFloat)offset
{
    CGFloat toolsHeigh = CGRectGetHeight(self.otherToolsView1.frame);
    
    CGFloat currentOffset = viewOffset + offset;
    if (currentOffset >= -OFFSET_CHANGE) {
#pragma mark - step 1
        self.baseFuncView.height = baseOrgHeigh + currentOffset;
        self.baseFuncView.top = toolsHeigh + currentOffset;
        self.moduleView.top = self.baseFuncView.bottom;
        
        CGFloat alpha = 1 + currentOffset/OFFSET_CHANGE*0.5;
        for (UIView * view in self.baseFuncView.subviews) {
            view.hidden = NO;
            view.alpha =alpha;
        }
        for (UIView * view in self.otherToolsView1.subviews) {
            view.alpha =alpha;
        }
        self.otherToolsView1.hidden = NO;
        self.otherToolsView2.hidden = YES;
        
    }else if(currentOffset > OFFSET_CHANGE - baseOrgHeigh){
#pragma mark - step 2
        self.baseFuncView.top = toolsHeigh - OFFSET_CHANGE;
        self.baseFuncView.height = baseOrgHeigh + currentOffset;
        self.moduleView.top = self.baseFuncView.bottom;
        CGFloat alpha = 0.5 - (currentOffset)/( baseOrgHeigh - OFFSET_CHANGE)*0.5 ;
        for (UIView * view in self.baseFuncView.subviews) {
            view.hidden = YES;
            view.alpha = alpha;
        }
        self.otherToolsView2.hidden = NO;
        self.otherToolsView1.hidden = YES;
        for (UIView * view in self.otherToolsView2.subviews) {
            if (view.tag) {
                view.top = 54 - (54 -29)*alpha;
            }
        }
    }
    else if(currentOffset >= OFFSET_CHANGE-baseOrgHeigh - moduleOrgHeigh){
#pragma mark - step 3
        self.baseFuncView.height =  OFFSET_CHANGE;
        self.moduleView.bottom = moduleOrgHeigh+currentOffset -OFFSET_CHANGE + baseOrgHeigh + toolsHeigh;
    }else{
#pragma mark - step 4
        self.moduleView.bottom = toolsHeigh;
        CGFloat value;
        if (offset < 0) {
            value = currentOffset - OFFSET_CHANGE + baseOrgHeigh + moduleOrgHeigh;
            [self.tableView setContentOffset:CGPointMake(0, -value)];
        }else{
            value = -offset;
            [self tablePanChange:value];
        }
    }
    self.tableView.top = self.moduleView.bottom;
    self.tableView.height = tableViewOrgBottom - self.tableView.top;
}

- (CGFloat)tablePanEnd
{
    CGPoint org = {self.tableView.contentOffset.x,
        0 };
    CGFloat maxOffset = tableViewSumHiegh - CGRectGetHeight(self.tableView.frame);
    if (maxOffset <0 ) {
        maxOffset = 0;
    }
    if (self.tableView.contentOffset.y < 0) {
        [self.tableView setContentOffset:org];
    }else if (self.tableView.contentOffset.y > maxOffset){
        org.y= maxOffset;
        [self.tableView setContentOffset:org];
    }else{
        org.y= self.tableView.contentOffset.y;
    }
    return org.y;
    
}

- (void)viewPanEnd
{
    if (viewOffset > -CHANGE_TOOLS) {
        [self viewStatus1];
        viewOffset = 0;
    }else if (viewOffset > OFFSET_CHANGE -baseOrgHeigh){
        [self viewStatus3];
        viewOffset = OFFSET_CHANGE - baseOrgHeigh;
    }
}

- (void)viewStatus1
{
    for (UIView * view in self.baseFuncView.subviews) {
        view.hidden = NO;
        view.alpha = 1;
    }
    for (UIView * view in self.otherToolsView1.subviews) {
        view.alpha = 1;
    }
    CGFloat toolsHeigt = CGRectGetHeight(self.otherToolsView1.frame);
    self.otherToolsView1.hidden = NO;
    self.otherToolsView2.hidden = YES;
    self.baseFuncView.height = baseOrgHeigh;
    self.baseFuncView.top = toolsHeigt;
    self.moduleView.top = self.baseFuncView.bottom;
    self.tableView.height = self.moduleView.bottom - self.tableView.bottom;
    self.tableView.top = self.moduleView.bottom;
}

- (void)viewStatus3
{
    for (UIView * view in self.baseFuncView.subviews) {
        view.hidden = YES;
    }
    for (UIView * view in self.otherToolsView2.subviews) {
        if (view.tag) {
            view.top = 29;
        }
    }
    CGFloat toolsHeigt = CGRectGetHeight(self.otherToolsView1.frame);
    self.otherToolsView2.hidden = NO;
    self.otherToolsView1.hidden = YES;
    self.baseFuncView.height = OFFSET_CHANGE;
    self.baseFuncView.top = toolsHeigt - OFFSET_CHANGE;
    self.moduleView.top = self.baseFuncView.bottom;
    self.tableView.height = self.moduleView.bottom - self.tableView.bottom;
    self.tableView.top = self.moduleView.bottom;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @[@"HomeCellId1",@"HomeCellId2"][indexPath.row%2];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

@end
