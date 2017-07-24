//
//  ZFDefaultHandle.m
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "ZFDefaultHandle.h"
#import "Store.h"
@implementation ZFDefaultHandle
+(ZFDefaultHandle*)shareInstance
{
    static ZFDefaultHandle *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[ZFDefaultHandle alloc] init];
    });
    return handle;
}



- (NSArray*)handleStore
{
    NSMutableArray* dataList = [NSMutableArray array];
    NSArray * urlList = @[@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                          @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                          @"http://baobab.wdjcdn.com/14525705791193.mp4",
                          @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                          @"http://baobab.wdjcdn.com/1455968234865481297704.mp4"];
    
    NSArray * sIconURLs = @[@"http://e.hiphotos.baidu.com/zhidao/pic/item/d62a6059252dd42a24457129023b5bb5c8eab8e7.jpg",
                            @"http://pic3.zhongsou.com/image/3805136b09be936d79b.jpg",
                            @"http://d.hiphotos.baidu.com/zhidao/pic/item/10dfa9ec8a13632789e9c937938fa0ec08fac7aa.jpg",
                            @"http://t1.niutuku.com/960/25/25-320250.jpg",
                            @"http://image.it168.com/n/640x480/5/5304/5304272.jpg",
                            
                            @"http://farm5.staticflickr.com/4109/4995447265_fb490674a5.jpg",
                            @"http://k.zol-img.com.cn/dcbbs/20960/a20959415_01000.jpg",
                            @"https://img3.doubanio.com/view/photo/lphoto/public/p2260182646.jpg",
                            @"http://pic.qiantucdn.com/58pic/17/96/02/55b47f6726bbd_1024.jpg!/fw/780/watermark/url/L3dhdGVybWFyay12MS4zLnBuZw==/align/center",
                            @"http://img165.poco.cn/mypoco/myphoto/20110916/08/64330850201109160847583045587592300_004.jpg"];
    
    NSArray *dIconURLs = @[@"http://image1.caixin.cn/2011-09-16/201109160073_840_560.jpg",
                           @"http://s15.sinaimg.cn/middle/a2c9c13bhca367302a90e&690",
                           @"http://img2.niutuku.com/desk/1207/0836/ntk60315.jpg",
                           @"http://file31.mafengwo.net/M00/DE/A0/wKgBs1goj3yAVU8BACr-HCLvEbk61.jpeg",
                           @"http://img.article.pchome.net/00/44/23/20/pic_lib/wm/6.jpg"];
    for (int i = 1; i<=10; i++) {
        Store * s = [[Store alloc] init];
        s.name = @(i).stringValue;
        s.iconURL = sIconURLs[i - 1];
        for (int j =1; j <=5; j++) {
            Device *d = [[Device alloc] init];
            d.name = @(j).stringValue;
            d.sn = urlList[j - 1];
            d.store = s;
            d.iconURL = dIconURLs[j - 1];
            [s.devices addObject:d];
        }
        [dataList addObject:s];
    }

    return dataList;
}


@end
