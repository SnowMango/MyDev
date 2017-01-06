//
//  HomeViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "HomeViewController.h"
#import <AVKit/AVKit.h>
#import "UIScrollView+Extension.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *otherToolsView;
@property (weak, nonatomic) IBOutlet UIView *baseFuncView;
@property (weak, nonatomic) IBOutlet UIView *moduleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign) CGFloat viewOffset;
@end

@implementation HomeViewController
- (void)dealloc
{
}
//static CGFloat height = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    self.tableView.rowHeight = 135;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)move:(UIPanGestureRecognizer *)pan
{
    
//    CGFloat offset = [pan translationInView:self.view].y;
//    if (pan.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"move %@",@(offset));
//        if (offset < 0) {
//            CGFloat h = (131+ offset)>=0? 131+ offset:0;
//            self.moduleView.height = h;
//            if (h) {
////                self.moduleView.top = self.baseFuncView.bottom;
//                self.tableView.top = self.moduleView.bottom;
//            }
//        }
//    }
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





@end
