//
//  MeViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "MeViewController.h"
#import "User.h"
#import "SDWebImageManager.h"
#import "AppDelegate.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userIconIV;
@property (weak, nonatomic) IBOutlet UILabel *NickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *roleNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userIdentifierLb;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) User * loginUser;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginUser = [User defaultUser];
    
    [self.userIconIV sd_setImageWithURL:[NSURL URLWithString:self.loginUser.iconURL]];
    self.NickNameLb.text = self.loginUser.nickname;
    self.roleNameLb.text = self.loginUser.roleName;
    self.userIdentifierLb.text = self.loginUser.identifier;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.separatorColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (void)exitLogin
{
    RootViewController *root = (RootViewController *)self.view.window.rootViewController;
    [root exitLogin];
}

#pragma mark - 缓存
- (void)clearCache
{
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

- (NSString *)cacheSize
{
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat fsize = size/1024.0/1024.0;
    return [NSString stringWithFormat:@"%.2lfMB",fsize];
}
#pragma mark - 选中是事件
- (void)selectIndex:(NSInteger)index
{
    NSLog(@"--select--%@",[self functionName][index]);
    SEL selector = NSSelectorFromString([self functionSelector][index]);
    if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:nil]);
    }
}

- (NSArray *)functionSelector
{
    return @[@"me_6",@"4a",@"line",@"me_1",@"me_3",
             @"me_2",@"line",@"clearCache",@"exitLogin"];
}
- (NSArray *)functionIcon
{
    return @[@"me_6",@"4a",@"line",@"me_1",@"me_3",
             @"me_2",@"line",@"me_4",@"me_5"];
}
- (NSArray *)functionName
{
    return @[@"我的相册",@"最近观看",@"line",@"建议反馈",@"关于我们",
             @"使用帮助",@"line",@"清除缓存",@"退出登录"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self functionIcon].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2||indexPath.row == 6) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellOtherId"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOtherId"];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeViewCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MeViewCellId"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    NSString * iconStr = [self functionIcon][indexPath.row];
    NSString * cellName = [self functionName][indexPath.row];
    NSString * info = nil;
    if (indexPath.row == [self functionIcon].count - 2) {
        info = [self cacheSize];
    }
    cell.imageView.image = [UIImage imageNamed:iconStr];
    cell.textLabel.text = cellName;
    cell.detailTextLabel.text = info;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2||indexPath.row == 6) {
        return 10;
    }
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectIndex:indexPath.row];

}

@end
