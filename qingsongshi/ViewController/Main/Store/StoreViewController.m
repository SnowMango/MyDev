//
//  StoreViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "StoreViewController.h"
#import "Store.h"
#import "PlayerViewController.h"

@interface StoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray * stores;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefautData];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.stores.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Store *s = self.stores[section];
    return s.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StoreCellId"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indentationLevel = 2;
    Store *s = self.stores[indexPath.section];
    Device *device = s.devices[indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 23.0)];
    vi.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 23.0)];
    headerLabel.textColor = [UIColor colorWithRed:64/255.0 green:178/255.0 blue:169/255.0 alpha:1];
    headerLabel.font = [UIFont systemFontOfSize:15.0];
    Store *s = self.stores[section];
    headerLabel.text = [NSString stringWithFormat:@"\t%@",s.name];
    [vi addSubview:headerLabel];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *s = self.stores[indexPath.section];
    Device *device = s.devices[indexPath.row];
    PlayerViewController *vc = [UIStoryboard storyboardWithName:@"Player" bundle:nil].instantiateInitialViewController;
    vc.device = device;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:vc sender:nil];
}


#pragma mark - 

- (void)loadDefautData
{
    NSArray * store = @[@"视频门店",@"体验门店1",@"体验门店2",@"体验门店3",@"体验门店4",@"体验门店5"];
    NSArray * device = @[@"rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/shenzy001",
                         @"https://mediademo.ufile.ucloud.com.cn/ucloud_promo_140s.mp4",
                         @"http://mediademo.ufile.ucloud.com.cn/ucloud_promo_140s.mp4",
                         @"http://dlhls.cdn.zhanqi.tv/zqlive/75503_DvQw6.m3u8",
                         @"http://dlhls.cdn.zhanqi.tv/zqlive/191594_QANsL.m3u8",
                         @"http://dlhls.cdn.zhanqi.tv/zqlive/23632_1gFr7.m3u8",
                         @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                         @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                         @"http://baobab.wdjcdn.com/14564977406580.mp4",
                         @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                         @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                         @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                         @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                         @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                         @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                         @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                         @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                         @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    
    
    NSMutableArray *storeTemp = [NSMutableArray new];
    for (int i = 0; i < store.count; i++) {
        NSString *name = store[i];
        Store *s = [Store new];
        s.name = name;
        [storeTemp addObject:s];
    }
    self.stores = storeTemp;
    
    unsigned int count = ceil(device.count/3.0);
    for (int i = 0; i < count; i++) {
        if (i  < self.stores.count) {
            Store *s = self.stores[i];
            int flag = (int)device.count - i*3;
            flag = flag > 3? 3:flag;
            if ( flag >= 0) {
                for (int j = 0; j < flag; j++) {
                    Device *d = [Device new];
                    d.name = [NSString stringWithFormat:@"%@%@", @"门店视频",@(j+1)];
                    d.store = s;
                    d.sn = device[i*3+ j];
                    [s.devices addObject:d];
                }
            }
        }
    }
}


@end
