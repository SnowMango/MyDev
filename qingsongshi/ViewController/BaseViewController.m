//
//  BaseViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController)];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        }
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
