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

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *moduleView;

@end

@implementation HomeViewController
- (void)dealloc
{
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(tableViewPan:)];
    [self.tableView addGestureRecognizer:pan];

}


- (void)tableViewPan:(UIPanGestureRecognizer *)pan
{
    NSLog(@"move");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"move");
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        NSLog(@"offset.y = %@", @(offset.y));
        if (offset.y) {
            CGRect frame = self.moduleView.frame;
            frame.size.height = 120 - offset.y;
            if (frame.size.height < 0) {
                frame.size.height = 0;
            }
            self.moduleView.frame = frame;
        
//            self.moduleView.transform = CGAffineTransformMakeTranslation(0, -offset.y);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellId" forIndexPath:indexPath];
    return cell;
}



@end
