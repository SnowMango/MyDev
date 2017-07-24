//
//  StoreViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "StoreViewController.h"
#import "Store.h"
#import "SVPlayerViewController.h"


@interface StoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation StoreCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
@interface StoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray * stores;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stores = [[ZFDefaultHandle shareInstance] handleStore];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCellId" forIndexPath:indexPath];
        Store *s = self.stores[indexPath.row];
    cell.titleLb.text = s.name;
    NSURL *url = [NSURL URLWithString:s.iconURL];
    [cell.iconIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *s = self.stores[indexPath.row];
    SVPlayerViewController *vc = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateInitialViewController];
    vc.playStore = s;
    [self.navigationController showViewController:vc sender:nil];
    
}




@end
