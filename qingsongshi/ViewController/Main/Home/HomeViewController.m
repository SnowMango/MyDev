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

#define OFFSET_CHANGE 26.0

#define CHANGE_TOOLS 35.0

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat viewOffset;
    CGFloat baseOrgHeigh;
    CGFloat tableViewSumHiegh;
    CGFloat tableViewOrgOffset;
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(autoMove:)];
    [self.view addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *tableViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(autoMove:)];
    [self.tableView addGestureRecognizer:tableViewPan];
    
    
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
    if (pan.state == UIGestureRecognizerStateBegan){
        [self tablePanBegain:offset];
        [self viewPanBegain:offset];
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        if (offset < 0) {
            if (viewOffset+ offset + baseOrgHeigh - OFFSET_CHANGE >=0 ){
                [self viewPanChange:offset];
            }else{
                offset +=  baseOrgHeigh - OFFSET_CHANGE;
                [self tablePanChange:offset];
            }
        }else{
            if (self.tableView.contentOffset.y > 0) {
                [self tablePanChange:offset];
            }else{
                if (viewOffset < 0 ) {
                    [self viewPanChange:offset];
                }else{
                    [self tablePanChange:offset];
                }
            }
        }
    }
    else{
        [self tablePanEnd:offset];
        if (self.tableView.contentOffset.y <= 0) {
            [self viewPanEnd:offset];
        }
    }
}

- (void)tablePanBegain:(CGFloat)offset
{
    tableViewOrgOffset = self.tableView.contentOffset.y;
}

- (void)viewPanBegain:(CGFloat)offset
{
    self.scrollData = @[@(_baseFuncView.height),@(_tableView.bottom), @(self.baseFuncView.top)];
}

- (void)tablePanChange:(CGFloat)offset
{
    CGFloat newY = tableViewOrgOffset - offset;
    CGPoint newOffset = {self.tableView.contentOffset.x,
        newY };
    [self.tableView setContentOffset:newOffset];
}

- (void)viewPanChange:(CGFloat)offset
{
    CGFloat toolsHeigt = CGRectGetHeight(self.otherToolsView1.frame);
    CGFloat baseHeigh = [self.scrollData[0] floatValue];
    CGFloat tableHeigh = [self.scrollData[1] floatValue];
    CGFloat baseTop = [self.scrollData[2] floatValue];
    if (offset <=  0) {
        if (baseTop + offset >= toolsHeigt - OFFSET_CHANGE) {
            self.baseFuncView.top = baseTop + offset;
        }
        if (baseHeigh + offset >= OFFSET_CHANGE) {
            self.baseFuncView.height = baseHeigh + offset;
        }
        self.moduleView.top = self.baseFuncView.bottom;
        self.tableView.top = self.moduleView.bottom;
        self.tableView.height = tableHeigh - self.tableView.top;
    }else{
        if (baseHeigh  < baseOrgHeigh) {
            if (baseHeigh + offset > baseOrgHeigh){
                self.baseFuncView.height = baseOrgHeigh;
            }else{
                self.baseFuncView.height = baseHeigh + offset;
            }
            CGFloat top = baseTop + self.baseFuncView.height - baseOrgHeigh + OFFSET_CHANGE;
            if (self.baseFuncView.height >= baseOrgHeigh - OFFSET_CHANGE &&top <= toolsHeigt) {
                self.baseFuncView.top = baseTop + self.baseFuncView.height - baseOrgHeigh + OFFSET_CHANGE;
            }
            self.moduleView.top = self.baseFuncView.bottom;
            self.tableView.top = self.moduleView.bottom;
            self.tableView.height = tableHeigh - self.tableView.top;
        }
    }
    if (self.baseFuncView.height < baseOrgHeigh) {
        CGFloat alphaOffset = baseOrgHeigh -self.baseFuncView.height;
        if (self.baseFuncView.height >= baseOrgHeigh - OFFSET_CHANGE) {
            CGFloat alpha = 1 -alphaOffset/OFFSET_CHANGE*0.5;
            for (UIView * view in self.baseFuncView.subviews) {
                view.hidden = NO;
                view.alpha =alpha;
            }
            for (UIView * view in self.otherToolsView1.subviews) {
                view.alpha =alpha;
            }
            self.otherToolsView1.hidden = NO;
            self.otherToolsView2.hidden = YES;
        }else if (self.baseFuncView.height > OFFSET_CHANGE ){
            CGFloat alpha = alphaOffset/OFFSET_CHANGE*0.5;
            alpha = alpha > 1? 1:alpha;
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
    }
}

- (CGFloat)tablePanEnd:(CGFloat)offset
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

- (void)viewPanEnd:(CGFloat)offset
{
    viewOffset += offset;
    if (- viewOffset < CHANGE_TOOLS) {
        
        [self viewStatus1];
        viewOffset = 0;
    }else if (viewOffset < baseOrgHeigh){
        [self viewStatus2];
        viewOffset = -baseOrgHeigh + OFFSET_CHANGE;
    }
    NSLog(@"viewOffset -> %.2f", viewOffset);
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

- (void)viewStatus2
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
