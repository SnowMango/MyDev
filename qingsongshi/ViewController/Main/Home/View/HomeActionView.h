//
//  HomeActionView.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/7.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeActionView : UIView
{
    UITapGestureRecognizer *tap;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)addTarget:(id)target seletor:(SEL)sel;
@end
