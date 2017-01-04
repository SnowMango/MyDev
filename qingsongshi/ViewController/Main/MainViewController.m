//
//  MainViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIViewController*)getTopViewController
{
    UIViewController *vc        = self.selectedViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController*)vc;
        vc                          = nvc.viewControllers.lastObject;
        
    }

    return vc;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSUInteger mask = [[self getTopViewController] supportedInterfaceOrientations];
    
    return mask;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
@end
