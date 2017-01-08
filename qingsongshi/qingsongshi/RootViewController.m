//
//  RootViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/7.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@interface RootViewController ()
{
    LoginViewController *login;
    MainViewController *main;
    UIViewController *currentUI;
}
@end

@implementation RootViewController

#pragma mark - Public
- (void)exitLogin
{
    [self showLoginUI];
    [main removeFromParentViewController];
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    [self addChildViewController:main];
    
}
- (void)login
{
    [self showMainUI];
}
- (void)reLogin
{
    [self showLoginUI];
}
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    login = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    
    NSArray * children = @[login, main];
    
    for (UIViewController * viewController in children) {
        [self fitFrameForChildViewController:viewController];
        [self addChildViewController:viewController];
    }
    currentUI = self.childViewControllers.firstObject;
    [self.view addSubview:currentUI.view];
}
//设置childViewControllerd的frame
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    chileViewController.view.frame = self.view.bounds;
}
- (void)showLoginUI
{
    if (![currentUI isEqual:login]) {
       [self transitionFromOldViewController:currentUI toNewViewController:login];
    }
}
- (void)showMainUI
{
    if (![currentUI isEqual:main]) {
        [self transitionFromOldViewController:currentUI toNewViewController:main];
    }
}
//切换ViewController
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController {
    
    currentUI = newViewController;
    [self transitionFromViewController:oldViewController
                      toViewController:newViewController
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil completion:^(BOOL finished)
     {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
        }else{
            currentUI = oldViewController;
        }
    }];
}
//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

#pragma mark - 旋转和状态栏
- (UIViewController *)root_topViewController
{
    UIViewController * topViewController = currentUI;
    if (currentUI) {
        while ([topViewController isKindOfClass:[UINavigationController class]]
               ||
               [topViewController isKindOfClass:[UITabBarController class]]) {
            if ([topViewController isKindOfClass:[UINavigationController class]] ) {
                topViewController = ((UINavigationController*)topViewController).topViewController;
            }else if ([topViewController isKindOfClass:[UITabBarController class]]) {
                topViewController = ((UITabBarController*)topViewController).selectedViewController;
            }
        }
    }
    return topViewController;
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return [self root_topViewController];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self root_topViewController]
            supportedInterfaceOrientations];
}
- (BOOL)shouldAutorotate
{
    return
    YES;
}


@end
